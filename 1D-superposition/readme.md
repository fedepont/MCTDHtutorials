### 1D-superposition

1. Run as many geninwf calculations to build a restart file for each 1D eigenfunction you want to superpose.
In the example we build only 2.
2. Run the analyse routine sumrstXX (XX is the mctdh version) to add all those restart files with coefficients. The input file of the analyse routine looks like this,

~~~
RUN-SECTION
  name      = suma_iniciales
  normalize 
end-run-section

INIT_WF-SECTION
 file  = state0
 coeff = 1.0 , 2.0
 file  = state1
 coeff = 1.0
end-init_wf-section

end-input
~~~

This file is **add_restart.inp**

*Note: The second number after the comma in the coeff line is the imaginary part of the coeff.*

3. Run the propagation or any calculation type you need using the restart file output from the step Two above.

