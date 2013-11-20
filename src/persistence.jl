
# -------

type SymbolNode
    sym
    paren
    children::Array{SymbolNode}

    SymbolNode(sym, parent = nothing) = new(sym, parent, SymbolNode[])
end

global _g_records = Array{SymbolNode}

# -------

function getindex(h::SymbolNode, keys...)
    haskey(h, keys) || error("Key not found: $(keys...)")

    eval(Main, to_expr(keys...))
end


function setindex!(h::SymbolNode, keys...)
    key_count = length(keys)
    key_count > 0 || return

    curr_index = 1
    curr_node = h

    error("haven't finished setindex")
end


function haskey(h::SymbolNode, keys::Tuple)
    key_count = length(keys)
    key_count > 0 || return

    curr_index = 1
    curr_node = h

    while curr_index <= key_count && curr_node != nothing && curr_node.sym == keys[curr_index]
        if curr_index == key_count
            return true
        end

        curr_index += 1
        curr_node = find_child(curr_node, keys[curr_index])
    end

    false
end


# function get(h::SymbolNode, key, default)
# end


# function getkey(h::SymbolNode, key, default)
# end


# function delete!(h::SymbolNode)
# end

# -------

function fetch_records()
end


function take_records()
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

function find_child_index(n::SymbolNode, k)
    isempty(n.children) && return -1

    for i in 1:length(n.children)
        k == n.children[i].sym && return i
    end

    return -1
end

find_child(n::SymbolNode, k) = get(n.children, find_child_index(n, k), nothing)

# -------
