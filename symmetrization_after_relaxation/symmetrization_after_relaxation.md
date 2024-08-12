1. **geninwf run** with input Phia_inuns.inp to create a WF with non identical 
particles. This is needed because we want different SPF basis for each particle.
This is because one electron is far away in a gaussian basis and the other electron is bound to the
QD's or molecule.
Here we use a non interating Hamiltonian.

3. **geninwf run** with input Phia_in.inp. This run only takes the previous WF 
and uses the mixed basis for the identical particles to create a initial WF.
Here we use a non interacting Hamiltonian.

5. **propagation run** with input Phia_full.inp. This run propagates the wave packets 
using the full Hamiltonian including Coulomb interaction and complex absorbing potential at the edges.

6. Analysis. 

The flux analysis is used to compute the reaction probabilities (RPs). We use th **flux**
analyse program of mctdh. It computes the flux going on to a definite absorbing potential. A typical line that I used looks like this,

~~~
flux84 -w -lo 28  -p 1000 -e -2.00 au -P 1 read ./L0 1 1 % -0.25 0.00 au Z2 right
~~~

where the modifiers means,


+ **-w** : rewrite.
+ **-lo 28** : start from the 28th time output onwards.
+ **-p 1000** : Number of energy points.
+ **-e -2.00 au**: Energy shift, because of the harmonic confinement the energies are shifted by 2 atomic units.
+ **-P 1 read ./L0 1 1 %**: A projector. The flux will measure only one coordinate,
here is Z2 (second parameter counting from the end of the line), then the other particle must be projected to the state of interest,
in this case is a precomputed L0 state located in directory ./L0.
+ **-0.25 0.00 au**: energy range of the flux with units,
+ **Z2 right**: the coordinate over which the flux is calculated and the side of the cap (right).


The output of the flux program mus be normalized with the initial wave packet energy distribution in order to get the RP.

Please ask if any question arises.
