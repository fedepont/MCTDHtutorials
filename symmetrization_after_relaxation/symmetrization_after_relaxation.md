
There is a set of script build to run the simulation for a collission between an electron and a molecule with one electron bound. 

The molecule is described by
a nuclear distance and the electron coordinate. All in one dimension.
The objective is to relax the state in the molecule for the correlated coordinates (R and x2), and study the collision of the other electron (x1),
represented by a gaussian wave packet, against this molecule.
The trick is to get a totally symmetrized or anti symmetrized state in the electron coordinates.

The are 4 steps

**01_run_vlgrid_alpha.sh**

In this step we compute the relaxed state for the molecule.

It uses the files:
    -NeHeplus_inwf_relaxed.inp
    -NeHeplus_relaxation.op
    -E1_vs_R501_N501.dat
    -rvlgrid_tofill_relaxed.sh
    -AND all the links to the particles interactions.
    
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




