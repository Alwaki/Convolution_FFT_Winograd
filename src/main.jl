"""
Project:        Convolutions with Naive, FFT and Winograd methods

Description:    This project intends to benchmark convolution
                with the FFT algorithm and Winograd method, as
                well as a naive baseline implementation. 
                The benchmarking is intended to investigate
                differences in benefits for different data 
                and filter sizes.

Authors:        Alexander Wallén Kiessling & Viktor Svalstedt

Version:        1.1 (April 2023)
"""

import Pkg; 
Pkg.add(["FFTW", "DSP", "BenchmarkTools", "Plots", "LaTeXStrings", "ProgressBars", "ProfileView", "MKL"]);
using FFTW, DSP, BenchmarkTools, Plots, LaTeXStrings, ProgressBars, Profile, MKL
include("winograd.jl")
include("tests.jl")
include("naive.jl")
include("util.jl")

# Specify threads (lasts through executions)
FFTW.set_num_threads(1)

# Run 1D test
datapoints = exp10.(range(1, stop=5, length=50))
filter = [1.0, 2.0, 1.0]
filter = Float64.(filter)
test1D(filter, datapoints);

# Run 2D test
