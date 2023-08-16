
"""
    MPS(tt, siteindices...)

Convert a tensor train to an ITensor MPS

 * `tt`            Tensor train
 * `siteindices`   Arrays of ITensor Index objects.

 If `siteindices` is left empty, a default set of indices will be used.
"""
function ITensors.MPS(tt::TCI.TensorTrain{T}; sites=nothing)::MPS where {T}
    N = length(tt)
    localdims = [size(t, 2) for t in tt]

    if sites === nothing
        sites = [Index(localdims[n], "n=$n") for n in 1:N]
    else
        all(localdims .== dim.(sites)) ||
            error("ranks are not consistent with dimension of sites")
    end

    linkdims = [[size(t, 1) for t in tt]..., 1]
    links = [Index(linkdims[l + 1], "link,l=$l") for l in 0:N]

    tensors_ = [ITensor(deepcopy(tt[n]), links[n], sites[n], links[n + 1])
                for n in 1:N]
    tensors_[1] *= onehot(links[1] => 1)
    tensors_[end] *= onehot(links[end] => 1)

    return MPS(tensors_)
end

function ITensors.MPS(tci::TCI.AbstractTensorTrain{T}; sites=nothing)::MPS where {T}
    MPS(TCI.tensortrain(tci), sites=sites)
end

"""
    function TCI.TensorTrain(mps::ITensors.MPS)

Converts an ITensor MPS object into a TensorTrain. Note that this only works if the MPS has a single leg per site! Otherwise, use [`TCI.TensorTrain(mps::ITensors.MPO)`](@ref).
"""
function TCI.TensorTrain(mps::ITensors.MPS)
    links = linkinds(mps)
    sites = siteinds(mps)
    Tfirst = zeros(ComplexF64, 1, dim(sites[1]), dim(links[1]))
    Tfirst[1, :, :] = Array(mps[1], sites[1], links[1])
    Tlast =  zeros(ComplexF64, dim(links[end]), dim(sites[end]), 1)
    Tlast[:, :, 1] = Array(mps[end], links[end], sites[end])
    return TCI.TensorTrain{ComplexF64,3}(
        vcat(
            [Tfirst],
            [Array(mps[i], links[i-1], sites[i], links[i]) for i in 2:length(mps)-1],
            [Tlast]
        )
    )
end

"""
    function TCI.TensorTrain(mps::ITensors.MPO)

Convertes an ITensor MPO object into a TensorTrain.
"""
function TCI.TensorTrain{V, N}(mps::ITensors.MPO) where {N, V}
    links = linkinds(mps)
    sites = siteinds(mps)

    Tfirst = zeros(ComplexF64, 1, dim.(sites[1])..., dim(links[1]))
    Tfirst[1, fill(Colon(), length(sites[1]) + 1)...] = Array(mps[1], sites[1]..., links[1])

    Tlast =  zeros(ComplexF64, dim(links[end]), dim.(sites[end])..., 1)
    Tlast[fill(Colon(), length(sites[end]) + 1)..., 1] = Array(mps[end], links[end], sites[end]...)

    return TCI.TensorTrain{V, N}(
        vcat(
            Array{V, N}[Tfirst],
            Array{V, N}[Array(mps[i], links[i-1], sites[i]..., links[i]) for i in 2:length(mps)-1],
            Array{V, N}[Tlast]
        )
    )
end
