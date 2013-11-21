
module Unicorn

importall Base

export setparam,
       record,
       hasrecord,
       getrecord,
       fetch_records,
       take_records

include("model.jl")
include("persistence.jl")

end
