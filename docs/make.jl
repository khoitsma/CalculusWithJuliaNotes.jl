using Documenter
using ArgParse

using CalculusWithJuliaNotes
using CalculusWithJulia
using Weave
using Pkg
import Markdown
import Pluto

include("weave-support.jl")
include("markdown-to-pluto.jl")

## The command line gathers
## folder[=nothing], file[=nothing], target[=html], force[=false]
function parse_commandline()
    s = ArgParseSettings()

    @add_arg_table! s begin
        "--folder", "-F"
        help = "Input folder name"
        default = nothing
        "--file", "-f"
        help = "Input file name"
        default = nothing
        "--target", "-o"
        help="target type: html, weave_html, ipynb, "
        default = "html"
        "--force"
        help = "Force compliation"
        default = "false"
    end

    return parse_args(s)
end

# what to build
function build_pages(folder=nothing, file=nothing, target=:html, force=false)
    build_list = (target, )
    if folder != nothing && file !=nothing
        weave_file(folder, file * ".jmd", build_list=build_list, force=force)
    elseif folder != nothing
        if folder == "all"
            weave_all(; build_list=build_list, force=all)
        else
            weave_folder(folder, build_list = build_list, force=force)
        end
    elseif force
        weave_all(; build_list=build_list, force=true)
    end
end

# build pages
d = parse_commandline()
folder, file = d["folder"], d["file"]
target = Symbol(d["target"])
force = parse(Bool, d["force"])


if isnothing(folder) && isnothing(file)
    # # build full thing
    # for folder ∈ ("precalc", "limits", "derivatives", "integrals", "ODEs",
    #               "differentiable_vector_calculus", "integral_vector_calculus")
    #     build_pages(folder, nothing, target, force)
    # end

    # # others need to integrate with Pluto
    # for folder ∈ ("alternatives", "misc")
    #     build_pages(folder, nothing, "weave_html", force)
    # end
    build_pages("precalc", "functions", "html", true)
    build_pages("misc", nothing, "weave_html", true)
    toc = joinpath("build", "misc", "toc.html")
    cp(toc, joinpath("build","index.html"), force=true)
else
    build_pages(folder, file, target, force)
end




# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.
#=
Documenter.deploydocs(
    repo = "github.com/jverzani/CalculusWithJuliaNotes.jl"
)
=#