"""
    Naive1D!(f, d, N, out)

    # Arguments
    - `f::Array{}`: Filter array 
    - `d::Array{}`: Data array
    - `N::Int`: Length of data
    - `out::Array{}`: Result array
    
Computes the Naive method convolution between the filter (of length 3) and data
"""

function naive1D!(f, d, N::Int, out)
    @inline for i = 1:N
        out[i] = f[1]*d[i] + f[2]*d[i+1] + f[3]*d[i+2]
    end
    return out
 end

 """
    Naive2D!(f, d, N, out)

    # Arguments
    - `f::Matrix{}`: 2D filter array
    - `d::Matrix{}`: 2D array of data
    - `dw::Int`: Width of data
    - `dh::Int`: Height of data
    - `out::Matrix{}`: 2D result array
    
Computes the Naive method convolution between the filter (of size 3x3) and data
"""

function naive2D!(f, d, dw::Int, dh::Int,
     out)
    @inline for i = 2:dh-1
        @inline for j = 2:dw-1
            out[i-1, j-1] = f[1,1]*d[i-1,j-1] + f[1,2]*d[i-1,j] + f[1,3]*d[i-1,j+1] +
                            f[2,1]*d[i,j-1]   + f[2,2]*d[i,j]   + f[2,3]*d[i,j+1]   +
                            f[3,1]*d[i+1,j-1] + f[3,2]*d[i+1,j] + f[3,3]*d[i+1,j+1]
        end
    end
    return out
 end