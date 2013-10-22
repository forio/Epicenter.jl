
export loadmodel

type MercutioData

end

function init(model)
    eval(model, "global __methods = Function[]")
end

function loadmodel(model)
    init(model)

    things = names(model)

    for thing in things
        thing_type = typeof(model.(thing))
        if thing_type == Function
            println("function: $thing")
            push!(model.__methods, thing)
        elseif thing_type != Module
            println("variable: $thing")
        end
    end
end

