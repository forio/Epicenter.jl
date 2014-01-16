
module MyModel

#include the Unicorn.jl package
using Unicorn

# expose variables to users of your model
export  model,
        curr_year

# expose methods to users of your model
export  init,
        advance,
        reset

# -------

type ModelResultType
    num_customers::Int
    revenue::Float64

    ModelResultType(; num_customers = 0, revenue = 0) = new(num_customers, revenue)
end

# -------

type ModelType
    price::Float64
    results_over_time::Array{ModelResultType, 1}

    ModelType(; price = start_price) = new(price, ModelResultType[])
end

# -------

const global start_year = 2014
const global initial_customers = 50
const global start_price = 15

global curr_year
global model

# -------

function init()
    #! Moved this logic into reset so that ModelType() doesn't get called
    #  multiple times. Also, doing so makes a bug with recording the
    #  results_over_time array much easier to intuit
    reset()
end

function advance()
    global curr_year += 1

    current_result = ModelResultType()
    current_result.num_customers = int(cos(model.price / 12) * 64)
    current_result.revenue = model.price * current_result.num_customers

    # add current_result, the results of executing the model for this time step,
    # to the end of the model.results array
    push!(model.results_over_time, current_result)

    # length(model.results_over_time) is the index of the last element of the model.results_over_time array
    # so adding model.results[length(model.results)] to the persistence queue
    # adds only the last element of the array to the persistence queue
    # when the model runs on the Unicorn platform,
    # the Unicorn platform processes this queue approximately every second
    record(:model, :results_over_time, length(model.results_over_time))
end

function reset()
    global curr_year = start_year
    global model = ModelType()

    current_result = ModelResultType()
    current_result.num_customers = initial_customers
    current_result.revenue = model.price * current_result.num_customers

    push!(model.results_over_time, current_result)

    #! we want to record the whole array here! If it was full of runs before, Unicorn needs to know
    #  that they were all cleared and that there's only one result now
    record(:model, :results_over_time)
end

end
