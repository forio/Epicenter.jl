
module Mercutio

importall Base

export Model

export setparam,
       record,
       hasrecord,
       getrecord,
       fetch_records,
       take_records

export SymbolNode,
       _g_records

include("model.jl")
include("persistence.jl")

end
