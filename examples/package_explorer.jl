### A Pluto.jl notebook ###
# v0.20.1

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

# ╔═╡ 86f78d24-d77f-11ef-088a-fd5046de6940
begin
	using Pkg
	Pkg.activate(temp=true)
	Pkg.add("TypeTree")
	Pkg.add("PlutoUI")
	Pkg.develop(path=dirname(@__DIR__))
	
    using TypeTree: tt
	using PlutoUI

	using PlutoMonacoEditor
end

# ╔═╡ e827a813-629e-4068-80e9-6d3a4bf17e4c
begin
	# Add package
	Pkg.add("Plots")
	using Plots # Load the package which you want to learn
	# assign the target package to the variable `TargetModule`
	const TargetModule = Plots
end

# ╔═╡ bbf03cff-e963-4716-8442-d299e22c63e4
md"""
# Package Explorer

This notebook provides tools that explores functions, types in the module user specified.
"""

# ╔═╡ c26b8402-4489-451f-8cde-a16acfd95d82
begin
	objects = getproperty.(
		Ref(TargetModule), filter(names(TargetModule, all = true)
	) do s
	    startswith(repr(s), ":")
	end)

	macros = getproperty.(
		Ref(TargetModule), filter(names(TargetModule, all = true)
	) do s
	    startswith(string(s), "@")
	end)
	
	funcs = filter(objects) do obj
	    obj isa Function
	end
	
	types = filter(objects) do obj
	    obj isa DataType || obj isa UnionAll
	end
	nothing
end

# ╔═╡ e5725d61-022e-4cbe-933e-54d17ba0f146
md"""
## Print functions
"""

# ╔═╡ e00c5a44-cdbd-47da-8d65-a843892d6a55
for f in funcs
	println(f)
end

# ╔═╡ 39f12197-b911-4737-9781-9b1aa7ff3ef9
md"""
## Print macros
"""

# ╔═╡ f4b90e55-67a2-4344-be08-62e6e1c6c1a5
for m in macros
	println(m)
end

# ╔═╡ 832d1267-23c9-48c9-a8ec-4cb06609e7ce
md"""
## Print abstract types
"""

# ╔═╡ c7ac8590-aace-4e96-aebd-2a896777b7ba
for t in types
    if isabstracttype(t)
        println(t)
    end
end

# ╔═╡ ba01880a-69d8-4f4c-a710-d8c6c0d33ee7
md"""
## Print concrete types
"""

# ╔═╡ 5261de14-7a7f-4535-85c5-47c5a966743b
for t in types
    if isconcretetype(t)
        println(t)
    end
end

# ╔═╡ bc8c229e-2606-4709-89ed-339cf531b5fc
md"""
## Print type trees
"""

# ╔═╡ 19b1295f-79d1-4399-a299-f28cd667f8bf
for t in types
    if isabstracttype(t)
        println(tt(t)...)
    end
end

# ╔═╡ e0d84b69-4a19-4ffc-b87e-944134657810
md"""
## Display implementation of a macro user specified
"""

# ╔═╡ d6238b9c-83a6-47ae-9be5-c7c38622b1c5
md"""
Select a macro `m`

$(@bind ma Select(macros))
"""

# ╔═╡ 7dd6c4c4-8914-4a9a-8f21-9f7d9c99c33b
md"""
Select macro implementation

$(@bind m Select(methods(ma)))
"""

# ╔═╡ 2ad7ffdd-53be-4af0-8e30-48b0a99766d1
let
    if !isempty(methods(ma))
        initCode = join(
			readlines(string(m.file))[m.line:end], '\n'
		)
        MonacoEditor("julia", initCode, height=300)
    end
end

# ╔═╡ e7c6b40b-d4e5-4f3c-a48a-7bbcbea89c80
md"""
## Display implementation of a method user specified
"""

# ╔═╡ 65dd5e77-4ebe-4be6-bc6a-2126822040b1
md"""
Select a function `f`

$(@bind f Select(funcs))
"""

# ╔═╡ 846325a1-fbcc-4587-a510-9421ea2d5c23
md"""
Select a method for function `f`
"""

# ╔═╡ f3c472fa-ed1c-4754-be6e-24f7822199cf
if !isempty(methods(f))
	@bind m1 Select(methods(f))
end

