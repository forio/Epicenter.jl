

require(dirname(@__FILE__) * "/../src/Mercutio.jl")
using Mercutio

type Thing
    bar
end

foo = Thing({"a"=>78})

head = SymbolNode(:foo, nothing)
child1 = SymbolNode(:bar, head)
push!(head.children, child1)
child2 = SymbolNode("a", child1)
push!(child1.children, child2)

@assert haskey(head, (:foo,))
@assert haskey(head, (:foo, :bar))
@assert haskey(head, (:foo, :bar, "a"))

@assert !haskey(head, (:foo, :bar, "a", "does_not_exist"))

@assert getindex(head, :foo) != nothing
@assert getindex(head, :foo, :bar, "a") == 78


