
cd(dirname(@__FILE__))
files = readdir()

# Run each file in the test directory that looks like "test-XXXX.jl"
for file in files
    !beginswith(file, "test-") && continue

    println("running $file...")
    !success(`julia $file`) && error("running test: $file")
    println("success")
end
