## A package for writing models and simulations

### Quickstart

```julia
julia> Pkg.clone("https://github.com/forio/Unicorn.jl.git")
```


### Create a Model

Your model does not have to be a structure of a particular type and can include multiple disperate Modules, global variables, and any data structures you may use.

```julia
module MiniDa

using Unicorn

export minida,
       curr_year,

       runmodel,
       forecast

# -------

type ForecastData
    region::Int  # in range [1, 4]

    ForecastData(region = 2) = new(region)
end

# -------

type MiniDaModel
    price::Float64  # in range [0, typemax(Float64)]
    formula::Int    # in range [1, 4]
    run_results::Array

    forecast_data::ForecastData
    forecast_results::Dict

    MiniDaModel(price = 7.0, formula = 2, forecast_data = ForecastData()) = new(price, formula, Any[], forecast_data, Dict())
end

const minida = MiniDaModel()

# -------

global curr_year = 2013

# -------

function runmodel()
    num_customers = cos(minida.price / 12) * 64
    num_customers *= minida.formula / 2.5

    global curr_year += 1

    push!(minida.run_results, num_customers)

    num_customers
end

function forecast()
    likely_customers = (minida.forecast_data.region / 2.5) * 64
    
    minida.forecast_results[curr_year] = likely_customers    
    
    likely_customers
end

end
```

In this case we've defined everything in one module called `MiniDa`. We've got a global instance of `MiniDaModel` called `minida` which contains information about run and forecast results, along with a global `curr_year`. Also notice that we have `runmodel` and `forecast` which do some simple calculations and store the results.

### Set parameters and run the model

We can mess around a little using the `Unicorn.jl` interface and our knowledge of the model.

```julia
julia> using Unicorn

julia> require("MiniDa.jl")

julia> curr_year
2013

# it's no longer 2013, let's use `setparam` to update that

julia> julia> setparam([:curr_year, 2014])

julia> curr_year
2014

# we can also run the model to see what we get

julia> MiniDa.runmodel()
42.73312050338084
```

### Persist decisions and results

Now that we're able to run our model and get results, we should turn our attention to persisting data so that we can look back later. The method we'll use to do this is `record(keys...)`, which we can call anywhere in the model. `keys` will be a set of symbols and indexes that we will use to keep track of persisted values.

```julia
function runmodel()
    num_customers = cos(minida.price / 12) * 64
    num_customers *= minida.formula / 2.5

    global curr_year += 1
    record(:curr_year)  # add this call to record the global :curr_year value

    push!(minida.run_results, num_customers)
    
    # let's also record the array of stored run_results whenever we add a new one
    record(:minida, :run_results, length(minida.run_results))

    num_customers
end

function forecast()
    likely_customers = (minida.forecast_data.region / 2.5) * 64

    minida.forecast_results[curr_year] = likely_customers
    
    # we should also tell Unicorn that we've updated `forecast_results` whenever we change it
    record(:minida, :forecast_results, curr_year)

    likely_customers
end
```

