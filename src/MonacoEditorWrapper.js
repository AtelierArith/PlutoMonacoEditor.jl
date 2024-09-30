require.config({ paths: { 'vs': 'https://cdnjs.cloudflare.com/ajax/libs/monaco-editor/0.51.0/min/vs/' } });

class MonacoEditorWrapper {
        constructor(container, initialValue, language, monacoPath) {
            this.container = container;
            this.initialValue = initialValue;
            this.language = language;
            this.monacoPath = monacoPath || 'https://cdnjs.cloudflare.com/ajax/libs/monaco-editor/0.51.0/min/vs/';
            this.editor = null;
            this.init();
        }

        init() {
            require.config({ paths: { 'vs': this.monacoPath } });
            require(['vs/editor/editor.main'], () => {
                this.editor = monaco.editor.create(this.container, {
                    value: this.initialValue,
                    language: this.language,
                    theme: 'vs-dark', // お好みでテーマを変更できます
                    automaticLayout: true // レイアウトの自動調整を有効にします
                });
            });
        }

        getValue() {
            return this.editor ? this.editor.getValue() : '';
        }
}
