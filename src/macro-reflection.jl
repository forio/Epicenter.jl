module Mercutio

export @parameter, @param_str, @some_macro, @recalc

# -------

_mp = Any[]

global reload_fn

# -------

macro p_str(sym)

#   println(eval(:(esc(current_module()))))
    #push!(_mp, (b, sym))
end

macro parameter(thing)
    b = esc(current_module())
    push!(_mp, b)
end

macro some_macro()
    eval(:(esc(current_module())))
end

macro recalc(fn)
    println(typeof(fn))
    fn
end

function register(fn)
    println(typeof(fn))
    global reload_fn = fn
end

end


module B

    using Mercutio

    function foo()
        @some_macro
    end

end