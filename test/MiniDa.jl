
module MiniDa

using Mercutio

import Mercutio.runmodel


type CalcModel <: Model
    price::Float64  # in range [0, typemax(Float64)]
    formula::Int    # in range [1, 4]
end

function runmodel(mdl::CalcModel)
    push!(:CalcModel, :price)
    push!(:CalcModel, :formula)

    num_customers = cos(mdl.price / 12) * 64
    num_customers *= mdl.formula / 2.5
end

register_model(CalcModel(7.0, 3))

# -------

type ForcastModel <: Model
    region::Int  # in range [1, 4]
end

function runmodel(mdl::ForcastModel)
    likely_customers = (mdl.region / 2.5) * 64
end

register_model(ForcastModel(2))

end

