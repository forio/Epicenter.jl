module Epicenter

importall Base

export setparam,
       record,
       hasrecord,
       getrecord,
       fetch_records,
       take_records,
       subscribe

include("model.jl")
include("persistence.jl")

end
