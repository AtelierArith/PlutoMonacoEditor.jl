### A Pluto.jl notebook ###
# v0.20.4

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    #! format: off
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
    #! format: on
end

# ╔═╡ 07ebdbbe-49bb-4d18-9f2b-14f98d137548
begin
    using Pkg
    Pkg.activate(temp = true)
    Pkg.develop(path = dirname(@__DIR__))
    Pkg.add("Deno_jll")

    using PlutoMonacoEditor: MonacoEditor
    using Deno_jll
end

# ╔═╡ 9aa40f8c-a955-47a3-8e6d-4ac54d1dc330
md"""
# TypeScript Editor on Pluto Notebook

Here we use Deno as a TypeScript runtime.

What is deno? ↓↓↓

> Deno (/ˈdiːnoʊ/, pronounced dee-no) is an open source JavaScript, TypeScript, and WebAssembly runtime with secure defaults and a great developer experience. It's built on V8, Rust, and Tokio.
>
> https://docs.deno.com/runtime/#install-deno
"""

# ╔═╡ bf232d99-3001-4aac-afb7-1321c7407666
begin
    targetfile = joinpath(dirname(first(split(@__FILE__, ".jl#==#"))), "main.ts")
    initCode = join(readlines(targetfile), '\n')
    @bind sourcecode MonacoEditor("typescript", initCode, height = 200)
end

# ╔═╡ dce616d7-fdfe-4854-919d-420603ebc875
let
    shouldrun = false
    if !ismissing(sourcecode)
        if initCode != sourcecode
            # Update file
            write(targetfile, sourcecode)
            # If updated, we should run code
            shouldrun = true
        end
        if shouldrun
            mktempdir() do d
                write(joinpath(d, targetfile), sourcecode)
				deno = Deno_jll.deno()
                try
                    run(`$(deno) run $(joinpath(d, targetfile))`)
                catch e
                    e isa ProcessFailedException || rethrow(e)
                end
            end
        end
    end
end

# ╔═╡ Cell order:
# ╟─9aa40f8c-a955-47a3-8e6d-4ac54d1dc330
# ╠═07ebdbbe-49bb-4d18-9f2b-14f98d137548
# ╠═bf232d99-3001-4aac-afb7-1321c7407666
# ╠═dce616d7-fdfe-4854-919d-420603ebc875
