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
	Pkg.add("PythonCall")
	Pkg.add("CondaPkg")
	
	# Load PlutoMonacoEditor package
	Pkg.develop(path=dirname(@__DIR__))

	using CondaPkg
	using PythonCall
	
	using PlutoMonacoEditor: MonacoEditor
end

# ╔═╡ 9aa40f8c-a955-47a3-8e6d-4ac54d1dc330
md"""
# Python editor on Pluto Notebook
"""

# ╔═╡ 3b4f5287-edfe-4d93-a0c1-f206f5da9ca7
begin
	# Install Python dependencies
	CondaPkg.add_pip("numpy")
end

# ╔═╡ bf232d99-3001-4aac-afb7-1321c7407666
begin
	initCode = """
	import numpy as np
	def my_python_api():
		return np.random.random((3, 3))
	"""
	@bind sourcecode MonacoEditor("python", initCode)
end

# ╔═╡ 31e9189a-de9d-472d-8f7d-9d2935fbffb4
md"""
This binds Julia variable `pythoncode` and an instance of Monaco Editor. If one update the content of the Monaco Editor, the value of `pythoncode` is updated to the content. Pluto Notebook will re run cells related to `pythoncode`.
"""

# ╔═╡ 3af14431-6464-458e-a3d6-9a268b9f9349
begin
	function loadpythonmodule(sourcecode)
		write("mylib.py", sourcecode)
		importlib = pyimport("importlib")
		pyimport("sys")."path".append(@__DIR__)
		mylib = pyimport("mylib")
		importlib.reload(mylib)
		mylib
	end
	
	mylib = loadpythonmodule(sourcecode)
	nothing
end

# ╔═╡ 00014af8-c64b-4aad-b478-3b9ec36810da
begin
	np_arr = mylib.my_python_api()
	@assert pyconvert(Bool, np_arr.shape == pytuple((3, 3)))
end

# ╔═╡ Cell order:
# ╟─9aa40f8c-a955-47a3-8e6d-4ac54d1dc330
# ╠═07ebdbbe-49bb-4d18-9f2b-14f98d137548
# ╠═3b4f5287-edfe-4d93-a0c1-f206f5da9ca7
# ╟─bf232d99-3001-4aac-afb7-1321c7407666
# ╟─31e9189a-de9d-472d-8f7d-9d2935fbffb4
# ╠═3af14431-6464-458e-a3d6-9a268b9f9349
# ╠═00014af8-c64b-4aad-b478-3b9ec36810da
