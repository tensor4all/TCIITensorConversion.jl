"""
    function TCI.TensorTrain{V}(mps::ITensorMPS.MPS)
    function TCI.TensorTrain(mps::ITensorMPS.MPS)

Converts an ITensor MPS object into a TensorTrain. Note that this only works if the MPS has a single leg per site! Otherwise, use [`TCI.TensorTrain(mps::ITensorMPS.MPO)`](@ref).
"""
function TCI.TensorTrain{V}(mps::ITensorMPS.MPS) where {V}
    links = ITensorMPS.linkinds(mps)
    sites = ITensors.SiteTypes.siteinds(mps)
    Tfirst = zeros(V, 1, dim(sites[1]), dim(links[1]))
    Tfirst[1, :, :] = Array(mps[1], sites[1], links[1])
    Tlast =  zeros(V, dim(links[end]), dim(sites[end]), 1)
    Tlast[:, :, 1] = Array(mps[end], links[end], sites[end])
    return TCI.TensorTrain{V,3}(
        vcat(
            [Tfirst],
            [Array(mps[i], links[i-1], sites[i], links[i]) for i in 2:length(mps)-1],
            [Tlast]
        )
    )
end
