
require("MyModel.jl")
using MyModel
using Base.Test

init()
@test typeof(model) === MyModel.ModelType
@test start_year === 2014
@test curr_year === start_year
@test length(model.results_over_time) === 1
@test fetch_records() != {}

advance()
@test curr_year === 2015
@test length(model.results_over_time) === 2

advance()
@test curr_year === 2015
@test length(model.results_over_time) === 2

reset()
@test typeof(model) === MyModel.ModelType
@test start_year === 2014
@test curr_year === start_year
@test length(model.results_over_time) === 1
@test take_records() != {}

advance()
@test curr_year === 2015
