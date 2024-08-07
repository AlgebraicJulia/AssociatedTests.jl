module AssociatedTests

using Test

function test end
export test

const TESTS_FOR = Dict{Module, Set{Any}}()

const TESTS_VAR = :__TESTS_VAR__

@nospecialize
function test(m::Module)
  @testset verbose = true "$(nameof(m))" begin
    for thing in names(m; all=true)
      thing = getproperty(m, thing)
      if thing != m
        if hasmethod(test, (Val{thing},))
          test(Val(thing))
        elseif thing isa Module
          test(thing)
        end
      end
    end
  end
  nothing
end

@nospecialize
function test(f::Function)
  test(Val(f))
end

@nospecialize
function test(d::Type)
  test(Val(d))
end

macro tests(thing, block)
  esc(quote
    $(AssociatedTests).test(::Val{$thing}) = begin
      $(Test).@testset $(string(thing)) $block
      nothing
    end
  end)
end
export @tests

end # module AssociatedTests
