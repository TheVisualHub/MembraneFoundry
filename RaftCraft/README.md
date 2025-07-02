# Welcome to the Universe of **Raft Craft** 🛡️✨

## 🎞️ Click on the image to watch a 4K animation of cholesterol-enriched membrane raft modelled in all-atom molecular dynamics:
[![Watch the video](https://img.youtube.com/vi/mr-7WZk0iPI/maxresdefault.jpg)](https://youtu.be/mr-7WZk0iPI)


## 🛠️ Craft Your Own Lipid Rafts 
Design lipid microdomains that drive functional organization: **lipid rafts** enriched in sphingolipids, cholesterol, and saturated phospholipids.  
Whether you're exploring signal transduction, protein clustering, or membrane dynamics, **RaftCraft** lets you model membrane heterogeneity, blending Science and Art.

## 💠 Reconstruction of the Lipid Raft Microdomain Model
✨ This educational project generates a biologically relevant model of a **lipid raft**, capturing its principal structural features:  
enriched in **sphingomyelin (PSM)**, **cholesterol (CHOL)**, and **saturated phosphatidylcholine (DPPC)**, with a minor component of **unsaturated POPC** for heterogeneity. Such phase-separated bilayer mimics lateral organization of bilogical membranes.

| Amber Lipid21 Name | Properties   | Head Group             | Acyl Chains (Tails)                              |
|--------------------|--------------|------------------------|--------------------------------------------------|
| **PSM**            | Zwitterionic | Sphingomyelin          | Saturated sphingosine-based chain (16:0)         |
| **DPPC**           | Zwitterionic | Phosphatidylcholine    | sn-1 palmitoyl (16:0), sn-2 palmitoyl (16:0)     |
| **CHOL**           | Neutral      | Sterol                 | Rigid fused ring structure (no acyl chains)      |
| **POPC**           | Zwitterionic | Phosphatidylcholine    | sn-1 palmitoyl (16:0), sn-2 oleoyl (18:1)        |

This lipid composition models a lipid raft by enriching sphingomyelin and cholesterol to create a tightly packed, ordered microdomain, supported by saturated DPPC for membrane stability, with minimal unsaturated POPC to mimic natural membrane heterogeneity. This ratio captures the key physicochemical properties essential for raft formation and function. The following `packmol-memgen` command generates a lipid raft model following this structural recipe:

```bash
# 🎉 KEY OPTIONS:
# --lipids and --ratio -> mimicking lipid raft membrane composition
# --pdb -> inserts protein into packed membrane - comment it for a pure membrane simulation
# --keep ligs -> keeps ligands for parametrization (covered in another tutorial)
# --preoriented -> uses a pre-oriented protein structure (e.g., from OPM or PDBTM)
# --parametrize -> generates topology (prmtop) and coordinate files with AmberTools
#
packmol-memgen \
  --lipids PSM:CHOL:DPPC:POPC \
  --ratio 4:3:2:1 \
  --salt \
  --salt_c Na+ \
  --pdb your_protein_structure.pdb \
  --ffprot ff14SB \
  --fflip lipid21 \
  --ffwat tip3p \
  --distxy_fix 100 \
  --dist_wat 50 \
  --keepligs \
  --preoriented \
  --parametrize \
  --minimize
```

And here is a visual example of the membrane raft model created using this one-line Bash command for advanced membrane modeling:

<p align="center">
  <img src="https://github.com/TheVisualHub/VisualFactory/blob/a87c4993090276dbaac2919edf800a01e33a6f64/assets/raftcraft_logo1.png" alt="RaftCraft Preview">
</p>


## ⏳ Coming soon:
A streamlined, robust, and fully scriptable tools for constructing complex lipid rafts along with the examples of multi-lipid systems.  
  
## 🧬 Install AmberTools with Conda
  The Packmol-Memgen, used for creation of biomembranes, is a part of [AmberTools](https://ambermd.org/AmberTools.php)  
  Below is a simple installation method for Linux or macOS using conda: 

```bash
# Create and activate environment
conda create -n ambertools -c conda-forge ambertools
conda activate ambertools

# Test installation calling tleap or cpptraj in the Terminal
tleap -h
cpptraj -h
```

## 🌀 Another vivid example: the respiratory supercomplex III/IV
In mitochondria and many bacteria, reduction of the dioxygen electron acceptor is catalyzed by cytochrome c oxidase (complex IV), which receives electrons from cytochrome bc1 (complex III). These enzymes are collectively referred to as the respiratory chain because they are wired to transfer electrons, driving energy production. This bacterial supercomplex III/IV is embedded in a biological membrane environment that includes lipid rafts enriched in sphingolipids and cholesterol-like lipids that create tightly packed regions within the membrane. These lipid rafts play a crucial role in organizing and stabilizing membrane proteins, facilitating efficient electron transfer and signaling by modulating local membrane properties. Click on the following image to explore all-atom molecular dynamics of the bacterial supercomplex III/IV modeled within an explicit membrane environment:

[![Watch the video](https://img.youtube.com/vi/RfPajWKicWk/maxresdefault.jpg)](https://youtu.be/RfPajWKicWk)
