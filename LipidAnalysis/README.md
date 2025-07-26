# 🧪✨ Integrative Analysis of Lipid Bilayer Simulations

### 🎬 Click on the image below to watch the molecular dynamics of membrane bilayer system:
[![Watch the video](https://img.youtube.com/vi/CyS_iq1PzTE/maxresdefault.jpg)](https://www.youtube.com/watch?v=CyS_iq1PzTE)

This repository containes cutting-edge script, that automates the analysis of membrane bilayer properties using GROMACS. The script is tailored for researchers, students, and educators involved in computational biophysics, particularly those working with biomembrane systems, such as lipid bilayers, membrane proteins, or drug-membrane interactions.

## 🔍 Overview
The script uses a suite of GROMACS utilities to perform quantitative analysis on membrane simulations, including:

- Area per lipid (APL): averaging the box dimensions over time and dividing by the number of lipids per leaflet.
- Bilayer thickness: estimated by computing the average distance between the phosphorus atoms (or other headgroup markers) across opposing leaflets.
- Deuterium order parameters (S_CD): computed using gmx order to assess the conformational order and fluidity of lipid tails—a key indicator of membrane phase behavior.
- Electron or mass density profiles: generated with gmx density to characterize structural asymmetries and distribution of membrane components along the bilayer normal.
- Lateral diffusion (optional): by tracking lipid center-of-mass displacement over time using gmx msd.

## 📁 Directory Structure
| File               | Description                                  |
|--------------------|----------------------------------------------|
| `lipids_bilayer.sh`| Main shell script for membrane analysis      |
| `README.md`        | You're here! Explanation and usage guide     |

## ⚙️ Requirements
- [GROMACS](http://www.gromacs.org/) (tested with version ≥2020)
- Bash shell (`.sh`)
- Typical input files from a molecular dynamics simulation (`.xtc`, `.tpr`, `.gro`, etc.)

## 🛫 Quick Start
```bash
chmod +x lipids_bilayer.sh
./lipids_bilayer.sh
```

## 🔭 Simulation Parameters

The analysis script is intended for **atomistic simulations** of lipid bilayer systems. To ensure meaningful and reproducible results, the following simulation conditions and parameters are typically assumed:

- **Ensembles:** NPT (constant pressure and temperature) ensemble, with semi-isotropic pressure coupling to allow for independent scaling in the membrane plane (XY) and normal (Z) directions.
- **Temperature:** Typically 298–310 K to mimic physiological conditions.
- **Pressure:** 1 bar, with **Parrinello-Rahman** or **Berendsen** barostat commonly used for pressure coupling.
- **Time Scale:** Simulations should span at least **100–200 ns** to allow for proper equilibration of the bilayer.
- **Force Fields:** Tested with all-atom force field **CHARMM36**.
- **Trajectory Sampling:** Sufficient temporal resolution (e.g., 10–100 ps/frame) for accurate calculation of dynamic properties like diffusion or order parameters.
- **Periodic Boundary Conditions (PBC):** Enabled in all directions; care should be taken during analysis to unwrap trajectories or center bilayers if necessary.


## ✨  Notes

Additional images with membrane modeling setups will be added soon

## ⚖️ License

This script is intended for **academic and educational purposes only**.  
Please cite the original tutorials and tools.

&copy; 2025 The Visual Hub
