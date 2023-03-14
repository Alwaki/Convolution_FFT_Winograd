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

"""
    F23(d, g, b2, b3)

    # Arguments
    - `d::Array{Float}`: Array
    - `g::Array{Float}`: Array 
    - `b2::Float`: Multiplication constant
    - `b3::Float`: Multiplication constant 
    
Computes the Winograd convolution with output size 2 and filter size 3
"""
function F23(d, g, b2, b3)
    return [((d[1] - d[3]) * g[1])+((d[2] + d[3]) * b2)+((d[3] - d[2]) * b3)
     ((d[2] + d[3]) * b2)-((d[3] - d[2]) * b3)-((d[2] - d[4]) * g[3])]
end

"""
    Winograd1D(data, filter, N, output_list, b2, b3, i)

    # Arguments
    - `data::Array{Float}`: Data array to convolve
    - `filter::Array{Float}`: Filter array to convolve with 
    - `N::Integer`: Length of data
    - `output_list::Array{Float}`: Array to output convolved data into 
    - `b2::Float`: Multiplication constant
    - `b3::Float`: Multiplication constant
    - `i::Integer`: Iteration variable

Calls F23 repeatedly to perform winograd convolution in steps over data array. Note that 
this function works only on 1D data and filters.
"""
function Winograd1D(data, filter, N, output_list, b2, b3, i)
    while i < N 
        output_list[i:i+1] = F23(data[i:i+3], filter, b2, b3)
        i+=1
    end
    return output_list
end