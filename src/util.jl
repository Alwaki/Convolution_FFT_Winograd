"""
    zeropad1D(data, filter)
    
    # Arguments
   - `data::Array{}`: Data array 
   - `filter::Array{}`: 1D filter 

Adds zeros to a data array, with consideration to the shape of the filter to be used.

# Examples
```julia-repl
julia> zeropad1D([1.0, 2.0, 3.0], [1.0, 1.0, 1.0])
[0.0, 0.0, 1.0, 2.0, 3.0, 0.0, 0.0]
```
"""
function zeropad1D(data::AbstractVector, filter::AbstractVector)
    N = length(filter) - 1
    z = zeros(1, N)
    return [z data z] 
end

"""
    zeropad2D!(data, filter)
    
    # Arguments
   - `data::Matrix{}`: 2D data array 
   - `filter::Matrix{}`: 2D filter 

Adds zeros to a data array, with consideration to the shape of the filter to be used.

"""
function zeropad2D(filter::AbstractMatrix, data::AbstractMatrix)
    padded_data = deepcopy(data)
    fh = size(filter, 1) - 2
    fw = size(filter, 2) - 2
    dw = size(data, 2)
    v_pad = zeros(fh, dw)
    padded_data = [v_pad; padded_data; v_pad]
    dh = size(padded_data, 1)
    h_pad = zeros(dh, fw)
    padded_data = [h_pad padded_data h_pad]
    return padded_data
end