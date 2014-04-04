
require(dirname(@__FILE__) * "/../src/Epicenter.jl")
using Epicenter

type TestThing
    member1
end

# test data
testmodel = TestThing({ "string_key" => 69 })

# test symbol tree
record(:testmodel, :member1, "string_key")

record(:testmodel, :member1)

record(:testmodel)
# -------

@assert hasrecord(:testmodel)
@assert hasrecord(:testmodel, :member1)
@assert hasrecord(:testmodel, :member1, "string_key")

#@assert !hasrecord(:testmodel, :member1, "string_key", "does_not_exist")

@assert getrecord(:testmodel) != nothing
@assert getrecord(:testmodel, :member1, "string_key") == 69
