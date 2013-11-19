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

type MiniDaModel
    price::Float64  # in range [0, typemax(Float64)]
    formula::Int    # in range [1, 4]
    run_results::Array

    forecast_data::ForecastData
    forecast_results::Dict

    MiniDaModel(price = 7.0, formula = 2, forecast_data = ForecastData()) = new(price, formula, Anyp[], forecast_data, Any[])
end

const minida = MiniDaModel()

# -------

global curr_year = 2013

# -------

function runmodel()
    num_customers = cos(minida.price / 12) * 64
    num_customers *= minida.formula / 2.5

    push!(minida.run_results, num_customers)

    global curr_year += 1

    num_customers
end

function forecast()
    likely_customers = (minida.forecast_data.region / 2.5) * 64

    minida.forecast_data[curr_year] = likely_customers

    likely_customers
end

end