# ╔═╡ 062d0084-8454-45b5-b395-717c03ac7eb6
let
    if !isempty(methods(f))
        initCode = join(
			readlines(string(m1.file))[m1.line:end], '\n'
		)
        MonacoEditor("julia", initCode, height=300)
    end
end

# ╔═╡ da3ea48d-f5fe-4818-a950-6495ba5aaf6e
md"""
## Print methods related to a type user specified
"""

# ╔═╡ 6f11d7b5-98b9-4496-b1f8-2409cac81e5a
methodtable = vcat(methods.(funcs)...);

# ╔═╡ 712fc1ef-5f31-4dde-8bb9-7851a82ffbad
md"""
Select a type `T` to see the methods related to `T`
"""

# ╔═╡ f0057748-f0ab-422b-9bb5-5170eeeee79d
@bind typ Select(types)

# ╔═╡ 7595aafd-0bfd-44ac-a1d0-b580bb5354b4
begin
    indices = Int[]
    typename = string(typ)
    for (i, str) in pairs(string.(methodtable))
        if occursin(typename, str)
            push!(indices, i)
        end
    end
    ms3 = unique(methodtable[indices])
	ms3
	nothing
end

# ╔═╡ ccee9b4b-467d-4f44-a940-78bbb407ef1b
md"""
You can see the implementation of the method user specified.
"""

# ╔═╡ 4f98fad2-4419-430b-8cb4-f9c0745268aa
if !isempty(ms3)
    @bind m3 Select(ms3)
end

# ╔═╡ 9c304db6-8364-4932-9d50-a14803ffa146
let
    if !isempty(ms3)
        initCode = join(
			readlines(string(m3.file))[m3.line:end], '\n'
		)
        MonacoEditor("julia", initCode, height=300)
    end
end

# ╔═╡ Cell order:
# ╟─bbf03cff-e963-4716-8442-d299e22c63e4
# ╠═86f78d24-d77f-11ef-088a-fd5046de6940
# ╠═e827a813-629e-4068-80e9-6d3a4bf17e4c
# ╠═c26b8402-4489-451f-8cde-a16acfd95d82
# ╟─e5725d61-022e-4cbe-933e-54d17ba0f146
# ╟─e00c5a44-cdbd-47da-8d65-a843892d6a55
# ╟─39f12197-b911-4737-9781-9b1aa7ff3ef9
# ╠═f4b90e55-67a2-4344-be08-62e6e1c6c1a5
# ╟─832d1267-23c9-48c9-a8ec-4cb06609e7ce
# ╟─c7ac8590-aace-4e96-aebd-2a896777b7ba
# ╟─ba01880a-69d8-4f4c-a710-d8c6c0d33ee7
# ╟─5261de14-7a7f-4535-85c5-47c5a966743b
# ╟─bc8c229e-2606-4709-89ed-339cf531b5fc
# ╟─19b1295f-79d1-4399-a299-f28cd667f8bf
# ╟─e0d84b69-4a19-4ffc-b87e-944134657810
# ╟─d6238b9c-83a6-47ae-9be5-c7c38622b1c5
# ╟─7dd6c4c4-8914-4a9a-8f21-9f7d9c99c33b
# ╟─2ad7ffdd-53be-4af0-8e30-48b0a99766d1
# ╟─e7c6b40b-d4e5-4f3c-a48a-7bbcbea89c80
# ╟─65dd5e77-4ebe-4be6-bc6a-2126822040b1
# ╟─846325a1-fbcc-4587-a510-9421ea2d5c23
# ╟─f3c472fa-ed1c-4754-be6e-24f7822199cf
# ╟─062d0084-8454-45b5-b395-717c03ac7eb6
# ╟─da3ea48d-f5fe-4818-a950-6495ba5aaf6e
# ╠═6f11d7b5-98b9-4496-b1f8-2409cac81e5a
# ╟─712fc1ef-5f31-4dde-8bb9-7851a82ffbad
# ╟─f0057748-f0ab-422b-9bb5-5170eeeee79d
# ╟─7595aafd-0bfd-44ac-a1d0-b580bb5354b4
# ╟─ccee9b4b-467d-4f44-a940-78bbb407ef1b
# ╟─4f98fad2-4419-430b-8cb4-f9c0745268aa
# ╟─9c304db6-8364-4932-9d50-a14803ffa146
