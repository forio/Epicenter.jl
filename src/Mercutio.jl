
module Mercutio

importall Base

export Model

export register_model,
       getmodel,
       runmodel,
       setparam

include("model.jl")
include("persistence.jl")

end
