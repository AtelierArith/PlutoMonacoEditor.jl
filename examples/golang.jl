### A Pluto.jl notebook ###
# v0.20.5

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    #! format: off
    return quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
    #! format: on
end

# ╔═╡ ba23917e-f0b2-11ef-19d8-87ba0db1a59b
begin
	using Libdl
	using PlutoMonacoEditor: MonacoEditor
end

# ╔═╡ 22890e9a-1361-4e43-9445-4c251759038b
md"""
# Calling Go functions from Julia

The programing language Go can outputs a shared library exposing Go functions as a C-style APIs. See Vladimir Vivien's blog post [Calling Go Functions from Other Languages](https://medium.com/learning-the-go-programming-language/calling-go-functions-from-other-languages-4c7d8bcc69bf#.n73as5d6d).

This Pluto notebook demonstrates calling Go functions from Julia using the `@ccall` macro. 
"""

# ╔═╡ c032fd12-54ef-4b55-bd74-050573ba5814
md"""
You need to install Go to be able to use the go command.
"""

# ╔═╡ 9149cdba-4b16-40fc-8896-7f39dd35d682
begin
	run(`go version`)
	nothing
end

# ╔═╡ a22d6f1b-ee4e-4376-a7e1-b5c16f2e5524
md"""
The following Go code exports a function named `calcpi`.
"""

# ╔═╡ eab8e0ca-9f2e-4b9a-93bf-9f4bf3477f60
begin
	ext = ".go"
    targetfile = joinpath(first(split(@__FILE__, ".jl#==#"))) * ext
	isfile(targetfile) || touch(targetfile)
	initCode = join(readlines(targetfile), '\n')
    @bind sourcecode MonacoEditor("go", initCode, height = 600)
end

# ╔═╡ 9979a235-1ecd-41cd-af61-c821cf7af043
md"""
We can generate a shared library from the above Go code with the following command:

```sh
$ go build -o libcalcpi.dylib -buildmode=c-shared golang.go
```

Since I use macOS in my daily life, the extension of a shared library is `.dylib`.
If you are using Linux, that should be `.so`.

Julia has the `@ccall` macro which loads the generated shared library and calls functions within it. See the official Julia [documentation](https://docs.julialang.org/en/v1/manual/calling-c-and-fortran-code/) to learn more about the `@ccall` macro.
"""

# ╔═╡ 6374a435-8995-47df-aa5f-55ecb0d30814
md"""
Let's call the `calcpi` function.

```julia
N = 5000
@ccall "libcalcpi.dylib".calcpi(N::Cint)::Cdouble
```

This should output `3.141...`.
"""

# ╔═╡ 094ce4b7-c100-4236-a53e-bf4cc20b3cc6
N = 5000 # You can change the value.

# ╔═╡ 4c748a1b-a546-4718-aa62-69628fe71955
md"""
Expand the cell below to see what we do behind the scenes.
"""

# ╔═╡ 2e445ceb-6f9a-45db-9670-9a15a84b00a9
begin
	const libpath = Ref("")
	let
		shouldrun = false
		if initCode != sourcecode
			# Update file
			write(targetfile, sourcecode)
			# If updated, we should run code
			shouldrun = true
		end
		if shouldrun
			mktempdir() do d
				_libname = "lib"
				_libname *= (targetfile |> basename |> splitext |> first)
				_libname *= "." * dlext
				libpath[] = joinpath(d, _libname)
				write(joinpath(d, targetfile), sourcecode)
				try
					run(`go build -o $(libpath[]) -buildmode=c-shared $(joinpath(d, targetfile))`)
					@assert isfile(libpath[])
					println(@ccall (libpath[]).calcpi(N::Cint)::Cdouble)
				catch e
					e isa ProcessFailedException || rethrow(e)
				end
			end
		end
		nothing
	end
end

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Libdl = "8f399da3-3557-5675-b5ff-fb832c97cbdb"
PlutoMonacoEditor = "5e943eae-10d2-4eb3-ad1e-58d3f2e9614f"

[compat]
PlutoMonacoEditor = "~0.1.4"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.11.4"
manifest_format = "2.0"
project_hash = "5bebffef363dbc76af898633cdb23352e3c71cbb"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"
version = "1.11.0"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "7134810b1afce04bbc1045ca1985fbe81ce17653"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.5"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"
version = "1.11.0"

[[deps.PlutoMonacoEditor]]
deps = ["Base64", "HypertextLiteral"]
git-tree-sha1 = "014591c4fe6fa17465ed68a6bbf182be5ba84d2a"
uuid = "5e943eae-10d2-4eb3-ad1e-58d3f2e9614f"
version = "0.1.4"

[[deps.Tricks]]
git-tree-sha1 = "6cae795a5a9313bbb4f60683f7263318fc7d1505"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.10"
"""

# ╔═╡ Cell order:
# ╟─22890e9a-1361-4e43-9445-4c251759038b
# ╟─c032fd12-54ef-4b55-bd74-050573ba5814
# ╟─9149cdba-4b16-40fc-8896-7f39dd35d682
# ╠═ba23917e-f0b2-11ef-19d8-87ba0db1a59b
# ╟─a22d6f1b-ee4e-4376-a7e1-b5c16f2e5524
# ╟─eab8e0ca-9f2e-4b9a-93bf-9f4bf3477f60
# ╟─9979a235-1ecd-41cd-af61-c821cf7af043
# ╟─6374a435-8995-47df-aa5f-55ecb0d30814
# ╠═094ce4b7-c100-4236-a53e-bf4cc20b3cc6
# ╟─4c748a1b-a546-4718-aa62-69628fe71955
# ╟─2e445ceb-6f9a-45db-9670-9a15a84b00a9
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
