set terminal pngcairo enhanced font "Arial,12"
set output "main.png" # Do not change
set xrange [-2*pi:2*pi]
set title "sin(x) and cos(x)"
set xlabel "x"
set ylabel "y"
set grid
plot sin(x) with lines title "sin(x)", cos(x) with lines title "cos(x)"
set output  # close file

