# Testing 
module InnerModule

type DummyType
    x::Int64
end

global dummy = DummyType(42)
export dummy

end