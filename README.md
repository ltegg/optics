# optics
*A collection of .sh and .py scripts to handle files generated by the *OPTIC* routine within* WIEN2k.

Composed by _____

## Description
*WIEN2k* is a collection of programs used to solve the Kohn-Sham equations as part of Density Functional Theory. Once a calculation has been completed, the *OPTIC* routine (consisting of programs `lapw2 -fermi`, `optic`, `joint`, and `kram`) will generate files containing optical properties data, such as the dielectric function (`*.epsilon`), or the optical conductivity (`*.absorp`).

This repository contains scripts that parse some of the files written by *WIEN2k* and *OPTIC*, and calculate other optical properties, such as the complex refractive index, and the normal-incidence reflectivity, from which an estimation of the apparent colour can be derived.

## Requirements
This repository contains both Python (.py) and bash (.sh) scripts. In general, each script can be installed and used independently of the other scripts within this repository.

### Python
All of the scripts were written using Python 3.4(check). The libraries used are

- glob - *to perform bash-style directory searching*
- numpy - *the bulk of the data/array handling*
- matplotlib.pyplot - *to generate plots of the optical properties*

These scripts were written using Spyder 3.1.x, under Anaconda3.
    
### Bash
The bash scripts are largely handlers for the Python scripts, where tools within Python were unwieldly, or I simply knew how to achieve my goal using bash. They should work with any bash terminal.

## Usage
Most of the python scripts include code to search the present working directory (pwd) for the files it needs. For example, in the case of `optic.py`:

1. Run `optic.py` in a folder containing a single `*.epsilon` file.
2. `optic.py` will automatically parse the `*.epsilon` file to determine the number of columns/directions present i.e., 1D (cubic), 2D (hexagonal or tetragonal) or 3D (orthorhombic, monoclinic, triclinic). *Note: At this stage, the scripts do not support more than 3 columns from the dielectric densor.*
3. The script will then calculate other optical properties. In the case of `optic.py`, the following will be calculated:
  - Complex refractive index (n,kappa)
  - Normal-incidence vacuum reflectivity (R)
  - Electron energy-loss spectrum (EELS)
  - Apparent colour using CIESTANDARD
4. The dataset will be printed to a `*.csv` file, and some figures will be printed to `*.png` files by default, though this can be modified. These files will be saved to the same directory as the `*.epsilon` file.

Further information can be found in the comments of each script.

## Known Issues
These scripts are designed for a very specific purpose, and so have not been designed with robustness or security in mind. As such, there are probably very many usage scenarios where these scripts produce incorrect results or fail completely. The author accepts no responsibility for results obtained using these scripts, and encourages users to read the scripts in their entirety before use. That said, there are some issues and bugs that I am aware of (and you should be too):

- The scripts `optics.py`, `conductivity.py` only accept up to 3-dimensions worth of data. Regardless of what columns were actually specified in `*.inop`, the `optics.py` script assumes:
  - 3 columns present in file = 1 column of energy + 1 column of epsilon_1 + 1 column of epsilon2 (x = y = z)
  - 5 columns present in file = 1 column of energy + 2 columns of epsilon_1 + 2 columns of epsilon2 (x = y =/= z)
  - 7 columns present in file = 1 column of energy + 3 columns of epsilon_1 + 3 columns of epsilon2 (x =/= y =/= z)
- Accurately interpolating wavelength and reflectivity for the calculation of the apparent colour relies on a fine energy spacing (in eV) across the visible energy range. The default values in `*.inop` are generally sufficient, but check your discretisation to ensure there are no sudden changes in the refractive index.
- When 2 or more dimensions are present some of the graphs generated by `optics.py` include optical constants for each direction (x,z or x,y,z), as well as a weighted sum (x+y+z). This is calculated via xyz = (x + y + z) / 3. Be aware that in the case of EELS data, the true loss spectrum for a polycrystalline sample of an anisotropic material cannot be calculated in this way. The xyz curve approximation is valid for when the dielectric function the x, y and z directions are *similar*.

## Feedback
I've uploaded the scripts onto GitHub so that they may be shared, repurposed and edited freely. That said, if you find an issue with the scripts that you'd like to discuss or have fixed, you are welcome to submit a pull request.

If you have questions about the physics and maths within the scripts, I would encourage you to leave a comment.
