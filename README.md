# TCIITensorConversion

[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://tensor4all.github.io/TCIITensorConversion.jl/dev)
[![CI](https://github.com/tensor4all/TCIITensorConversion.jl/actions/workflows/CI.yml/badge.svg)](https://github.com/tensor4all/TCIITensorConversion.jl/actions/workflows/CI.yml)

This package provides conversions between TensorTrain objects in `TensorCrossInterpolation.jl` and MPS/MPO objects in `ITensors.jl`.

## Usage
### From TCI2 to TT and ITensorMPS.MPS
We first construct a TCI2 object:
```julia
import QuanticsGrids as QG
using QuanticsTCI: quanticscrossinterpolate

B = 2^(-30) # global variable
function f(x)
    return cos(x/B) * cos(x/(4*sqrt(5)*B)) * exp(-x^2) + 2 * exp(-x)
end

R = 40 # number of bits
xmin = 0.0
xmax = 3.0
qgrid = QG.DiscretizedGrid{1}(R, xmin, xmax; includeendpoint=false)
ci, ranks, errors = quanticscrossinterpolate(Float64, f, qgrid; maxbonddim=15)
```

One can create a tensor train object from the TCI2 object, and then convert it to an ITensor MPS:

```julia
import TensorCrossInterpolation as TCI

# Construct a TensorTrain object from the TensorCI2 object
tt = TCI.TensorTrain(ci.tci)

# Convert the TensorTrain object to an ITensorMPS MPS object
using TCIITensorConversion
using ITensorMPS: MPS

M = MPS(tt)
```

### TT to MPO conversion and back

```julia
using ITensorMPS: MPO, dim, siteinds
import TensorCrossInterpolation as TCI
using TCIITensorConversion

tt = TCI.TensorTrain([rand(1, 4, 3, 4), rand(4, 2, 4, 2), rand(2, 5, 1, 7), rand(7, 9, 4, 1)])
mpo = MPO(tt)
@assert linkdims(mpo) == [4, 2, 7]
@assert dim.(siteinds(mpo)[1]) == [4, 3]
@assert dim.(siteinds(mpo)[2]) == [2, 4]
@assert dim.(siteinds(mpo)[3]) == [5, 1]
@assert dim.(siteinds(mpo)[4]) == [9, 4]

tt2 = TCI.TensorTrain{Float64, 4}(mpo)
@assert all(tt2[i] == tt[i] for i in 1:length(tt))

sites = reverse.(siteinds(mpo))
ttreverse = TCI.TensorTrain{Float64, 4}(mpo, sites=sites)
@assert all(permutedims(ttreverse[i], [1, 3, 2, 4]) == tt[i] for i in 1:length(tt))
```
