"""
    Naive1D!(d, g, N, s)

    # Arguments
    - `d::Array{Float}`: Array
    - `g::Array{Float}`: Array 
    - `N::Int`: Length of data
    - `s::Array{Float}`: Result array
    
Computes the Naive method convolution between g and d
"""

function Naive1D!(d, g, N, s)
    @inline for i = 1:N
        s[i] = g[1]*d[i] + g[2]*d[i+1] + g[3]*d[i+2]
    end
    return s
 end