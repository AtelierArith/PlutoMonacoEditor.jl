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
	Pkg.add("HypertextLiteral")
	Pkg.develop(path=dirname(@__DIR__))
	using HypertextLiteral
	
	using PlutoMonacoEditor: MonacoEditor
end

# ╔═╡ 9aa40f8c-a955-47a3-8e6d-4ac54d1dc330
md"""
# React live editor on Pluto Notebook
"""

# ╔═╡ bf232d99-3001-4aac-afb7-1321c7407666
begin
initCode = raw"""
const App = () => {
    return (
    <div>
        <h1>My React App with CDN</h1>
        <h2>My Julia package PlutoMonacoEditor.jl supports:</h2>
		<li>Rust</li>
		<li>Rust script</li>
		<li>Python</li>
		<li>TypeScript/Deno</li>
		<li>F#</li>
		<li>React</li>
    </div>
    )
}

"""
	@bind sourcecode MonacoEditor("javascript", initCode, height=300)
end

# ╔═╡ dce616d7-fdfe-4854-919d-420603ebc875
begin
	htmlpre = raw"""
	<html>
	<head>
	  <meta charset="utf-8">
	  <meta name="viewport" content="width=device-width">
	  <title>React!</title>
	  <script src="https://unpkg.com/react@18/umd/react.production.min.js" crossorigin></script>
	  <script src="https://unpkg.com/react-dom@18/umd/react-dom.production.min.js" crossorigin></script>
	  <script src="https://unpkg.com/babel-standalone@6/babel.min.js"></script>  
		<style>
			#root {
				height: 300px;
			}
		</style>
	</head>
	<body>
	<div id="root"></div>
	<script type="text/babel">
	"""
	
	htmlpost = raw"""
	const container = document.getElementById("root");
	const root = ReactDOM.createRoot(container);
	root.render(<App />);
	</script>
	  
	</body>
	</html>
	"""
	HTML(htmlpre * "\n" * sourcecode * "\n" * htmlpost)
end

# ╔═╡ Cell order:
# ╟─9aa40f8c-a955-47a3-8e6d-4ac54d1dc330
# ╠═07ebdbbe-49bb-4d18-9f2b-14f98d137548
# ╟─bf232d99-3001-4aac-afb7-1321c7407666
# ╟─dce616d7-fdfe-4854-919d-420603ebc875
