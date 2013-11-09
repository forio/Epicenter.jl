
# -------

function isempty(mdl_data::ModelData)
    for (sym, queue) in mdl_data.persist_queue
        !isempty(queue) && return false
    end

    true
end

function isempty(mdl_data::ModelData, member::Symbol)
    isempty(mdl_data.persist_queue[member])
end

isempty(mdl_sym::Symbol, member::Symbol) = isempty(getmodeldata(mdl_sym), member)

isempty(mdl_sym::Symbol) = isempty(getmodeldata(mdl_sym))


function length(mdl_data::ModelData, member::Symbol)
    length(mdl_data.persist_queue[member])
end

length(mdl_sym::Symbol, member::Symbol) = length(getmodeldata(mdl_sym), member)

length(mdl_data::ModelData) = sum(length, mdl_data.persist_queue)

length(mdl_sym::Symbol) = length(getmodeldata(mdl_sym))


function empty!(mdl_data::ModelData, member::Symbol)
    empty!(mdl_data.persist_queue[member])
end

function empty!(mdl_sym::Symbol, member::Symbol)
    mdl_data = getmodeldata(mdl_sym)
    empty!(mdl_data, member)
end

function empty!(mdl_data::ModelData)
    for (sym, queue) in mdl_data.persist_queue
        empty!(queue)
    end

    mdl_data
end

empty!(mdl_sym::Symbol) = empty!(getmodeldata(mdl_sym))


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


function pop!(mdl_data::ModelData)
    for (sym, queue) in mdl_data.persist_queue
        !isempty(queue) && return pop!(queue)
    end

    error("model queue is empty")
end

function pop!(mdl_data::ModelData, member::Symbol)
    pop!(mdl_data.persist_queue[member])
end

function pop!(mdl_sym::Symbol, member::Symbol)
    mdl_data = getmodeldata(mdl_sym)
    pop!(mdl_data, member)
end

pop!(mdl_sym::Symbol) = pop!(getmodeldata(mdl_sym))


function popall!(mdl_data::ModelData)
    out = deepcopy(mdl_data.persist_queue)
    empty!(mdl_data.persist_queue)

    out
end

popall!(mdl_sym::Symbol) = popall!(getmodeldata(mdl_sym))


function splice!(mdl_data::ModelData, member::Symbol, ir, ins::AbstractArray = Base._default_splice)
    splice!(mdl_data.persist_queue[member], ir, ins)
end

function splice!(mdl_sym::Symbol, member::Symbol, ir, ins::AbstractArray = Base._default_splice)
    mdl_data = getmodeldata(mdl_sym)
    splice!(mdl_data, member, ir, ins)
end

# -------
