module PlutoMonacoEditor

using Base64: base64encode

using HypertextLiteral

function MonacoEditor(language::AbstractString, initCode::AbstractString; width::Int=700, height::Int=200, theme::AbstractString="vs-dark")
	@htl """
<div>
	<style>
        .pluto-monaco-editor {
            width: $(width)px;
            height: $(height)px;
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
		value: decodeBase64($(base64encode(initCode))),
		language: $(language),
		theme: $(theme)
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
end

end # module PlutoMonacoEditor
