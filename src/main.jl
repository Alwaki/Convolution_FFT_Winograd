"""
Project:        Convolutions with Naive, FFT and Winograd methods

Description:    This project intends to benchmark convolution
                with the FFT algorithm and Winograd method, as
                well as a naive baseline implementation. 
                The benchmarking is intended to investigate
                differences in benefits for different data 
                and filter sizes.

Authors:        Alexander Wallén Kiessling & Viktor Svalstedt

Version:        2.0 (April 2023)
"""

import Pkg; 
Pkg.add(["FFTW", "DSP", "BenchmarkTools", "Plots", "LaTeXStrings", 
"ProgressBars", "ProfileView", "MKL", "LinearAlgebra"]);
using FFTW, DSP, BenchmarkTools, Plots, LaTeXStrings, ProgressBars, Profile, MKL, LinearAlgebra
include("winograd.jl")
include("tests.jl")
include("naive.jl")
include("util.jl")

# Specify threads (lasts through executions)
FFTW.set_num_threads(1)

# Run 1D test
datapoints = exp10.(range(1, stop=5, length=50))
filter = [1.0, 2.0, 1.0]
#test1D(filter, datapoints);

# Run 2D test
datapoints2d = exp10.(range(1, stop=3, length=4))
#test2D(filter, datapoints2d)

# Auxiliary testing

filter2d = filter*transpose(filter);
# Winograd precomputation
At = [1 1 1 0; 0 1 -1 -1]
A = transpose(At)
G = [1 0 0; 0.5 0.5 0.5; 0.5 -0.5 0.5; 0 0 1]
Gt = transpose(G)
Bt = [1 0 -1 0; 0 1 1 0; 0 -1 1 0; 0 1 0 -1]
B = transpose(Bt)
AtGFGtBt = At*((G*filter2d*Gt).*Bt)
BA = B * A
data2d = rand(Float64, (Int64(floor(10)), Int64(floor(10))))
data2d_padded = zeropad2D(filter2d, data2d);
dw = size(data2d_padded,2)
dh = size(data2d_padded,1)
dw1 = dw-size(filter2d,2)
dh1 = dh-size(filter2d,1)
output_array = zeros(size(data2d));

@benchmark WinogradMatrix2D!($data2d_padded, $output_array,
$dw1, $dh1, $AtGFGtBt, $BA)