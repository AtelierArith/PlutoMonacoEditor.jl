### A Pluto.jl notebook ###
# v0.20.3

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

# ╔═╡ 71271f51-f697-4647-bad4-55116e352168
begin
	using Base64: base64encode
	using Deno_jll
	using HypertextLiteral: @htl
end

# ╔═╡ 77368643-d7b4-48f4-a200-4910b1e9847d
md"""
Let's see the following discussion works on my machine
https://github.com/JuliaPluto/featured/pull/75#issuecomment-2488178774
"""

# ╔═╡ a39253f7-2f48-4281-bbf4-981bc027fc44
defaultcode = raw"""
function greet(name: string): string{
	return `Hello Julian, ${name}!`;
}
console.log(greet("Update me"));
"""

# ╔═╡ 9f65f836-bf39-11ef-304d-d3ae5cb4b441
@bind sourcecode @htl """
<div>
	<style>
        .pluto-monaco-editor {
            width: 800px;
            height: 200px;
            border: 1px solid #ddd;
        }
    </style>
	<div id='monaco-editor-container' class='pluto-monaco-editor'></div>

<script>
	function decodeBase64(base64String) {
	    const prefix = "data:text/plain;base64,";
	    if (base64String.startsWith(prefix)) {
	        base64String = base64String.slice(prefix.length);
	    }
	    const decodedData = atob(base64String);
	    return decodedData;
	}

	const monaco = await import('https://cdn.jsdelivr.net/npm/monaco-editor@0.52.0/+esm');
 	
	const monEditor = monaco.editor.create(document.getElementById('monaco-editor-container'), {
		value: decodeBase64($(base64encode(defaultcode))),
		language: 'typescript'
	});

	const pE = currentScript.parentElement;
	function update_bond() {
		pE.value = monEditor.getValue();
		pE.dispatchEvent(new CustomEvent("update"));
	}
	
	const myEditor = pE.querySelector("#monaco-editor-container");
	myEditor.addEventListener("input", e=>{
		update_bond();
	})
	
	update_bond();
</script>
</div>
"""

# ╔═╡ d10f79f7-13ec-4391-8a11-11d80662c570
println(sourcecode)

# ╔═╡ b75424fe-20ee-4a32-bdec-bd688890d6fa
mktempdir() do d
	script = joinpath(d, "main.ts")
	write(script, sourcecode)
	deno = Deno_jll.deno()
	run(`$(deno) run $(script)`);
end

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Base64 = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"
Deno_jll = "04572ae6-984a-583e-9378-9577a1c2574d"
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"

[compat]
Deno_jll = "~2.0.0"
HypertextLiteral = "~0.9.5"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.11.2"
manifest_format = "2.0"
project_hash = "d8de772ad7f086a28cace1e84fd91e49285e272c"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"
version = "1.11.0"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"
version = "1.11.0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"
version = "1.11.0"

[[deps.Deno_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "7e2908b0979fcf7375db8b7613cb348b31be8ad8"
uuid = "04572ae6-984a-583e-9378-9577a1c2574d"
version = "2.0.0+0"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "7134810b1afce04bbc1045ca1985fbe81ce17653"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.5"

[[deps.JLLWrappers]]
deps = ["Artifacts", "Preferences"]
git-tree-sha1 = "be3dc50a92e5a386872a493a10050136d4703f9b"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.6.1"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"
version = "1.11.0"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "9306f6085165d270f7e3db02af26a400d580f5c6"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.3"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"
version = "1.11.0"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.Tricks]]
git-tree-sha1 = "7822b97e99a1672bfb1b49b668a6d46d58d8cbcb"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.9"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"
version = "1.11.0"
"""

# ╔═╡ Cell order:
# ╟─77368643-d7b4-48f4-a200-4910b1e9847d
# ╠═71271f51-f697-4647-bad4-55116e352168
# ╠═a39253f7-2f48-4281-bbf4-981bc027fc44
# ╠═9f65f836-bf39-11ef-304d-d3ae5cb4b441
# ╠═d10f79f7-13ec-4391-8a11-11d80662c570
# ╠═b75424fe-20ee-4a32-bdec-bd688890d6fa
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
