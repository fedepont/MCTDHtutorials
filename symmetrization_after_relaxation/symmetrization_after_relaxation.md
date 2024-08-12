
There is a set of script build to run the simulation for a collission between an electron and a molecule with one electron bound. 

The molecule is described by
a nuclear distance and the electron coordinate. All in one dimension.
The objective is to relax the state in the molecule for the correlated coordinates (R and x2), and study the collision of the other electron (x1),
represented by a gaussian wave packet, against this molecule.
The trick is to get a totally symmetrized or anti symmetrized state in the electron coordinates.

The are 4 steps

**01_run_vlgrid_alpha.sh**

In this step we compute the relaxed state for the molecule.

**02_run_vlgrid_alpha.sh**

Uses the output from 1.

In this step we give electron x1 wave function the shape of a Gaussian.

**03_run_vlgrid_alpha.sh**

Uses the output from 2.

In this step we read the first non-zero A coefficients if the relaxed state and build a properly symmetrized state
using the Gaussian incoming state and the contribution of the bound electron x2.

**04_run_vlgrid_alpha.sh**

Uses the output from 3.

This is just the propagation run.



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
