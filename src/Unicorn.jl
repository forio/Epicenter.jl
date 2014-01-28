
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
include("session-settings.jl")

setup_idle_timeout(20, 10)

end
