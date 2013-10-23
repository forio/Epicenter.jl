
module Mercutio

importall Base

export Model

export getmodel,
       runmodel,
       setparam

include("model.jl")
include("persistence.jl")

end
