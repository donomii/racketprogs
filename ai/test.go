package main
import (
	"fmt"

	"github.com/sugarme/gotch"
	"github.com/sugarme/gotch/ts"
)

func basicOps() {

xs := ts.MustRand([]int64{3, 5, 6}, gotch.Float, gotch.CPU)
fmt.Printf("%8.3f\n", xs)
fmt.Printf("%i", xs)

/*
(1,.,.) =
   0.391     0.055     0.638     0.514     0.757     0.446  
   0.817     0.075     0.437     0.452     0.077     0.492  
   0.504     0.945     0.863     0.243     0.254     0.640  
   0.850     0.132     0.763     0.572     0.216     0.116  
   0.410     0.660     0.156     0.336     0.885     0.391  

(2,.,.) =
   0.952     0.731     0.380     0.390     0.374     0.001  
   0.455     0.142     0.088     0.039     0.862     0.939  
   0.621     0.198     0.728     0.914     0.168     0.057  
   0.655     0.231     0.680     0.069     0.803     0.243  
   0.853     0.729     0.983     0.534     0.749     0.624  

(3,.,.) =
   0.734     0.447     0.914     0.956     0.269     0.000  
   0.427     0.034     0.477     0.535     0.440     0.972  
   0.407     0.945     0.099     0.184     0.778     0.058  
   0.482     0.996     0.085     0.605     0.282     0.671  
   0.887     0.029     0.005     0.216     0.354     0.262  



TENSOR INFO:
        Shape:          [3 5 6]
        DType:          float32
        Device:         {CPU 1}
        Defined:        true
*/

// Basic tensor operations
ts1 := ts.MustArange(ts.IntScalar(6), gotch.Int64, gotch.CPU).MustView([]int64{2, 3}, true)
defer ts1.MustDrop()
ts2 := ts.MustOnes([]int64{3, 4}, gotch.Int64, gotch.CPU)
defer ts2.MustDrop()

mul := ts1.MustMatmul(ts2, false)
defer mul.MustDrop()

fmt.Printf("ts1:\n%2d", ts1)
fmt.Printf("ts2:\n%2d", ts2)
fmt.Printf("mul tensor (ts1 x ts2):\n%2d", mul)

/*
ts1:
 0   1   2  
 3   4   5  

ts2:
 1   1   1   1  
 1   1   1   1  
 1   1   1   1  

mul tensor (ts1 x ts2):
 3   3   3   3  
12  12  12  12  
*/


// In-place operation
ts3 := ts.MustOnes([]int64{2, 3}, gotch.Float, gotch.CPU)
fmt.Printf("Before:\n%v", ts3)
ts3.MustAddScalar_(ts.FloatScalar(2.0))
fmt.Printf("After (ts3 + 2.0):\n%v", ts3)

/*
Before:
1  1  1  
1  1  1  

After (ts3 + 2.0):
3  3  3  
3  3  3  
*/
}
