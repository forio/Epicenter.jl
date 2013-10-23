
abstract Model

type ModelData
    mdl::Model
    persist_queue::Dict{Symbol, Vector}

    ModelData(mdl::Model) = new(mdl, Dict{Symbol, Vector}())
end

global _g_model_data = Dict{Symbol, ModelData}()

# -------

function register_model(mdl_sym::Symbol, mdl::Model)
    _g_model_data[mdl_sym] = ModelData(mdl)
end


function getmodeldata(sym::Symbol)
    mdl_data = get(_g_model_data, sym, nothing)
    mdl_data == nothing && error("no model data for: $sym")

    mdl_data
end

getmodel(sym::Symbol) = getmodeldata(sym).mdl


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

