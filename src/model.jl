
_JULIET_EXISTS = try
    import Juliet
    true
end

function subscribe(event_name, fn_handler)
    !_JULIET_EXISTS && return

    event_sys = Main.Juliet.get_system(Main.Juliet.Event)
    Main.Juliet.Event.register_handler(event_sys, "epicenter-$event_name", fn_handler)
end

# -------

function setparam(params...)
    for param in params
        eval(Main, :($(param[1]) = $(param[2])))
    end
end
