### A Pluto.jl notebook ###
# v0.19.47

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try
            Base.loaded_modules[Base.PkgId(
                Base.UUID("6e696c72-6542-2067-7265-42206c756150"),
                "AbstractPlutoDingetjes",
            )].Bonds.initial_value
        catch
            b -> missing
        end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ 07ebdbbe-49bb-4d18-9f2b-14f98d137548
begin
    using Pkg
    Pkg.activate(temp = true)
    Pkg.develop(path = dirname(@__DIR__))
    using PlutoMonacoEditor: MonacoEditor
end

# ╔═╡ 9aa40f8c-a955-47a3-8e6d-4ac54d1dc330
md"""
# Rust Editor on Pluto Notebook

To run this notebook, you need to install the Rust compiler from [here](https://www.rust-lang.org/tools/install). This will install both `rustc` (the Rust compiler) and `cargo` (the Rust package manager).

Then, install the `rust-script` package with:

```sh
$ cargo install rust-script
```

See [rust-script](https://github.com/fornwall/rust-script) for more information.

"""

# ╔═╡ bf232d99-3001-4aac-afb7-1321c7407666
begin
    initCode = """
   //! Dependencies can be specified in the script file itself as follows:
   //!
   //! ```cargo
   //! [dependencies]
   //! rand = "0.8.0"
   //! ```

   use rand::prelude::*;

   fn main() {
       let x: u64 = random();
       println!("A random number: {}", x);
   }

   	"""
    @bind rustcode MonacoEditor("rust", initCode, width = 700, height = 300)
end

# ╔═╡ dce616d7-fdfe-4854-919d-420603ebc875
mktempdir() do d
    sourcepath = joinpath(d, "main.rs")
    open(sourcepath, "w") do io
        write(io, rustcode)
    end
    run(`rust-script $(sourcepath)`)
end

# ╔═╡ Cell order:
# ╟─9aa40f8c-a955-47a3-8e6d-4ac54d1dc330
# ╠═07ebdbbe-49bb-4d18-9f2b-14f98d137548
# ╟─bf232d99-3001-4aac-afb7-1321c7407666
# ╠═dce616d7-fdfe-4854-919d-420603ebc875
