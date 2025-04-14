package main

import (
	"C"
	"math"
)

// Euclidean algorithm for GCD
func gcd(a, b int) int {
	for b != 0 {
		a, b = b, a%b
	}
	return a
}

//export calcpi
func calcpi(Nc C.int) C.double {
	c := 0
	N := int(Nc)
	for a := 1; a < N; a++ {
		for b := 1; b < N; b++ {
			if gcd(a, b) == 1 {
				c++
			}
		}
	}
	prob := float64(c) / float64(N) / float64(N)
	pi_approx := math.Sqrt(6.0 / prob)
	return C.double(pi_approx) // Convert Go float64 to C double
}

func main() {} // Required for cgo
