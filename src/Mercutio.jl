
module Mercutio

export Model, runmodel

abstract Model

runmodel(mdl::Model) = error("`runmodel` must be defined for your model")

function setparam(mdl::Model, params...)
    for param in params
        mdl.(param[1]) = param[2]
    end
end

#include("macro-reflection.jl")
#include("heavy-injection.jl")

include("persistence.jl")

end
