
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

# default idle timeout to 8 minutes, check every 4 minutes
setup_idle_timeout(8*60, 4*60)

end
