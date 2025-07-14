# ⛵ High-Temperature Molecular Dynamics Journey 🔥

### 🎞️ Click on the image below to watch high-temperature molecular dynamics in action:
[![Watch on YouTube](https://img.youtube.com/vi/idJqUUbRUj0/maxresdefault.jpg)](https://youtu.be/idJqUUbRUj0)


The following Bash script automates Molecular Dynamics (MD) simulations at different temperatures using GROMACS. The simulations are performed at various temperatures under NPT ensemble conditions, using the Nosé-Hoover thermostat for temperature control and the Parrinello-Rahman barostat for pressure regulation. Additionally, this tutorial provides a brief introduction to molecular simulations with GROMACS, incorporating shell scripting and high-performance computing (HPC) on a cluster using batch job submission. The present tutorial is designed for membrane bilayer system BUT it can be easily adapted for any other modeling system, e.g. contained a water-soluble protein bound to a small-compound 💊.

---
## ⏳ Last update (14/07/2025):
- Additional references with other systems will be added soon to the REF directory.
---

## 🔍 Overview

- **System:** Pre-equilibrated POPC bilayer (can be used for any other system)
- **Ensemble:** NPT (constant pressure and temperature)
- **Thermostat:** Nose-Hoover
- **Barostat:** Parrinello-Rahman (semiisotropic)
- **Temperature range:** `323K`, `350K`, `400K`, `450K`, `500K`
- **Simulation time:** 50 ns per temperature
- **Job submission:** PBS batch system (with SLURM-compatible logic)

---

## 📁 Directory Structure

.  
├── ref/ # Input files: System.gro, System.top, System.ndx, System.cpt  
├── output/  
│ └── bilayer.burning/  
│ ├── simulations/ # Simulations for each temperature  
│ └── submitter.sh # Job submission script for all runs  
└── run_simulations.sh # Main script to generate and submit jobs  

---

## ⚙️ Requirements

- [GROMACS](https://www.gromacs.org/) (with CUDA support)
- A cluster with a PBS (or SLURM) batch system
- Bash shell (always provided with Linux or Mac!)
- Prepared input files in the `ref/` directory:
  - `System.gro`
  - `System.top`
  - `System.ndx`
  - `System.cpt` (optional, for continuation)
- This tutorial uses the CHARMM36 force field. Please download the required .itp files from the official MacKerell Lab’s CHARMM36:
https://mackerell.umaryland.edu/charmm_ff.shtml#gromacs
- The test bilayer system was created using http://www.charmm-gui.org
---

## ⛵ Quick Start

Execution of burn_bilayer.sh script on the local Linux machine will replicate the bilayer system to perform simulation of each replica at different temperature. This tutorial can be adapted for any molecular system with specific thermal coupling.

### 1. Prepare the Input System

- Best aproach: use all provided files
- Alternatively you can prepare a POPC bilayer using the following tutorials:

- [GROMACS Membrane Tutorial by Bevan Lab](http://www.bevanlab.biochem.vt.edu/Pages/Personal/justin/gmx-tutorials/membrane_protein/index.html)
- [CHARMM-GUI Membrane Builder](http://www.charmm-gui.org/)

Once prepared, place the following files into the `ref/` folder:

### 2. How to execute the Script

Run the following from your project root directory:

```bash
chmod +x ./run_simulations.sh
./run_simulations.sh
```

🔥 This command will:

    - Replicate test system creating a separate directory for each temperature (e.g., bilayer.burning_323K)

    - Generate a temperature-specific .mdp file for each simulation

    - Automatically generate a run.pbs job script for each simulation for HPC on your cluster

    - Create a submitter.sh script to submit all jobs at once

## ⚙️ Simulation Parameters (MDP)

Below is a summary of the key settings used in the generated `.mdp` files for the production MD simulations:  
NOTE cutoff-scheme is set to Verlet for simulations using GPU (with CUDA):


| Parameter              | Value                                       |
|------------------------|---------------------------------------------|
| `integrator`           | `md` (leap-frog algorithm)                  |
| `dt`                   | `0.002 ps` (2 fs time step)                 |
| `nsteps`               | `25000000` (total 50 ns per simulation)     |
| `nstlog`               | `5000` (log file update interval)           |
| `nstxout`              | `2500000` (coordinate output)               |
| `nstxout-compressed`   | `5000` (compressed coordinates)             |
| `nstvout`              | `5000` (velocities output)                  |
| `nstfout`              | `5000` (forces output)                      |
| `nstenergy`            | `5000` (energy output)                      |
| `cutoff-scheme`        | `Verlet`                                    |
| `rlist`                | `1.2 nm`                                    |
| `coulombtype`          | `PME`                                       |
| `rcoulomb`             | `1.2 nm`                                    |
| `vdwtype`              | `Cut-off`                                   |
| `vdw-modifier`         | `Force-switch`                              |
| `rvdw_switch`          | `1.0 nm`                                    |
| `rvdw`                 | `1.2 nm`                                    |
| `tcoupl`               | `Nose-Hoover`                               |
| `tc-grps`              | `MEMB SOL_ION`                              |
| `tau_t`                | `2.0 2.0`                                   |
| `ref_t`                | *Varies by temperature: 323K–500K*          |
| `pcoupl`               | `Parrinello-Rahman`                         |
| `pcoupltype`           | `semiisotropic`                             |
| `tau_p`                | `5.0 ps`                                    |
| `compressibility`      | `4.5e-5 4.5e-5` (x/y and z)                 |
| `ref_p`                | `1.0 1.0 bar` (x/y and z)                   |
| `gen_vel`              | `no` (no new velocities generated)          |
| `constraints`          | `h-bonds`                                   |
| `constraint_algorithm` | `LINCS`                                     |
| `continuation`         | `yes` (continues from checkpoint)           |
| `nstcomm`              | `100`                                       |
| `comm_mode`            | `linear`                                    |
| `comm_grps`            | `MEMB SOL_ION`                              |
| `refcoord_scaling`     | `com` (center-of-mass)                      |


## 🔭 Notes

    You can modify the list of temperatures in the temp_array variable inside run_simulations.sh.

    The script is configured for a PBS system but can be easily adapted to SLURM.

    Each simulation runs independently and can be submitted in parallel.

    The number of CPUs (cpus) and maximum runtime (sim_time) can be configured at the top of the script.

## ⚖️ License

This script is intended for **academic and educational purposes only**.  
Please cite the original tutorials and tools.

&copy; 2025 The Visual Hub
