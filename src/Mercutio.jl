
module Mercutio

importall Base

export Model

export register_model,
       registered_models,
       getmodel,
       runmodel,
       setparam,
       popall!

include("model.jl")
include("persistence.jl")

end
