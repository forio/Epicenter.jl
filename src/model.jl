
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


global variable_module = nothing
global mods_seen = Module[Core, Base, current_module()]

function lookup_variables(mod::Module)
	global variable_module

	if in(mod, mods_seen)
		return
	end
	push!(mods_seen, mod)

	for name in names(mod)
		if isa(mod.(name), Module)
			lookup_variables(mod.(name))
		else
			variable_module[name] = mod
		end
	end
end

function setparam(params...)
	global variable_module
	if variable_module == nothing
		variable_module = Dict()
		lookup_variables(Main)
	end	
    for param in params
    	param_key = param[1]
    	param_string = string(param_key)
    	if contains(string(param_string), ".")
    		param_key = symbol(split(param_string, ".")[1])
    	end
    	eval(variable_module[param_key], :($(param[1]) = $(param[2])))
    end
end
