
# -------

type SymbolNode
    sym
    parent
    children::Array{SymbolNode}

    SymbolNode(sym, parent = nothing) = new(sym, parent, SymbolNode[])
end

type DataNode
    name
    value

    DataNode(name, value) = new(name, value)
end

global _g_records = SymbolNode(nothing, nothing)
global _data_records = {}

# -------

function getindex(sn::SymbolNode, keys...)
    haskey(sn, keys...) || error("Key not found: $(keys)")

    eval(Main, to_expr(keys...))
end


function setindex!(sn::SymbolNode, keys...)
    key_count = length(keys)
    key_count > 0 || return

    did_allocate = false

    if sn.sym == nothing
        (sn, did_allocate) = push!(sn, keys[1])
    end
    sn.sym != keys[1] && error("head symbol node does not match key $(keys[1])")

    curr_node = sn
    for i in 2:length(keys)
        # if a node higher in the tree was already a leaf
        # then this set of keys is already recorded
        if !did_allocate && length(curr_node.children) < 1
            break
        end

        (curr_node, did_allocate) = push!(curr_node, keys[i])
    end

    empty!(curr_node.children)

    nothing
end


function haskey(sn::SymbolNode, keys...)
    key_count = length(keys)
    key_count > 0 || return

    curr_index = 1
    curr_node = sn

    while curr_index <= key_count && curr_node != nothing && curr_node.sym == keys[curr_index]
        if curr_index == key_count || length(curr_node.children) < 1
            return true
        end

        curr_index += 1
        curr_node = find_child(curr_node, keys[curr_index])
    end

    false
end


function push!(sn::SymbolNode, child_sym)
    child = find_child(sn, child_sym)

    did_allocate = false

    if child == nothing
        did_allocate = true
        child = SymbolNode(child_sym, sn)
        push!(sn.children, child)
    end

    child, did_allocate
end

function store_data(name, value)
    node = DataNode(name, value)
    push!(_data_records, node)
    node
end

function delete!(sn::SymbolNode, keys...)
    key_count = length(keys)

    key_count == 0 && return sn

    if key_count == 1
        return sn.sym == keys[1] ? nothing : sn
    end

    curr_index = 1
    curr_node = sn

    while curr_index <= key_count && curr_node != nothing && curr_node.sym == keys[curr_index]
        if curr_index == key_count
            delete!(curr_node)
            return sn
        end

        curr_index += 1
        curr_node = find_child(curr_node, keys[curr_index])
    end

    sn
end

function delete!(sn::SymbolNode)
    parent = sn.parent

    if parent == nothing
        empty!(sn.children)
        return sn
    end

    index = find_child_index(parent, sn.sym)
    index == -1 && error("nodes parent does not contain node... something has gone horribly wrong")

    splice!(parent.children, index)

    parent
end


function show(io::IO, sn::SymbolNode, depth = 1)
    println(io, ">", sn.sym)
    for child in sn.children
        print("  "^depth)
        show(io, child, depth + 1)
    end
    println("  "^(depth - 1), "<")
end

# -------

function record(keys...)
    global _g_records
    setindex!(_g_records, keys...)
end

function fetch_records()
    build_record_tree()
end


function take_records()
    tree = build_record_tree()
    delete!(_g_records)

    for node = _data_records
        tree[node.name] = node.value
    end
    empty!(_data_records)
    
    tree
end

function hasrecord(keys...)
    if length(keys) > 0
        global _g_records

        sub_head = find_child(_g_records, keys[1])
        if sub_head != nothing
            return haskey(sub_head, keys...)
        end
    end

    false
end

function getrecord(keys...)
    if length(keys) > 0
        global _g_records

        sub_head = find_child(_g_records, keys[1])
        if sub_head != nothing
            return getindex(sub_head, keys...)
        end
    end

    error("Key not found: $(keys)")
end

# -------

function to_expr(syms...)
    # there might well be a better way to do this, for now we'll eval strings
    typeof(syms[1]) <: Symbol || error("first piece of key must be a Symbol")

    ex = string(syms[1])
    for sym in syms[2:end]
        symtype = typeof(sym)
        if symtype <: Symbol
            ex *= ".$sym"
        elseif symtype <: Int
            ex *= "[$sym]"
        elseif symtype <: String
            ex *= "[$(repr(sym))]"
        else
            error("unrecognized key index: $sym")
        end
    end

    parse(ex)
end


function find_child_index(sn::SymbolNode, child_sym)
    isempty(sn.children) && return -1

    for i in 1:length(sn.children)
        child_sym == sn.children[i].sym && return i
    end

    return -1
end

find_child(n::SymbolNode, k) = get(n.children, find_child_index(n, k), nothing)


function build_record_tree(sn::SymbolNode = _g_records, out = Dict(), keys = Any[])
    keys = deepcopy(keys)
    sn.sym != nothing && push!(keys, sn.sym)  # special case for _g_records

    for child in sn.children
        num_grandchildren = length(child.children)

        if num_grandchildren > 0
            out[child.sym] = Dict()
            build_record_tree(child, out[child.sym], keys)
        else
            try
                out[child.sym] = eval(Main, to_expr(keys..., child.sym))
            catch err
                out[child.sym] = err
            end
        end
    end

    out
end

# -------
