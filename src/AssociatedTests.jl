module AssociatedTests

using Test

@nospecialize
function test(m::Module)
    @testset verbose = true "$(nameof(m))" begin
        for method in methods(m.__runtest__)
            m.__runtest__(method.sig.parameters[2]())
        end
        for name in names(m; all=true)
            thing = getproperty(m, name)
            if thing isa Module && thing != m
                test(thing)
            end
        end
    end
    nothing
end
export test

@nospecialize
function test(m::Module, n::Module)
    test(n)
end

@nospecialize
function test(m::Module, f::Function)
    m.__runtest__(Val(f))
end

@nospecialize
function test(f::Function)
    test(parentmodule(f), f)
end

@nospecialize
function test(m::Module, d::Type)
    m.__runtest__(Val(d))
end

@nospecialize
function test(d::Type)
    test(parentmodule(d), d)
end

macro tests(thing, block)
    esc(quote
        __runtest__(::Val{$thing}) = begin
            $(Test).@testset $(string(thing)) $block
            nothing
        end
    end)
end
export @tests

end # module AssociatedTests
