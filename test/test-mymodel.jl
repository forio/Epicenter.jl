

require("$(dirname(@__FILE__))/MyModel.jl")
using MyModel
using Base.Test

init()
@test typeof(model) === MyModel.ModelType
@test MyModel.start_year === 2014
@test curr_year === MyModel.start_year
@test length(model.results_over_time) === 1
@test Epicenter.fetch_records() != {}

advance()
@test MyModel.curr_year === 2015
@test length(model.results_over_time) === 2

advance()
@test MyModel.curr_year === 2016
@test length(model.results_over_time) === 3

reset()
@test typeof(model) === MyModel.ModelType
@test MyModel.start_year === 2014
@test MyModel.curr_year === MyModel.start_year
@test length(model.results_over_time) === 1
@test Epicenter.take_records() != {}

advance()
@test MyModel.curr_year === 2015

# Test setparam
@test MyModel.model.price == MyModel.start_price
Epicenter.setparam([:(model.price), 15.0])
@test MyModel.model.price == 15.0

Epicenter.setparam([:curr_year, 20])
@test MyModel.curr_year == 20

Epicenter.setparam([:(dummy.x), 84])
@test MyModel.dummy.x == 84
