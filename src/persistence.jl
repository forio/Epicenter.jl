
# -------

type SymbolNode
    sym
    parent::SymbolNode
    children::Array{SymbolNode}

    SymbolNode(sym, parent) = new(sym, parent, SymbolNode[])
end

global _g_records = Array{SymbolNode}


# function getindex(h::SymbolNode, key...)
# end


# function setindex!(h::SymbolNode, key...)
# end


# function haskey(h::SymbolNode, key)
# end


# function get(h::SymbolNode, key, default)
# end


# function getkey(h::SymbolNode, key, default)
# end


# function delete!(h::SymbolNode)
# end

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

# -------

function fetch_records()
end


function take_records()
end

# -------
