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
	Pkg.develop(path=dirname(@__DIR__))
	using PlutoMonacoEditor: MonacoEditor
end

# ╔═╡ 9aa40f8c-a955-47a3-8e6d-4ac54d1dc330
md"""
# Rust editor on Pluto Notebook

To run this notebook, you need to install Rust compiler from [here](https://www.rust-lang.org/tools/install). You will get `rustc` and `cargo` command

```sh
$ cargo install rust-script
```

See [rust-script](https://github.com/fornwall/rust-script) for more information

"""

# ╔═╡ bf232d99-3001-4aac-afb7-1321c7407666
begin
	initCode = """
//! Dependencies can be specified in the script file itself as follows:
//!
//! ```cargo
//! name = "main"
//! version = "0.1.0"
//! edition = "2021"
//! 
//! [dependencies]
//! ndarray = "0.16.1"
//! 
extern crate ndarray;
use ndarray::arr2;
fn main() {
    let a = arr2(&[[1, 2, 3],
                   [4, 5, 6]]);
    let b = arr2(&[[6, 5, 4],
                   [3, 2, 1]]);
    let sum = &a + &b;
    println!("{}", a);
    println!("+");
    println!("{}", b);
    println!("=");
    println!("{}", sum);
}
	"""
	@bind rustcode MonacoEditor("rust", initCode, width=700, height=500)
end

# ╔═╡ dce616d7-fdfe-4854-919d-420603ebc875
mktempdir() do d
	sourcepath = joinpath(d, "main.rs")
	open(sourcepath, "w") do io
		write(io, rustcode)
	end	
	executablepath = joinpath(d, "main")
	try
		run(`rust-script $(sourcepath)`)
	catch 
	end
	nothing
end

# ╔═╡ Cell order:
# ╟─9aa40f8c-a955-47a3-8e6d-4ac54d1dc330
# ╠═07ebdbbe-49bb-4d18-9f2b-14f98d137548
# ╟─bf232d99-3001-4aac-afb7-1321c7407666
# ╟─dce616d7-fdfe-4854-919d-420603ebc875
