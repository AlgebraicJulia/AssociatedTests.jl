using Test, AssociatedTests

module Adding
using Test, AssociatedTests

function add1(x::Int)
  x + 1
end

@tests add1 begin
  @test add1(1) == 2
end
end

test(Adding.add1)

test(Adding)

test(Adding, Adding.add1)
