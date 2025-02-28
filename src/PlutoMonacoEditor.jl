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
    <div id='monaco-editor-container' style="width: $(width)px; height: $(height)px; border: 1px solid #ddd;"></div>

    <script>
        const monaco = await import('https://cdn.jsdelivr.net/npm/monaco-editor@0.52.0/+esm');
        const wrapper_span = currentScript.parentElement
        const monEditor = monaco.editor.create(wrapper_span.querySelector('div#monaco-editor-container'), {
            value: $(initCode),
            language: $(language),
            theme: $(theme)
        });

        function update_bond() {
            wrapper_span.value = monEditor.getValue();
            wrapper_span.dispatchEvent(new CustomEvent("update"));
        }

        const myEditor = wrapper_span.querySelector("#monaco-editor-container");
        myEditor.addEventListener("input", e=>{
            update_bond();
        })

        update_bond();
    </script>
    </span>
   """
end

end # module PlutoMonacoEditor
