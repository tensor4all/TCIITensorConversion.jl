
"""
    MPS(tt, siteindices...)

Convert a tensor train to an ITensor MPS

 * `tt`            Tensor train as an array of tensors
 * `siteindices`   Arrays of ITensor Index objects.
 * `cutends`       Whether to remove the bond dimension 1 links at each end of the MPS.

 If `siteindices` is left empty, a default set of indices all named "site" will be used.
"""
function MPS(
    tt::Vector{Array{V, 3}},
    siteindices::Vector{ITensors.Index}=ITensors.Index[];
    cutends=false
) where V
    n = length(tt)

    if isempty(siteindices)
        siteindices = [Index(size(t, 2), "site") for t in tt]
    end

    ttmps = ITensors.MPS(n)
    links =
        [
            Index(1, "link"),
            [Index(size(t, 3), "link") for t in tt]...
        ]

    for i in 1:n
        ttmps[i] = ITensor(
            tt[i],
            links[i],
            siteindices[i],
            links[i+1]
        )
    end

    return ttmps
end
