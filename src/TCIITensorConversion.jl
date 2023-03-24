module TCIITensorConversion

import TensorCrossInterpolation
using ITensors
import ITensors: MPS

export MPS
export evaluate_mps

include("ttmpsconversion.jl")
include("mpsutil.jl")

end
