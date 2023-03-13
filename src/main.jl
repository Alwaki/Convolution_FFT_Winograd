"""
Project:        FFT and Winograd convolutions

Description:    This project intends to benchmark convolution
                with the FFT algorithm and Winograd method. 
                The benchmarking is intended to investigate
                differences in benefits for different data 
                and filter sizes.

Authors:        Alexander Wallén Kiessling & Viktor Svalstedt

Version:        0.1 (March 2023)
"""

import Pkg; 
Pkg.add(["FFTW", "DSP", "BenchmarkTools", "Plots", "LaTeXStrings", "ProgressBars"]);
using FFTW, DSP, BenchmarkTools, Plots, LaTeXStrings, ProgressBars
include("winograd.jl")
include("tests.jl")

# Specify threads (lasts through executions)
FFTW.set_num_threads(1)

# Run 1D test
test1D([1.0, 2.0, 1.0], 10:10:100);