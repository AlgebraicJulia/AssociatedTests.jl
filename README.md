# AssociatedTests.jl

Write tests next to the functions and types that they test. Run tests granularly and incrementally with Revise.

Usage:


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

## TODO

- Slightly more docs
- CI
- Release 0.1!
