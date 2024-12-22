using Test

using Aqua
using JET

using PlutoMonacoEditor

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
