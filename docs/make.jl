using SurfaceReactions
using Documenter

DocMeta.setdocmeta!(SurfaceReactions, :DocTestSetup, :(using SurfaceReactions); recursive=true)

makedocs(;
    modules=[SurfaceReactions],
    authors="Vinod Janardhanan",
    repo="https://github.com/vinodjanardhanan/SurfaceReactions.jl/blob/{commit}{path}#{line}",
    sitename="SurfaceReactions.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://vinodjanardhanan.github.io/SurfaceReactions.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/vinodjanardhanan/SurfaceReactions.jl",
    devbranch="main",
)
