
# -------

function isempty(mdl_data::ModelData, member::Symbol)
    isempty(mdl_data.persist_queue[member])
end

function isempty(mdl_sym::Symbol, member::Symbol)
    mdl_data = getmodeldata(mdl_sym)
    isempty(mdl_data, member)
end


function length(mdl_data::ModelData, member::Symbol)
    length(mdl_data.persist_queue[member])
end

function length(mdl_sym::Symbol, member::Symbol)
    mdl_data = getmodeldata(mdl_sym)
    length(mdl_data, member)
end


function empty!(mdl_data::ModelData, member::Symbol)
    empty!(mdl_data.persist_queue[member])
end

function empty!(mdl_sym::Symbol, member::Symbol)
    mdl_data = getmodeldata(mdl_sym)
    empty!(mdl_data, member)
end


function push!(mdl_data::ModelData, member::Symbol)
    if !haskey(mdl_data.persist_queue, member)
        mdl_data.persist_queue[member] = Any[]
    end

    val = mdl_data.mdl.(member)
    push!(mdl_data.persist_queue[member], val)
end

function push!(mdl_sym::Symbol, member::Symbol)
    mdl_data = getmodeldata(mdl_sym)
    push!(mdl_data, member)
end


function pop!(mdl_data::ModelData, member::Symbol)
    pop!(mdl_data.persist_queue[member])
end

function pop!(mdl_sym::Symbol, member::Symbol)
    mdl_data = getmodeldata(mdl_sym)
    pop!(mdl_data, member)
end


function splice!(mdl_data::ModelData, member::Symbol, i::Integer, ins::AbstractArray = Base._default_splice)
    splice!(mdl_data.persist_queue[member], i, ins)
end

function splice!{T<:Integer}(mdl_sym::Symbol, member::Symbol, r::Range1{T}, ins::AbstractArray = Base._default_splice)
    mdl_data = getmodeldata(mdl_sym)
    splice!(mdl_data, member, r, ins)
end

# -------
