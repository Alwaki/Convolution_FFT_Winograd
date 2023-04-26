"""
    Winograd1D!(d, f, N, output_list, b2, b3)

    # Arguments
    - `d::Array{}`: Data array to convolve
    - `f::Array{}`: Filter array to convolve with 
    - `N::Integer`: Length of data
    - `out::Array{}`: Array to output convolved data into 
    - `b::Array{}`: Multiplication constants

Computes the Winograd convolution with output size 2 and filter size 3. Note that 
this function works only on 1D data and filters.
"""
function Winograd1D!(d::AbstractVector, f::AbstractVector, N::Int,
     out::AbstractVector, b::AbstractVector)
    @inline for i = 1:2:N-1
        a1 = (d[2] + d[3]) * b[1]
        a2 = (d[3] - d[2]) * b[2]
        out[i] = ((d[1] - d[3]) * f[1])+a1+a2
        out[i+1] = a1-a2-((d[2] - d[4]) * f[3])
    end
    return out
end

"""
    WinogradMatrix2D!(d, out, dw, dh, AtGFGtBt, BA)

    # Arguments
    - `d::Matrix{}`: Data matrix to convolve
    - `out::Matrix{}`: Array to output convolved data into 
    - `dw::Integer`: Width of data
    - `dh::Integer`: Height of data
    - `AtGFGtBt::Matrix{}`: Multiplication constants matrix, includes filter
    - `BA::Matrix{}`: Multiplication constants matrix

Computes the Winograd convolution with output size 2x2 and filter size 3x3. Note that 
this function utilizes matrix multiplication.
"""
function WinogradMatrix2D!(d::AbstractMatrix, out::AbstractMatrix, 
    dw::Int, dh::Int, AtGFGtBt::AbstractMatrix, BA::AbstractMatrix)
    temp_mat=zeros(eltype(d),2,4) 
    @inline for i = 1:2:dh
        @inline for j = 1:2:dw
            mul!(temp_mat,AtGFGtBt,view(d,i:i+3,j:j+3))
            mul!(view(out, i:i+1,j:j+1), temp_mat,BA)
            #out[i:i+1,j:j+1] = AtGFGtBt*view(d,i:i+3,j:j+3)*BA
        end
    end
    return out
end