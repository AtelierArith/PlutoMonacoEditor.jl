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
    using PlutoMonacoEditor: MonacoEditor
end

# ╔═╡ 9aa40f8c-a955-47a3-8e6d-4ac54d1dc330
md"""
# Markdown editor on Pluto Notebook

"""

# ╔═╡ bf232d99-3001-4aac-afb7-1321c7407666
begin
    initCode = """
    # Hello

    ```math
    \\alpha = \\beta + \\gamma
    ```

    """
    @bind mdsrc MonacoEditor("markdown", initCode)
end

# ╔═╡ dce616d7-fdfe-4854-919d-420603ebc875
Markdown.parse(mdsrc)

# ╔═╡ af5152cb-eb5d-4b3b-9660-b3891c0b660c
md"""
See also [PlutoEditorColorThemes.jl](https://github.com/AtelierArith/PlutoEditorColorThemes.jl)
"""

# ╔═╡ Cell order:
# ╟─9aa40f8c-a955-47a3-8e6d-4ac54d1dc330
# ╠═07ebdbbe-49bb-4d18-9f2b-14f98d137548
# ╟─bf232d99-3001-4aac-afb7-1321c7407666
# ╠═dce616d7-fdfe-4854-919d-420603ebc875
# ╟─af5152cb-eb5d-4b3b-9660-b3891c0b660c
