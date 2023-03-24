
@testset "TCIITensorConversion.jl" begin
    @testset "TT to MPS conversion" begin
        tt = [rand(1, 4, 4), rand(4, 4, 2), rand(2, 4, 7), rand(7, 4, 1)]
        mps = ITensors.MPS(tt)
        @test linkdims(mps) == [4, 2, 7]
    end
end
