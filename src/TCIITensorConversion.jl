module TCIITensorConversion

import TensorCrossInterpolation as TCI
using ITensors
using Reexport: @reexport
import ITensorMPS
@reexport using ITensorMPS: MPS

export evaluate_mps

# TensorCrossInterpolation >= 0.9 ships the MPS <-> TensorTrain / MPO
# conversions in its own `TCIITensorConversion` extension. Defining them here
# as well overwrites the extension's methods, which aborts module
# precompilation on Julia >= 1.12 ("Method overwriting is not permitted during
# Module precompilation"). Keep the local copy only as a fallback for
# TensorCrossInterpolation versions without that extension.
include("ttmpsconversion_eltype.jl")
if !hasmethod(TCI.TensorTrain, Tuple{ITensorMPS.MPS})
    include("ttmpsconversion.jl")
end
include("mpsutil.jl")

end
