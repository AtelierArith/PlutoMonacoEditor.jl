using Test

using Aqua
using JET
import Pluto

using PlutoMonacoEditor

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


@testset "Code quality (Aqua.jl)" begin
    Aqua.test_all(PlutoMonacoEditor)
end

v = VERSION
isreleased = v.prerelease == ()
if isreleased && v >= v"1.10"
    @testset "Code linting (JET.jl)" begin
        JET.test_package(PlutoMonacoEditor; target_defined_modules = true)
    end
end
