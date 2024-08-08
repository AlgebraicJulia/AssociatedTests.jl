# AssociatedTests.jl

Write tests next to the functions and types that they test. Run tests granularly and incrementally with Revise.

## Usage


```julia
# in source file
module Adding
function add1(x::Int)
  x + 1
end

@tests add1 begin
  @test add1(1) == 2
end
end

# in REPL
> test(Adding.add1)
Test Summary: | Pass  Total  Time
add1          |    1      1  0.0s

> test(Adding)
Test Summary: | Pass  Total  Time
Adding        |    1      1  0.0s
  add1        |    1      1  0.0s
```

## Under the hood

The `@tests` macro is very simple; it essentially just expands as

```julia
@tests add1 begin
  @test add1(1) == 2
end

=>

function __runtest__(::Val{add1})
  @testset "add1" begin
    @test add1(1) == 2
  end
end
```

This means that `__runtest__` will get reloaded by Revise without any special effort, and doesn't pollute the global namespace with any local variables defined in the tests.

Then `test(f) = parentmodule(f).__runtest__(Val{f}())`. One can also pass in two arguments to `test` in order to run tests in a module other than the parent module. For instance:

```julia
module MyVectors

struct MyVector
  ...
end

function Base.getindex(v::MyVector, i)
  ...
end

@tests getindex begin
  ...
end
```

You can then run these tests with `test(MyVectors, getindex) = MyVectors.__runtest__(getindex)`.

`test(MyVectors)` iterates through all of the defined methods of `MyVectors.__runtest__` and calls them all.
