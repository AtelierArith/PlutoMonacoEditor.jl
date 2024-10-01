# [PlutoMonacoEditor.jl](https://github.com/AtelierArith/PlutoMonacoEditor.jl)

## Description

[This repository](https://github.com/AtelierArith/PlutoMonacoEditor.jl) provides an editor for writing non-Julia source code on top of the Pluto Notebook. This editor is the [Monaco Editor](https://github.com/microsoft/monaco-editor) itself.
If you want to write code on top of Pluto Notebook for non-Julia source code, try this repository.

<img width="800" alt="image" src="https://github.com/user-attachments/assets/531961f8-228a-4fbb-9ea7-2c82c94810ac">

## Python editor

```julia-repl
julia> # TL;DR
julia> using Pluto; Pluto.run(notebook="examples/python.jl")
```

Prepare the following code to set up an instance of Monaco Editor.

```julia
begin
	using CondaPkg
	CondaPkg.add_pip("numpy")
	using PythonCall
end
```

```julia
begin
	initCode = """
	import numpy as np
	def myapi():
		return np.random.random((2, 3))

	"""
	@bind pythoncode MonacoEditor("python", initCode)
end
```

The `@bind` macro connects the value of `MonacoEditor("pythno", initCode)` and Julia variable `pythoncode`.
As an application, to compile the source code `pythoncode`, Add the following code to your Pluto Notebook:

```julia
begin
	function loadpythonmodule(pythoncode)
		open("mylib.py", "w") do io
			print(io, pythoncode)
		end
		importlib = pyimport("importlib")
		pyimport("sys")."path".append(@__DIR__)
		mylib = pyimport("mylib")
		importlib.reload(mylib)
		mylib
	end
	
	mylib = loadpythonmodule(pythoncode)
end
```

This defines a Python module as `mylib`. We can call an function in this module with:

```julia
println(mylib.myapi())
```

### Rust editor

```julia-repl
julia> # TL;DR
julia> using Pluto; Pluto.run(notebook="examples/rust.jl")
```

Prepare the following code to set up an instance of Monaco Editor.

```julia
begin
	initCode = """
	fn main(){
		println!("Hello");
	}
	"""
	@bind rustcode MonacoEditor("rust", initCode)
end
```

The `@bind` macro connects the value of `MonacoEditor("rust", initCode)` and Julia variable `rustcode`.
As an application, to compile the source code `rustcode`, Add the following code to your Pluto Notebook:

```julia
mktempdir() do d
	sourcepath = joinpath(d, "main.rs")
	open(sourcepath, "w") do io
		write(io, rustcode)
	end	
	executablepath = joinpath(d, "main")
	try
		run(`rustc $(sourcepath) -o $(executablepath)`)
		println(readchomp(`$(executablepath)`))
	catch 
	end
end
```

## Appendix

- [Why I created this package](https://htmlview.glitch.me/?https://gist.github.com/terasakisatoshi/d2e7397a1e88a4f0cb6dad41b20a7d09)

> ❓ What is the relationship between VS Code and the Monaco Editor?

The Monaco Editor is generated straight from VS Code's sources with some shims around services the code needs to make it run in a web browser outside of its home.

https://github.com/microsoft/monaco-editor?tab=readme-ov-file#faq
