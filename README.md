# optics
*A collection of .sh and .py scripts to handle files generated by the* OPTIC *programs within* WIEN2k.

By Levi Tegg

## Description
[*WIEN2k*](http://susi.theochem.tuwien.ac.at/) is a collection of programs used to perform electronic structure calculations of solids, using density functional theory. Once a calculation has been completed, the *OPTIC* routine (consisting of programs `lapw2 -fermi`, `optic`, `joint`, and `kram`) will generate files containing optical properties data, such as the dielectric function (`*.epsilon`), or the optical conductivity (`*.absorp`).

This repository contains scripts which parse some of the files written by *WIEN2k* and *OPTIC*, then calculate optical constants such as complex refractive index, electron energy-loss spectra (EELS), and an approximation of the apparent colour.

## Requirements
This repository contains both Python (`.py`) and bash (`.sh`) scripts. In general, each script can be installed and used independently of the other scripts within this repository.

### Python
All of the scripts were written using Python 3.5. Though each script differs slightly, the main libraries used are [numpy](http://www.numpy.org/), pyplot from [matplotlib](https://matplotlib.org/index.html), [glob](https://docs.python.org/3.5/library/glob.html), and [sys](https://docs.python.org/3.5/library/sys.html). These scripts were written using Spyder 3.1.x, using the Anaconda3 distribution.
    
### Bash
The bash scripts are largely handlers for the Python scripts. They should work with any bash-like terminal.

## Installation
Some of the scripts (e.g., `optics.py`) should work anywhere. In some cases, a `.sh` will call a `.py` script, which is described by a path (e.g., `ETEST.sh` and `ETEST.py`). In such cases, inspect and edit the `.sh` files as necessary.

## Usage
Most of the python scripts include code to search the present working directory (pwd) for the files it needs. Alternatively, arguments can be passed to the script to tell it exactly what to process.

### `optics.py`
Calculates optical properties using a `*.epsilon` file. Calling

`$ python3 optics.py`

in a directory with one or more `*.epsilon` files will process all of the `*.epsilon` files in the pwd. Alternatively, calling

`$ python3 optics.py case1.epsilon case2.epsilon case3.epsilon ...`

will make `optics.py` process only those epsilon files passed as arguments.

If 3 columns are found in a `*.epsilon` file, the script will assume a one-dimensional case. If 5 columns are found, the script will assume the x- and y-directions are equal, and the z-direction is different. If 7 columns are found, the script will assume the x-, y- and z-directions are different. Currently, there is no support for more than 3-directions.

The script will save images and data files with the same case name as the `*.epsilon` file, in the same directory as the `*.epsilon` file.

Further information can be found in the script comments.

### `bands.sh`
After `optic` has finished, calling

`$ bands.sh`

will `grep` the `*.output2` file and print the number of bands, as well as the Fermi energy, for use in `*.injoint`.

### `wp.sh`
After `joint` with option 6 has been run, calling

`$ wp.sh`

will `grep` the `*.outputjoint` and print the plasma frequencies, for use in `*.inkram`.

### `lapw1_check.sh`
In a directory where a non-parallelised `lapw1` is running, calling

`$ lapw1_check.sh`

will report how many k-points have been completed compared to the total number. Useful for checking how much longer a given iteration of `lapw1` has remaining. Note that it doesn't (yet) work for parallelised cases, where multiple `*.output1` files are generated.

### `ETEST.sh` and `ETEST.py`
In a directory where a `STDOUT` file is being generated by *WIEN2k* and *w2web*, calling

`$ ETEST.sh`

will parse the `STDOUT` file, then call `ETEST.py`, and produce a plot of the `ETEST` parameter as a function of the number of cycles. The script then calls Eye of Gnome (`eog`) to automatically open the image. On systems without eog, the image will still be produced, but the shell script will return an error. 

## Issues
These scripts are designed for a very specific purpose, and so have not been designed with robustness or security in mind. As such, there are probably very many usage scenarios where these scripts produce incorrect results or fail completely. The author accepts no responsibility for results obtained using these scripts, and encourages users to read the scripts in their entirety before use. That said, there are some issues and bugs that I am aware of (and you should be too):

- Accurately interpolating wavelength and reflectivity for the calculation of the apparent colour in `optic.py` relies on a fine energy spacing (in eV) across the visible energy range. The default values in `*.inop` are generally sufficient, but check your discretisation to ensure there are no sudden changes in the refractive index.
- When 2 or more dimensions are present some of the graphs generated by `optics.py` include optical constants for each direction (x, x,z or x,y,z), as well as a weighted sum (x+y+z). This is calculated via xyz = (x + y + z) / 3. Be aware that in the case of EELS data, the true loss spectrum for a polycrystalline sample of an anisotropic material cannot be calculated in this way.
- `ETEST.sh` and `ETEST.py` assume that the output from the SCF cycle is being printed to a file called `STDOUT` in the directory of the calculation. `w2web` does this by default, but this is not typical behaviour when `run_lapw` is called from the command line. Use `analyse_scf` to parse the `*.scf` file for other quantities.

## Feedback
I've uploaded the scripts onto GitHub so that they may be shared, repurposed and edited freely. That said, if you find an issue with the scripts that you'd like to discuss or have fixed, you are welcome to submit a pull request or issue.
