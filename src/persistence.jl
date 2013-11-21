
# -------

type SymbolNode
    sym
    parent
    children::Array{SymbolNode}

    SymbolNode(sym, parent = nothing) = new(sym, parent, SymbolNode[])
end

global _g_records = SymbolNode(nothing, nothing)

# -------

function getindex(sn::SymbolNode, keys...)
    haskey(sn, keys...) || error("Key not found: $(keys)")

    eval(Main, to_expr(keys...))
end


function setindex!(sn::SymbolNode, keys...)
    key_count = length(keys)
    key_count > 0 || return

    sn.sym != keys[1] && error("head symbol node does not match key $(keys[1])")

    curr_node = sn
    for i in 2:length(keys)
        curr_node = push!(curr_node, keys[i])
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
        if curr_index == key_count
            return true
        end

        curr_index += 1
        curr_node = find_child(curr_node, keys[curr_index])
    end

    false
end


function push!(sn::SymbolNode, child_sym)
    child = find_child(sn, child_sym)

    if child == nothing
        child = SymbolNode(child_sym, sn)
        push!(sn.children, child)
    end

    child
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
    parent == nothing && return nothing

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
    length(keys) < 1 && return

    global _g_records
    sub_head = push!(_g_records, keys[1])

    setindex!(sub_head, keys...)
end

function fetch_records()
    build_record_tree()
end


function take_records()
    tree = build_record_tree()
    global _g_records = delete!(_g_records)

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
    push!(keys, sn.sym)

    num_children = length(sn.children)
    if num_children == 0
        try
            out[keys] = eval(Main, to_expr(keys...))
        catch
        end
    else
        for i in 1:num_children
            build_record_tree(sn.children[i], out, keys)
        end
    end

    out
end

# -------
