
# Symmetrization of electrons after a _partial_ relaxation that includes one electron #

There is a set of scripts to run the simulation for a collission between an electron and a molecule with one electron already binded to it. 

The molecule is described by a nuclear distance and the electron coordinate. All in one dimension.
The objective is to relax the state in the molecule for the correlated coordinates (say R and x2), and study the collision of the other electron (x1),
represented by a gaussian wave packet, against this molecule.

The trick is to get a *totally (anti-)symmetrized* state in the electron coordinates.

There are 4 steps

## 01_run_vlgrid_alpha.sh ##

**Description:** In this step we compute the relaxed state for the molecule.

It uses the files:

* NeHeplus_inwf_relaxed.inp
* NeHeplus_relaxation.op
* E1_vs_R501_N501.dat
* rvlgrid_tofill_relaxed.sh
* AND all the links to the particles interactions.

From the SPF basis section in `NeHeplus_inwf_relaxed.inp` we see that there are no identical modes

~~~
SBASIS-SECTION
  X1   = 20
  X2   = 20
  R     = 18
  #R     = 14
end-sbasis-section
~~~

In the `INIT_WF-SECTION` we can see that the initial state for the incoming electron `X1` is a "flat" state.

~~~
INIT_WF-SECTION
build
  X1 HO 0.0 0.0 0.0
  X2 eigenf 1e2N pop=1
  R eigenf ground_state pop=1
end-build
~~~

Moreover if you see the Hamiltonian in `NeHeplus_relaxation.op`, you will notice there is no interaction whatsoever between `X1` and `X2` or `R`. Then, the relaxation occurs only for `X2` and `R` given a relaxed state for the NeHe+ cation.

~~~
HAMILTONIAN-SECTION
-----------------------------------------------------
modes    |  X1  |  X2  | R 
-----------------------------------------------------
1.0      |  1   |  KE  |  1
1.0      |  1   |  1   |  KE
1.0      |  1   |  1   | VNN*VNNgauss
-1.0    |2&3 VNeA
-1.0    |2&3 VNeB
----------------------------------------------------
end-hamiltonian-section
~~~

After the relaxation, we can obtain the A-coefficients of the multiconfigurational wave function using `rdacoeff86` analysis rutine. The routine will give the A coeffs for each relaxation time. The last one is the one that is useful for us. This is an example of the output (`E=0.600 au`),

~~~
------- Time =    1.0000 fs -------         ( cmplx)

        J            A                   j1 j2 j3 j4 j5 ...
  -------------------------------------------------------------------------
        1  (-0.998869598, 0.000000000)    1  1  1
      421  ( 0.047385849, 0.000000000)    1  2  2
      841  (-0.003740164, 0.000000000)    1  3  3
     1261  (-0.000378915, 0.000000000)    1  4  4
     1681  (-0.000044665, 0.000000000)    1  5  5
     2101  ( 0.000011464, 0.000000000)    1  6  6
     2521  ( 0.000000012, 0.000000000)    1  7  7

 Number of A-coeffs with absolute values between 1.00E-08 1.00E+08 :       7
 Norm of these A-coeffs (sqrt[sum|A|^2]):  1.00000001,  norm^2 =  1.00000003
----------------------------------------------------------------------------
~~~

What we can see here is that the only populated SPF for `X1` (corresponding to `j1`in the table) is the number 1.
For `X2`(`j2`) and `R`(`j3`) the relaxation has correlated the SPFs and there is several contributions.

    
## 02_run_vlgrid_alpha.sh ##

**Description:** In this step we give electron x1 wave function the shape of a Gaussian.

Uses the output from 1.
It uses the files:

* NeHeplus_inwf_punched.inp
* NeHeplus_relaxation.op
* E1_vs_R501_N501.dat
* rvlgrid_tofill_punched.sh
* AND all the links to the particles interactions.

The input file for this step `NeHeplus_inwf_punched.inp` reads the output from the relaxation and operates with two projection operators,

~~~
INIT_WF-SECTION
file= inwf_relaxed
operate=ProjX1,punchX1
end-init_wf-section
~~~

If we check in the operator file `NeHeplus_relaxation.op` we can see the definition of this projections as extra `HAMILTONIAN-SECTION`,

~~~
HAMILTONIAN-SECTION_punchX1
-----------------------------------------------------
modes    |  X1
-----------------------------------------------------
1.0      |  punch
----------------------------------------------------
end-hamiltonian-section

HAMILTONIAN-SECTION_ProjX1
-----------------------------------------------------
modes    |  X1
-----------------------------------------------------
1.0      |  projg
----------------------------------------------------
end-hamiltonian-section
~~~

were the `punch` and `projg` are defined in the `LABELS-SECTION`,

~~~
LABELS-SECTION
.
..
...
punch=Exp[PPP,0]
projg=pgauss[DXX,-172.0]
...
..
.
end-labels-section
~~~

