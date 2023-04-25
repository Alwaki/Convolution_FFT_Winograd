"""
    test1D(filter, batches)

    # Arguments
   - `filter::Array{}`: 1D filter, of size 1x3.
   - `batches::Array{Integer}`: Lengths of arrays to convolve, of size 1xN.

Benchmark Naive, FFT and winograd convolution in 1D with a filter for data lengths as specified
by an array termed batches. Plots log-log plot of time taken for each, and stores plot.

# Examples
```julia-repl
julia> test1d([1.0, 2.0, 1.0], [10:10:100])
```
"""
function test1D(filter, batches)

    # Winograd precomputation
    b1 = filter[1] + filter[3]
    b2 = (b1 + filter[2])/2.0
    b3 = (b1 - filter[2])/2.0
    b = [b2 b3]

    # Result arrays declaration
    times_fft = []
    times_wino = []
    times_naive = []

    # Benchmark at different amounts of data
    for batch in tqdm(batches)

        # Generate random data of length batch
        data1d = rand(Float64, (1, Int64(floor(batch))))

        # Zeropad data
        data1d_padded = zeropad1D(data1d, filter);
        
        # Generate output list
        N = Int64(length(data1d_padded) - length(filter) + 1);
        output_list = zeros(N);

        # Time algorithms
        t1 = @belapsed conv($data1d_padded, $gfilter);
        t2 = @belapsed Winograd1D!($data1d_padded, $filter, $N, $output_list, $b);
        t3 = @belapsed naive1D!($data1d_padded, $filter, $N, $output_list)

        # Store results
        times_fft = [times_fft; t1]
        times_wino = [times_wino; t2]
        times_naive = [times_naive; t3]
    end

    # Plot and save results
    p = plot(batches, [times_fft, times_wino, times_naive], title="log-log complexity plot", label=["FFT" "Winograd" "Naive"], linewidth=2, xscale=:log10, yscale=:log10, minorgrid=true, legend=:topleft)
    xlabel!(L"$log_{10}(N)$")
    ylabel!(L"$log_{10}(t)$")
    display(p)
    savefig(p,"file1d.png")
    


end

"""
    test2D(filter, batches)

    # Arguments
   - `filter::Array{}`: 1D filter, of size 3 (used as separable kernel)
   - `batches::Array{Integer}`: Lengths of arrays to convolve, of size NxN.

Benchmark Naive, FFT and winograd convolution in 2D with a filter for data lengths as specified
by an array termed batches. Plots log-log plot of time taken for each, and stores plot.

# Examples
```julia-repl
julia> test2d([1.0, 2.0, 1.0], [10:10:100])
```
"""
function test2D(filter, batches)

    # Create 2d filter from separable kernel vectors
    filter2d = filter*transpose(filter);
    filter = Float64.(filter)
    filter2d = Float64.(filter2d)

    # Winograd precomputation
    At = [1 1 1 0; 0 1 -1 -1]
    A = transpose(At)
    G = [1 0 0; 0.5 0.5 0.5; 0.5 -0.5 0.5; 0 0 1]
    Gt = transpose(G)
    Bt = [1 0 -1 0; 0 1 1 0; 0 -1 1 0; 0 1 0 -1]
    B = transpose(Bt)
    AtGFGtBt = At*((G*filter2d*Gt).*Bt)
    BA = B * A

    # Result arrays declaration
    times_fft = []
    times_wino = []
    times_naive = []

    # Benchmark at different amounts of data
    for batch in tqdm(batches)

        # Generate random data
        data2d = rand(Float64, (Int64(floor(batch)), Int64(floor(batch))))

        # Zeropad data
        data2d_padded = zeropad2D(filter2d, data2d);

        # Generate output array
        dw = size(data2d_padded,2)
        dh = size(data2d_padded,1)
        dw1 = dw-size(filter2d,2)
        dh1 = dh-size(filter2d,1)
        output_array = zeros(size(data2d));

        # Time algorithms
        t1 = @belapsed conv($filter, $filter, $data2d);
        t2 = @belapsed WinogradMatrix2D!($data2d_padded, $output_array,
                                $dw1, $dh1, $AtGFGtBt, $BA);
        t3 = @belapsed naive2D!($filter2d, $data2d_padded, $dw, $dh, $output_array)

        # Store results
        times_fft = [times_fft; t1]
        times_wino = [times_wino; t2]
        times_naive = [times_naive; t3]
    end

    # Plot and save results
    p = plot(batches, [times_fft, times_wino, times_naive], title="log-log complexity plot", label=["FFT" "Winograd" "Naive"], linewidth=2, xscale=:log10, yscale=:log10, minorgrid=true, legend=:topleft)
    xlabel!(L"$log_{10}(N)$")
    ylabel!(L"$log_{10}(t)$")
    display(p)
    savefig(p,"file2d.png")

end
