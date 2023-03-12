function zeropad(data, filter)
    N = length(filter) - 1
    z = zeros(1, N)
    return [z data z] 
end

@inline
function F23(d, g, b2, b3)
    return [((d[1] - d[3]) * g[1])+((d[2] + d[3]) * b2)+((d[3] - d[2]) * b3)
     ((d[2] + d[3]) * b2)-((d[3] - d[2]) * b3)-((d[2] - d[4]) * g[3])]
end

@inline
function Winograd(data, filter, N, output_list, b2, b3)
    i = 1
    while i < N 
        output_list[i:i+1] = F23(data[i:i+3], filter, b2, b3)
        i+=1
    end
    return output_list
end