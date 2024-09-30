module PlutoMonacoEditor

using HypertextLiteral
using Base64
using MIMEs
using URIs

include("PlutoUIResource.jl")

function MonacoEditor(initCode, language)
	@htl """
<span>
	<style>
        .pluto-monaco-editor {
            width: 800px;
            height: 200px;
            border: 1px solid #ddd;
        }
    </style>
	<div id='editor-container' class='pluto-monaco-editor'></div>

	<script src="https://cdnjs.cloudflare.com/ajax/libs/require.js/2.3.7/require.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/monaco-editor/0.51.0/min/vs/loader.min.js"></script>

	<!-- This LocalResource hack is required to avoid getting errors due to content parsing in MonacoEditorWrapper.js. -->
	$(LocalResource(joinpath(pkgdir(@__MODULE__), "src", "MonacoEditorWrapper.js")))

	<script>
		const wrapper_span = currentScript.parentElement;
		const container = wrapper_span.querySelector("#editor-container");
		const w = new MonacoEditorWrapper(container, $(initCode), $(language));
		const pE = w.container.parentElement;
		function updateEditorValue() {
			pE.dispatchEvent(new CustomEvent("update"));
			pE.value = w.editor ? w.editor.getValue() : $(initCode);
		}

		w.container.addEventListener("input", e=>{
			updateEditorValue();
		})

		updateEditorValue();
	</script>
</span>
"""
end

end # module PlutoMonacoEditor
