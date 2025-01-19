### A Pluto.jl notebook ###
# v0.20.4

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
    targetfile = joinpath(dirname(first(split(@__FILE__, ".jl#==#"))), "main_script.rs")
    initCode = join(readlines(targetfile), '\n')
    @bind sourcecode MonacoEditor("rust", initCode, height = 350)
end

# ╔═╡ fcb9387a-9fdc-4f89-943f-3b39c972ab16
let
    shouldrun = false
    if !ismissing(sourcecode)
        if initCode != sourcecode
            # Update file
            write(targetfile, sourcecode)
            # If updated, we should run code
            shouldrun = true
        end
        if shouldrun
            mktempdir() do d
                write(joinpath(d, targetfile), sourcecode)
                exec = joinpath(d, "a.out")
                try
                    run(`rust-script $(joinpath(d, targetfile))`)
                catch e
                    e isa ProcessFailedException || rethrow(e)
                end
            end
        end
    end
end

# ╔═╡ e9e16ea0-6972-4e0a-a1c8-0f717448a0d8
md"""
Note that the following cell runs behind the scenes
```julia
let
    shouldrun = false
    if !ismissing(sourcecode)
        if initCode != sourcecode
            # Update file
            write(targetfile, sourcecode)
            # If updated, we should run code
            shouldrun = true
        end
        if shouldrun
            mktempdir() do d
                write(joinpath(d, targetfile), sourcecode)
                exec = joinpath(d, "a.out")
                try
                    run(`rust-script $(joinpath(d, targetfile))`)
                catch e
                    e isa ProcessFailedException || rethrow(e)
                end
            end
        end
    end
end
```
"""

# ╔═╡ Cell order:
# ╟─9aa40f8c-a955-47a3-8e6d-4ac54d1dc330
# ╠═07ebdbbe-49bb-4d18-9f2b-14f98d137548
# ╟─bf232d99-3001-4aac-afb7-1321c7407666
# ╟─fcb9387a-9fdc-4f89-943f-3b39c972ab16
# ╟─e9e16ea0-6972-4e0a-a1c8-0f717448a0d8
