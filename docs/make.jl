using TCIITensorConversion
using Documenter

DocMeta.setdocmeta!(TCIITensorConversion, :DocTestSetup, :(using TCIITensorConversion); recursive=true)

makedocs(;
    modules=[TCIITensorConversion],
    authors="Ritter.Marc <Ritter.Marc@physik.uni-muenchen.de> and contributors",
    sitename="TCIITensorConversion.jl",
    format=Documenter.HTML(;
        canonical="https://github.com/tensor4all/TCIITensorConversion.jl",
        edit_link="main",
        assets=String[]),
    pages=[
        "Home" => "index.md",
    ])

deploydocs(;
    repo="github.com/tensor4all/TCIITensorConversion.jl.git",
    devbranch="main",
)
