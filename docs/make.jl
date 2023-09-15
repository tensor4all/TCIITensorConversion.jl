using TCIITensorConversion
using Documenter

DocMeta.setdocmeta!(TCIITensorConversion,
    :DocTestSetup,
    :(using TCIITensorConversion);
    recursive=true)

makedocs(;
    modules=[TCIITensorConversion],
    authors="Ritter.Marc <Ritter.Marc@physik.uni-muenchen.de> and contributors",
    repo="https://gitlab.com/Ritter.Marc/TCIITensorConversion.jl/blob/{commit}{path}#{line}",
    sitename="TCIITensorConversion.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://Ritter.Marc.gitlab.io/TCIITensorConversion.jl",
        edit_link="main",
        assets=String[]),
    pages=[
        "Home" => "index.md"
    ])
