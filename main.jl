import Pkg; Winograd;
Pkg.add("FFTW"); Pkg.add("DSP"); Pkg.add("BenchmarkTools"); Pkg.add("Plots")
Pkg.add("LaTeXStrings")
using FFTW, DSP, BenchmarkTools, Plots, LaTeXStrings

################################################
##
## PLOT 1D AND TIME RESULTS WITH COMPLEXITY PLOT
##
################################################

# Specify threads (lasts through executions)
FFTW.set_num_threads(1)

# Create data of different input sizes, and filter with one size
filter1d = [1.0 2.0 1.0]
print(typeof(filter1d))
g = filter1d
b1 = g[1] + g[3]
b2 = 0.5*(b1 + g[2])
b3 = 0.5*(b1 - g[2])
times_fft = []
times_wino = []
batches = 10000:10000:1000000
for d in batches
    global data1d = rand(Float64, (1, d))
    t1 = @belapsed conv(data1d, filter1d);
    t2 = @belapsed Winograd(data1d, filter1d, b2, b3);
    global times_fft = [times_fft; t1]
    global times_wino = [times_wino; t2]
end

p = plot(batches, [times_fft, times_wino], title="log-log complexity plot", label=["FFT" "Winograd"], linewidth=2, xscale=:log10, yscale=:log10, minorgrid=true)
xlabel!(L"$log_{10}(N)$")
ylabel!(L"$log_{10}(t)$")


################################################
##
## WORK ON MATRIX FORM WINOGRAD
##
################################################

#=
filter2d = [1.0 1.0 1.0; 1.0 2.0 1.0; 1.0 1.0 1.0]
data2d = [0.0 1.0 1.0 1.0; 2.0 3.0 4.0 5.0; 1.0 2.0 3.0 4.0; 0.0 2.0 1.0 3.0]
At = [1 1 1 0; 0 1 -1 -1]
G = [1 0 0; 0.5 0.5 0.5; 0.5 -0.5 0.5; 0 0 1]
Bt = [1 0 -1 0; 0 1 1 0; 0 -1 1 0; 0 1 0 -1]

y = At*((G*filter2d*transpose(G)).*(Bt*data2d*transpose(Bt)))*transpose(At)
y2 = conv(data2d, filter2d)
=#
