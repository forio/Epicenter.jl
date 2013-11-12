
module SwimTrunkSales

using Mercutio

import Mercutio.runmodel


type SwimTrunkSalesModel <: Model
    price::Float64
    color::Int

    num_customers

    SwimTrunkSalesModel(price = 16, color = 1) = new(price, color, 0)
end

function runmodel(mdl::SwimTrunkSalesModel)
    push!(:SwimTrunkSalesModel, :price)
    push!(:SwimTrunkSalesModel, :color)

    mdl.num_customers = cos(mdl.price / 12) * 64
    mdl.num_customers *= mdl.color / 2.5
    push!(:SwimTrunkSalesModel, :num_customers)

    mdl.num_customers
end

end
