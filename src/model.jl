
# -------

function setparam(params...)
    for param in params
        Main.(param[1]) = param[2]
    end
end

# -------

