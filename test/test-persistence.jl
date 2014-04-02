
require(dirname(@__FILE__) * "/../src/Epicenter.jl")
using Epicenter

type TestThing
    member1
end

testmodel = TestThing({ "string_key" => 69 })

# test basic record functionality -------
record(:testmodel, :member1, "string_key")
record(:testmodel, :member1)
record(:testmodel)

@assert hasrecord(:testmodel)
@assert hasrecord(:testmodel, :member1)
@assert hasrecord(:testmodel, :member1, "string_key")

@assert getrecord(:testmodel) != nothing
@assert getrecord(:testmodel, :member1, "string_key") == 69
# -------

# test https://github.com/forio/Epicenter.jl/pull/9 -------
function issue9(value, value_keys...)
    some_local_variable = value

    try
        record(:some_local_variable, value_keys...)
        throw("we shouldn't get here, record should have thrown an exception")

    catch err
        @assert err != "we shouldn't get here, record should have thrown an exception"
    end
end

issue9(1234)
issue9({"cow" => "moo"}, "cow")
# -------

