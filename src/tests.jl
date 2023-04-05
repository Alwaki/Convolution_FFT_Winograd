"""
    test1D(f, d)

    # Arguments
   - `f::Array{Float}`: 1D filter, of size 1x3.
   - `d::Array{Integer}`: Lengths of arrays to convolve, of size 1xN.

Benchmark Naive, FFT and winograd convolution in 1D with filter f for data lengths as specified
by an array d. Plots log-log plot of time taken for each.

# Examples
```julia-repl
julia> test1d([1.0, 2.0, 1.0], [10:10:100])
```
"""
function test1D(g, d)
    b1 = g[1] + g[3]
    b2 = 0.5*(b1 + g[2])
    b3 = 0.5*(b1 - g[2])
    times_fft = []
    times_wino = []
    times_naive = []

    for batch in tqdm(d)
        data1d = rand(Float64, (1, batch))
        data1d_padded = zeropad1D(data1d,g);
        N = Int64(length(data1d_padded) - length(g) + 1);
        output_list = zeros(1,N);
        i = 1;
        t1 = @belapsed conv($data1d, $g);
        t2 = @belapsed Winograd1D!($data1d_padded, $g, $N, $output_list, $b2, $b3, $i);
        t3 = @belapsed naive1D!($data1d_padded, $g, $N, $output_list)
        times_fft = [times_fft; t1]
        times_wino = [times_wino; t2]
        times_naive = [times_naive; t3]
    end

    p = plot(d, [times_fft, times_wino, times_naive], title="log-log complexity plot", label=["FFT" "Winograd" "Naive"], linewidth=2, xscale=:log10, yscale=:log10, minorgrid=true)
    xlabel!(L"$log_{10}(N)$")
    ylabel!(L"$log_{10}(t)$")
    display(p)


end

"""
    NOTE: WORK IN PROGRESS

    test2D(f, d)

Benchmark FFT and winograd convolution in 2D with filter f for data lengths as specified
by an array d. Plots log-log plot of time taken for each.

"""
function test2D()
end
