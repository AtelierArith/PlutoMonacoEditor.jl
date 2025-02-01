module PlutoMonacoEditor

using Base64: base64encode

using HypertextLiteral

export MonacoEditor

function MonacoEditor(
    language::AbstractString,
    initCode::AbstractString;
    width::Int = 700,
    height::Int = 200,
    theme::AbstractString = "vs-dark",
)
    @htl """
   <span>
   	<style>
           .pluto-monaco-editor {
               width: $(width)px;
               height: $(height)px;
               border: 1px solid #ddd;
           }
       </style>
   	<div id='monaco-editor-container' class='pluto-monaco-editor'></div>

   <script>
   	const monaco = await import('https://cdn.jsdelivr.net/npm/monaco-editor@0.52.0/+esm');
    	
   	const monEditor = monaco.editor.create(document.getElementById('monaco-editor-container'), {
   		value: $(initCode),
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
   </span>
   """
end

end # module PlutoMonacoEditor
