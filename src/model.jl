
abstract Model

type ModelData
    mdl::Model
    persist_queue::Dict{Symbol, Array}
end

global _g_model_data = Dict{Symbol, ModelData}()

# -------

function getmodel(sym::Symbol)
    mdl = get(_g_model_data, sym, nothing)
    mdl == nothing && error("no model for symbol: $sym")

    mdl
end


function runmodel(mdl::Model)
    error("`runmodel` must be defined for your model")
end

runmodel(mdl_sym::Symbol) = runmodel(getmodel(mdl_sym))


function setparam(mdl::Model, params...)
    for param in params
        mdl.(param[1]) = param[2]
    end
end

setparam(mdl_sym::Symbol, params...) = setparam(getmodel(mdl_sym), params...)

# -------

