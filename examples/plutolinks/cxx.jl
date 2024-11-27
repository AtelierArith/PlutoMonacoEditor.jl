### A Pluto.jl notebook ###
# v0.19.46

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ 07ebdbbe-49bb-4d18-9f2b-14f98d137548
begin
	using Pkg
	Pkg.activate(temp=true)
	Pkg.add("PlutoLinks")
	Pkg.develop(path=dirname(dirname(@__DIR__)))
	using PlutoLinks
	using PlutoMonacoEditor: MonacoEditor
end

# ╔═╡ 9aa40f8c-a955-47a3-8e6d-4ac54d1dc330
md"""
# C++ editor on Pluto Notebook

To run this notebook, you need to install `g++` command, a C++ compiler.
"""

# ╔═╡ 7f6f04ef-b875-45d3-8e25-fad4a1e4de90
begin
	#=
	The PlutoLinks.jl package provides `@use_file` macro. This watches a file and reload the content when it changes. Try adding the following code in your Pluto notebook:
	=#
	targetfile = "main.cpp"
	initCode = @use_file targetfile
	nothing
end

# ╔═╡ 4428e48e-d18c-4d8d-ae2e-39379fde6216
begin
	editor = @bind sourcecode MonacoEditor("cpp", initCode)
end

# ╔═╡ dce616d7-fdfe-4854-919d-420603ebc875
begin
	write(targetfile, sourcecode)
	executablepath = abspath("main")
	try
		run(`g++ -O2 -o $(executablepath) $(targetfile)`)
		println(readchomp(`$(executablepath)`))
		rm(executablepath)
	catch e
		e isa ProcessFailedException || rethrow()
	end
	nothing
end

# ╔═╡ 7b8519b8-9236-4564-93a8-41d08097291a
md"""

The following code is executed behind the scenes.

```julia
begin
	write(targetfile, sourcecode)
	executablepath = abspath("main")
	try
		run(`g++ -O2 -o $(executablepath) $(targetfile)`)
		println(readchomp(`$(executablepath)`))
		rm(executablepath)
	catch e
		e isa ProcessFailedException || rethrow()
	end
	nothing
end
```
"""

# ╔═╡ Cell order:
# ╟─9aa40f8c-a955-47a3-8e6d-4ac54d1dc330
# ╠═07ebdbbe-49bb-4d18-9f2b-14f98d137548
# ╠═7f6f04ef-b875-45d3-8e25-fad4a1e4de90
# ╠═4428e48e-d18c-4d8d-ae2e-39379fde6216
# ╟─dce616d7-fdfe-4854-919d-420603ebc875
# ╟─7b8519b8-9236-4564-93a8-41d08097291a
