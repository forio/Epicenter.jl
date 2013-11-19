
module Mercutio

importall Base

export Model

export setparam,
       fetch_records,
       take_records

include("model.jl")
include("persistence.jl")

end
