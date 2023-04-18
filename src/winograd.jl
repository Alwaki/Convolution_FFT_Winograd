"""
    Winograd1D(data, filter, N, output_list, b2, b3, i)

    # Arguments
    - `data::Array{Float}`: Data array to convolve
    - `filter::Array{Float}`: Filter array to convolve with 
    - `N::Integer`: Length of data
    - `output_list::Array{Float}`: Array to output convolved data into 
    - `b::Array{Float}`: Multiplication constants

    Computes the Winograd convolution with output size 2 and filter size 3. Note that 
this function works only on 1D data and filters.
"""
function Winograd1D!(d, g, N, s, b)
    @inline for i = 1:2:N-1
        a1 = (d[2] + d[3]) * b[1]
        a2 = (d[3] - d[2]) * b[2]
        s[i] = ((d[1] - d[3]) * g[1])+a1+a2
        s[i+1] = a1-a2-((d[2] - d[4]) * g[3])
    end
    return s
end