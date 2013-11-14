module MiniDa


using Mercutio

export minida,

       runmodel,
       forecast

# -------

type ForecastData
    region::Int  # in range [1, 4]

    likely_customers

    ForecastData(region = 2) = new(region, 0)
end

# -------

type MiniDaModel <: Model
    price::Float64  # in range [0, typemax(Float64)]
    formula::Int    # in range [1, 4]

    num_customers

    forecast_data::ForecastData

    MiniDaModel(price = 7.0, formula = 2, forecast_data = ForecastData()) = new(price, formula, 0, forecast_data)
end

minida = MiniDaModel()

# -------

function runmodel()
    minida.num_customers = cos(minida.price / 12) * 64
    minida.num_customers *= minida.formula / 2.5

    minida.num_customers
end

function forecast()
    minida.forecast_data.likely_customers = (minida.forecast_data.region / 2.5) * 64
end


end