As we see in the definition of the [MCTDH guide](https://www.pci.uni-heidelberg.de/tc/usr/mctdh/doc/guide/guide.pdf) table C.3,  they are projection onto a Gaussian and multiplication by an exponential. The gaussian projection provides the shape and the complex exponential the "punch" that gives the initial impulse of the incoming electron. Note that the gaussian is centered at  `-172.0`, far away from the molecule CM.

This step is a `geninwf` run that only produces a new `restart` file. At this stage, the `A-coeff` is the same (in absolute value!) as in the previous step, we only modified the SPFs of the `X1` coordinate.

~~~
      J            A                   j1 j2 j3 j4 j5 ...
  -------------------------------------------------------------------------
        1  (-0.435514695, 0.898925690)    1  1  1
      421  ( 0.020660589,-0.042644564)    1  2  2
      841  (-0.001630740, 0.003365934)    1  3  3
     1261  (-0.000165210, 0.000341001)    1  4  4
     1681  (-0.000019474, 0.000040196)    1  5  5
     2101  ( 0.000004999,-0.000010317)    1  6  6
     2521  (-0.000000005, 0.000000010)    1  7  7

 Number of A-coeffs with absolute values between 1.00E-08 1.00E+08 :       7
 Norm of these A-coeffs (sqrt[sum|A|^2]):  1.00000000,  norm^2 =  1.00000000
~~~

## 03_run_vlgrid_alpha.sh ##

**Description:** In this step we read the starting non-zero A coefficients for the relaxed state and build a properly symmetrized state using the Gaussian incoming state of  electron `X1`  and the contribution of the bound electron `X2`.

Uses the output from 2.

It uses the files:

* NeHeplus_inwf_symm.inp 
* NeHeplus_relaxation.o
* E1_vs_R501_N501.dat
* rvlgrid_tofill_symm.sh
* header
* editor_wfcoeffs.py
* AND all the links to the particles interactions.

We need to (Anti)symmetrize the electrons in our problem since they are identical particles. Our technical problem here is that we have an expansion for the cation state,

![unsymmetrized cation state](./unsymm.png)

Then the complete state for the system is,

![complete unsymmetrized state](./complete_unsymm.png)

![complete unsymmetrized state expanded](complete_uns_expanded.png)

\noindent Note that only "Diagonal`` terms ($C_{i,i}$) are shown in the expansion. This is a fact, after calculation, more than a simplification.
If we want to symmetrize the wave function we need to perform two actions in MCTDH. _First_ $X_1$ and $X_2$ should share SPFs basis since we want to use the identical keyword (id). _Second_, combine this new SPFs in the initial state so that the electrons are correctly symmetrized.

***First step***

The SPFs for the output from 3  are 

| SPFs (gauss)    | SPFs (mol)|
| -------- | ------- |
| $\phi^{(gauss)}_{1}=g.1$  | $\phi^{(mol)}_{1}=m.1$    |
| $\phi^{(gauss)}_{2}=g.2$ | $\phi^{(mol)}_{2}=m.2$    |
| $\phi^{(gauss)}_{3}=g.3$   | $\phi^{(mol)}_{3}=m.3$  |
| $\phi^{(gauss)}_{4}=g.4$   | $\phi^{(mol)}_{4}=m.4$  |

If you use the symorb=1,2 keyword you get,

| SPFs (X1 and X2)    |
| -------- |
| $\phi^{(n)}_{1}$=n.1=g.1 | 
| $\phi^{(n)}_{2}$=n.2=m.1 |
| $\phi^{(n)}_{3}$=n.3=g.2 |
| $\phi^{(n)}_{4}$=n.4=m.2 |
| $\phi^{(n)}_{5}$=n.5=g.3 |
| $\phi^{(n)}_{6}$=n.6=m.3 |
| $\phi^{(n)}_{7}$=n.7=g.4 |
| $\phi^{(n)}_{8}$=n.8=m.4 |

***Second step***

And we want this new symmetrized state,

![symmetrized state](symmetrized_state.png)

Note that according to the numbers in the configurations, $C_{1,1}=A_{1,2,1}=A_{2,1,1}$ ; $C_{2,2}=A_{1,4,1}=A_{4,1,1}$ and
$C_{3,3}=A_{1,6,1}=A_{6,1,1}$ which gives a clear set up for the `A-coeff` section we need to build.

When runnning the script `03_run_vlgrid_alpha.sh`, the code will get the `A-coeff` from the state from step 2 and insert it into the input file `NeHeplus_inwf_symm.inp` to construct a properly symmetrized state. This is done using `rdacoeff86` analysis routine and the python script `editor_wfcoeffs.py` which uses pandas to handle the data. The result is this section,

~~~
A-coeff
1 2 1 (-0.435514695,0.898925690)
2 1 1 (-0.435514695,0.898925690)
1 4 2 (0.020660589,-0.042644564)
4 1 2 (0.020660589,-0.042644564)
1 6 3 (-0.001630740,0.003365934)
6 1 3 (-0.001630740,0.003365934)
1 8 4 (-0.000165210,0.000341001)
8 1 4 (-0.000165210,0.000341001)
1 10 5 (-0.000019474,0.000040196)
10 1 5 (-0.000019474,0.000040196)
1 12 6 (0.000004999,-0.000010317)
12 1 6 (0.000004999,-0.000010317)
end-A-coeff
~~~


**04_run_vlgrid_alpha.sh**

Uses the output from 3.

This is just the propagation run where the `id` keyword is given in the `SPFs` section,

~~~
SBASIS-SECTION
  X1   = 20
  X2   = id, 1
  R     = 18
  #R     = 14
end-sbasis-section
~~~




