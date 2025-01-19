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
    Pkg.add(["PythonCall", "CondaPkg"])
    Pkg.develop(path = dirname(@__DIR__))
    using CondaPkg
    CondaPkg.add("numpy")
    using PythonCall
    using PlutoMonacoEditor: MonacoEditor
end

# ╔═╡ 9aa40f8c-a955-47a3-8e6d-4ac54d1dc330
md"""
# Python editor on Pluto Notebook

To run this notebook, you need to install `g++` command, a C++ compiler.
"""

# ╔═╡ 7d458d1e-bc9f-4f3b-abb3-c8b817cd7d73
md"""
The following code is executed behind the scenes.

```julia
begin
    targetfile = joinpath(dirname(first(split(@__FILE__, ".jl#==#"))), "main.py")
    initCode = join(readlines(targetfile), '\n')
    @bind sourcecode MonacoEditor("python", initCode, height = 300)
end
```
"""

# ╔═╡ 4428e48e-d18c-4d8d-ae2e-39379fde6216
begin
    targetfile = joinpath(dirname(first(split(@__FILE__, ".jl#==#"))), "main.py")
    initCode = join(readlines(targetfile), '\n')
    @bind sourcecode MonacoEditor("python", initCode, height = 300)
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
                try
                    python = PythonCall.C.CTX.exe_path
                    run(`$python $(joinpath(d, targetfile))`)
                catch e
                    e isa ProcessFailedException || rethrow(e)
                end
            end
        end
    end
end

# ╔═╡ 7b8519b8-9236-4564-93a8-41d08097291a
md"""

The following code is executed behind the scenes.

```julia
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
                try
                    python = PythonCall.C.CTX.exe_path
                    run(`$python $(joinpath(d, targetfile))`)
                catch e
                    e isa ProcessFailedException || rethrow(e)
                end
            end
        end
    end
end
```
"""

# ╔═╡ Cell order:
# ╟─9aa40f8c-a955-47a3-8e6d-4ac54d1dc330
# ╠═07ebdbbe-49bb-4d18-9f2b-14f98d137548
# ╟─7d458d1e-bc9f-4f3b-abb3-c8b817cd7d73
# ╟─4428e48e-d18c-4d8d-ae2e-39379fde6216
# ╟─dce616d7-fdfe-4854-919d-420603ebc875
# ╟─7b8519b8-9236-4564-93a8-41d08097291a
