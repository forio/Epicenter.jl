

require(dirname(@__FILE__) * "/../src/Mercutio.jl")
using Mercutio

type TestThing
    member1
end

# test data
testmodel = TestThing({ "string_key" => 69 })

# test symbol tree
head = SymbolNode(:testmodel, nothing)

child1 = SymbolNode(:member1, head)
push!(head.children, child1)

child2 = SymbolNode("string_key", child1)
push!(child1.children, child2)

# -------

@assert haskey(head, (:testmodel,))
@assert haskey(head, (:testmodel, :member1))
@assert haskey(head, (:testmodel, :member1, "string_key"))

@assert !haskey(head, (:testmodel, :member1, "string_key", "does_not_exist"))

@assert getindex(head, :testmodel) != nothing
@assert getindex(head, :testmodel, :member1, "string_key") == 69
