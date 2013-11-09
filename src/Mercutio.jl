
module Mercutio

importall Base

export Model

export register_model,
       getmodel,
       runmodel,
       setparam,
       popall!

include("model.jl")
include("persistence.jl")

end
