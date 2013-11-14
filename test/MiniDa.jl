module MiniDa


using Mercutio

export minida,

       runmodel,
       forecast

# -------

type ForecastData
    region::Int  # in range [1, 4]

    ForecastData(region = 2) = new(region)
end

# -------

type MiniDaModel <: Model
    price::Float64  # in range [0, typemax(Float64)]
    formula::Int    # in range [1, 4]

    forecast_data::ForecastData

    MiniDaModel(price = 7.0, formula = 2, forecast_data = ForecastData()) = new(price, formula, forecast_data)
end

const minida = MiniDaModel()

# -------

run_results = Any[]  # results of runmodel, for reference locally
forecasts = Any[]  # results of forecast runs, for refernce locally

# -------

function runmodel()
    num_customers = cos(minida.price / 12) * 64
    num_customers *= minida.formula / 2.5

    push!(run_results, num_customers)

    num_customers
end

function forecast()
    likely_customers = (minida.forecast_data.region / 2.5) * 64

    push!(forecasts, likely_customers)

    likely_customers
end


end
