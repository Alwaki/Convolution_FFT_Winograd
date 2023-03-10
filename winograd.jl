function zeropad(data, filter)
    N = length(filter) - 1
    z = zeros(1, N)
    return [z data z] 
end

function F23(d, g, b2, b3)
    m1 = (d[1] - d[3]) * g[1] 
    m2 = (d[2] + d[3]) * b2
    m3 = (d[3] - d[2]) * b3
    m4 = (d[2] - d[4]) * g[3]
    return [m1+m2+m3 m2-m3-m4]
end

function Winograd(data, filter, b2, b3)
    data = zeropad(data, filter)
    N = Int64(length(data) - length(filter) + 1)
    output_list = zeros(1,N)
    i = 1
    while i < N 
        output_list[i:i+1] = F23(data[i:i+3], filter, b2, b3)
        i+=1
    end
    return output_list
end