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

# ╔═╡ bd78df3c-f571-11ef-042f-117e25a0517f
begin
    using Pkg
    Pkg.activate(temp = true)
    Pkg.develop(path = dirname(@__DIR__))
	Pkg.add("PlutoUI")
	Pkg.add("HypertextLiteral")
    using PlutoMonacoEditor: MonacoEditor
	using PlutoUI
	using HypertextLiteral: @htl
end

# ╔═╡ 00f86189-7a8a-404f-b350-5f423eca6fe5
md"""
# CSS and JavaScript playground on Pluto Notebook with PlutoMonacoEditor
"""

# ╔═╡ 9d6bd569-8831-4586-b935-0b1918944693
md"""
## CSS editor
"""

# ╔═╡ 54916b00-7253-4d7f-913e-553e24f8524b
begin
	init_style_css = """
/* Style the heading to appear in green */
#hello {
  color: green;
}
"""
	@bind css_source MonacoEditor("css", init_style_css, height=120)
end

# ╔═╡ b8ceb231-88dc-4394-b134-19974b5b1fc3
md"""
## JavaScript editor
"""

# ╔═╡ 933f202e-1de2-451e-894a-2dfe54dab84d
begin
	init_javascript_file = """
// Change the heading text to "Hello World from JavaScript!"

// update me
myTextContent = "Hello World from JavaScript";
document.getElementById("hello")
		.textContent = myTextContent;

"""
	@bind javascript_source MonacoEditor("javascript", init_javascript_file, height=150)
end

# ╔═╡ 67169922-bab6-41b3-bc6d-3e8f925ae828
md"""
## HTML Output

If you replace `color: green` with `color: red`, in the CSS editor, it will output a red-colored text "Hello World from JavaScript".

If you update the variable `myTextContent` in the JavaScript editor, the following text will be updated.
"""

# ╔═╡ bbd3174b-3c3c-49aa-8b2a-a1f7d9489e60
mktempdir() do d
	javascript_path = joinpath(d, "script.js")
	css_path = joinpath(d, "style.css")
	html_path = joinpath(d, "index.hhtml")
	
	write(javascript_path, javascript_source)
	write(css_path, css_source)

	html_source = @htl """
	<html lang="en">
	<head>
	  <meta charset="UTF-8">
	  <title>Hello World Example</title>
	  <!-- Link the external CSS file -->
	  <link rel="stylesheet" href="$(LocalResource(css_path).src)">
	</head>
	<body>
	  <!-- A heading element to display text -->
	  <h1 id="hello">Hello from HTML</h1>
	
	  <!-- Reference the external JavaScript file -->
	 <script src="$(LocalResource(javascript_path).src)"></script>
	</body>
	</html>
    """
end

# ╔═╡ Cell order:
# ╟─00f86189-7a8a-404f-b350-5f423eca6fe5
# ╠═bd78df3c-f571-11ef-042f-117e25a0517f
# ╟─9d6bd569-8831-4586-b935-0b1918944693
# ╟─54916b00-7253-4d7f-913e-553e24f8524b
# ╟─b8ceb231-88dc-4394-b134-19974b5b1fc3
# ╟─933f202e-1de2-451e-894a-2dfe54dab84d
# ╟─67169922-bab6-41b3-bc6d-3e8f925ae828
# ╟─bbd3174b-3c3c-49aa-8b2a-a1f7d9489e60
