"""
    Winograd1D(data, filter, N, output_list, b2, b3, i)

    # Arguments
    - `data::Array{}`: Data array to convolve
    - `filter::Array{}`: Filter array to convolve with 
    - `N::Integer`: Length of data
    - `output_list::Array{}`: Array to output convolved data into 
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

function WinogradMatrix2D(filter, data, G, A, B, Gt, At, Bt)
    filter2d = [1.0 1.0 1.0; 1.0 2.0 1.0; 1.0 1.0 1.0]
    data2d = [0.0 1.0 1.0 1.0; 2.0 3.0 4.0 5.0; 1.0 2.0 3.0 4.0; 0.0 2.0 1.0 3.0]
    At = [1 1 1 0; 0 1 -1 -1]
    G = [1 0 0; 0.5 0.5 0.5; 0.5 -0.5 0.5; 0 0 1]
    Bt = [1 0 -1 0; 0 1 1 0; 0 -1 1 0; 0 1 0 -1]

    return At*((G*filter2d*transpose(G)).*(Bt*data2d*transpose(Bt)))*transpose(At)
end