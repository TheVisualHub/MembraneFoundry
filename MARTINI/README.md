## 🎬 MARTINI Coarse-Grained Modeling of GPCRs Oligomerization in a Multi-Lipid Membrane! 🍸✨

[![Watch the Shorts](https://github.com/TheVisualHub/VisualFactory/blob/aa62d075e6a471ca173dad8fea53666b5e629b88/assets/membrane_logo.jpeg)](https://youtube.com/shorts/2bHy32RXCBc)


This educational project uses the Martini 2 coarse-grained force field for modeling GPCR oligomerization.  

⚠️ Martini parameter files (e.g., `martini_v2.2.itp`, `martini_v2.0_lipids.itp`, etc.) are **not included** in this repository.  

To run the simulations, please download the required Martini files from the official website:  

👉 [https://cgmartini.nl](https://cgmartini.nl)  

For further guidance on building Martini systems, refer to the following tutorial:

👉 [INSANE Martini Tutorial (GitHub)](https://github.com/msidore/tutorial_insane/blob/master/INSANE_Tutorial.ipynb). 

After downloading, place the files in your working directory and verify that the `#include` paths in `topol.top` are correct.  

---

## 📚 Please cite the following key references when using the MARTINI force field:

- Marrink, S.J., et al. The MARTINI Force Field: Coarse Grained Model for Biomolecular Simulations. *J. Phys. Chem. B*, 2007, 111 (27), 7812-7824.  
- Monticelli, L., et al. The MARTINI Coarse-Grained Force Field: Extension to Proteins. *J. Chem. Theory Comput.*, 2008, 4 (5), 819-834.  

---

## ✨ Inslattation of GROMACS

The **Martini coarse-grained force field** is developed for use with [GROMACS](https://www.gromacs.org) is a **high-performance program for molecular dynamics simulations**, widely used to study systems from small molecules to complex biomolecular assemblies.  

### 🐧 Linux (Ubuntu/Debian)
```bash
sudo apt-get update
sudo apt-get install gromacs
```
### 🍎 MacOS
```bash
brew install gromacs
```

After installation, you can verify that GROMACS is installed and accessible by checking its version in Terminal:

```bash
gmx --version
```

---

## 🍸🧬✨ Craft Your MARTINI Universe — *A guide to the construction of the GPCRs embedded in multi-lipid membrane* 

The membrane model used in this tutorial comprises a mixture of two phospholipid types—POPE and POPC—along with cholesterol to mimic a biologically relevant environment. Both POPE and POPC lipids share a common fatty acid composition, each containing one saturated palmitoyl (16:0) chain and one monounsaturated oleoyl (18:1) chain, but differ in their headgroups:  
1️⃣ POPE (Phosphatidylethanolamine) features a smaller, more conical phosphoethanolamine headgroup, which tends to promote membrane curvature and flexibility, often localizing to the inner leaflet of membranes.  
2️⃣ POPC (Phosphatidylcholine) has a larger, cylindrical phosphocholine headgroup, contributing to membrane stability and fluidity, and is typically abundant in the outer leaflet.  
3️⃣ Cholesterol further modulates membrane order and thickness, providing a more physiologically relevant bilayer for the embedded GPCRs.

``` bash
# 📦 Prepare CG membrane template for a multi-lipid membrane composed of POPC, POPE and CHOLESTEROL:
./input/insane.py -l POPC:3 -l POPE:2 -l CHOL:1 -salt 0.15 -x 15 -y 10 -z 9 -d 0 -p topol.top -pbc cubic -sol W -o bilayer.gro

# ✏️ Edit topology using SED:
sed -i 's:#include "martini\.itp":#include "\.\./martini_ff/martini_v2\.2\.itp"\n#include "\.\./martini_ff/martini_v2\.0_lipids_all_201506\.itp"\n#include "\.\./martini_ff/martini_v2\.0_ions\.itp":' topol.top

g_make_ndx -f bilayer.gro

# ⚙️ Run minimization and equilibration using GROMACS:
g_grompp -f ./mdp/minimization.mdp -c bilayer.gro -p topol.top -o minimization.tpr -maxwarn 1
g_mdrun -deffnm minimization -v

g_grompp -f ./mdp/membrane_eq.mdp -c minimization.gro -p topol.top -o equilibration.tpr -n
g_mdrun -deffnm equilibration -v

# 🚀 Run Production Run
g_grompp -f ./mdp/membrane_md.mdp -c equilibration.gro -p topol.top -o production_run_CG.tpr
g_mdrun -deffnm production_run_CG -v

>> set retain_order,1
>> set pdb_retain_ids,1


###############################################
# 🧬 FOR A MEMBRANE PROTEIN SYSTEM
###############################################

# 1️⃣ Do parametrization of protein
python ./input/martinize.py -f ./input/AT1_prep_noH.pdb -o topol_cg.top -dssp /usr/local/bin/dssp -p backbone -pf 1000 -ff elnedyn22 -x CG.pdb
# optional elastic: -elastic -ef 500 -el 0.5 -eu 0.9 -ea 0 -ep 0

python ./input/martinize.py -f ./input/cytNMR.pdb -o topol_wsp.top -x wsp.pdb -dssp /projects/clouddyn/Software/dssp -p backbone -ff elnedyn22

g_editconf -f wsp.pdb -box 18 18 28 -o wsp.gro
g_editconf -f wsp.gro -translate 0 0 -10 -o wsp2.gro

# 🧪 Combine
g_genbox -cp wsp2.gro -cs MEMsystem.gro -vdwd 0.21 -o solvatedNEW.gro -box 18 18 28

# 📌 Add elastic restraints if needed:
# -elastic -ef 500 -el 0.5 -eu 0.9 -ea 0 -ep 0

# 2️⃣ Embed protein within the new lipid bilayer
./scripts/insane.py -charge 0 -salt 0.15 -x 15 -y 10 -z 9 -d 0 -pbc cubic -sol W -f CG.pdb -o CG_membrane.gro -p CG_membrane.top -center -l POPC:3 -l POPE:2 -l CHOL:1

# 📄 Combine all topologies
# These parameters can be obtained at https://cgmartini.nl](https://cgmartini.nl
#include "./martini_ff/martini_v2.2.itp"
#include "./martini_ff/martini_v2.0_lipids_all_201506.itp"
#include "./martini_ff/martini_v2.0_ions.itp"
#include "./martini_ff/martini_v2.0_solvents.itp"
#include "Protein.itp"

sed -i 's:#include \"martini\.itp\":#include "\./martini_ff/martini_v2\.2\.itp"\n#include "\./martini_ff/martini_v2\.0_lipids_all_201506\.itp"\n#include "\./martini_ff/martini_v2\.0_ions\.itp"\n#include \"Protein\.itp":' system.top

grompp -f ./mdp/equil.mdp -c system.gro -p system.top -o equilibration.tpr -n
make_ndx -f system.gro
#1|13 PROTMEMB
#     SOLV

# ⚙️ Run minimization and equilibration
gmx grompp -f ./mdp/minimization.mdp -c system.gro -p system.top -o minimization.tpr -n -maxwarn 1
gmx mdrun -nt 8 -deffnm minimization -v

gmx grompp -f ./mdp/equilibration.mdp -c minimization.gro -p system.top -o equilibration.tpr -n -maxwarn 1
gmx mdrun -nt 8 -deffnm equilibration -v

# 📦 Replicate system if necessary
gmx genconf -f equilibration.gro -nbox 4 4 1 -o system_big.gro
cp system.top system_big.top
gmx make_ndx -f system_big.gro

gmx grompp -f ./mdp/minimization.mdp -c system_big.gro -p system_big.top -o minimization2.tpr -n -maxwarn 1
gmx mdrun_d -nt 8 -deffnm minimization2 -v
cp minimization2.gro system_big_min.gro
rm ./#* ./minimization* ./equilibration* ./topol_cg.top ./system.*

# 🚀 Run MD
grompp -f ./mdp/equil.mdp -c system_big_min.gro -p system_big.top -o test.tpr -n
mdrun -nt 8 -deffnm test -v
```




## 🚀 Ready to Simulate?

Sit back and watch molecular choreography unfold! 💃🕺

---



