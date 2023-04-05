"""
    zeropad1D(data, filter)
    
    # Arguments
   - `data::Array{Float}`: Data array 
   - `filter::Array{Float}`: 1D filter 

Adds zeros to a data array, with consideration to the shape of the filter to be used.

# Examples
```julia-repl
julia> zeropad1D([1.0, 2.0, 3.0], [1.0, 1.0, 1.0])
[0.0, 0.0, 1.0, 2.0, 3.0, 0.0, 0.0]
```
"""
function zeropad1D(data, filter)
    N = length(filter) - 1
    z = zeros(1, N)
    return [z data z] 
end