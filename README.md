# PlutoMonacoEditor.jl

## Usage

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
