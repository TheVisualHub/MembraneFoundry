# Welcome to the **Lipid Forge** 🔥

## 🎞️ Click on the image to watch a 4K animation of a multi-lipid membrane system modelled in all-atom molecular dynamics:
[![Watch the video](https://img.youtube.com/vi/_8Gq76UBun4/maxresdefault.jpg)](https://www.youtube.com/watch?v=_8Gq76UBun4)

## 🔨 Forge Your Own Membranes  
Step into the lipid workshop: design and refine realistic multi-lipid systems tailored to your brilliant research. 💎  
Whether you’re modeling muilti-lipid bilayers, mixing exotic lipids, or preparing membrane protein systems for molecular dynamics — **Lipid Forge** gives you artisan-level control with scriptable reproducibility.  

## 💠 Reconstruction of Mitochondrial Four-lipid Membrane 
  ✨ This educational project builds a realistic model of the mitochondrial inner membrane, based on its characteristic lipid composition: ~40% phosphatidylcholine (POPC), ~30% phosphatidylethanolamine (POPE), ~20% cardiolipin (TLCL2), and ~10% phosphatidylinositol (POPI). These four lipids form a cardiolipin-rich environment that stabilizes respiratory complexes and mimics the membrane structure.
| Amber Lipid21 name | Properties         | Head group              | Acyl chains (tails)                        |
|-------------------:|-------------------:|-----------------------:|--------------------------------------------:|
| POPC               | Zwitterionic       | Phosphatidylcholine     | sn-1 palmitoyl (16:0), sn-2 oleoyl (18:1)  |
| POPE               | Zwitterionic       | Phosphatidylethanolamine| sn-1 palmitoyl (16:0), sn-2 oleoyl (18:1)  |
| TLCL2              | Anionic (−2 charge)| Cardiolipin             | Four linoleoyl (18:2) chains               |
| POPI               | Anionic (−1 charge)| Phosphatidylinositol    | sn-1 palmitoyl (16:0), sn-2 oleoyl (18:1)  |

Now let’s effortlessly generate this complex multi-lipid environment using `packmol-memgen` with just one command in the terminal:

```bash
# 🎉 KEY OPTIONS:
# --lipids and --ratio -> mimicking mitochondrial inner membrane composition
# --pdb -> inserts protein into packed membrane - comment it for a pure membrane simulation
# --keepligs -> keeps ligands for parametrization (covered in another tutorial)
# --preoriented -> uses a pre-oriented protein structure (e.g., from OPM or PDBTM)
# --parametrize -> generates topology (prmtop) and coordinate files with AmberTools
#
packmol-memgen \
  --lipids POPC:POPE:TLCL2:POPI \
  --ratio 4:3:2:1 \
  --salt \
  --salt_c Na+ \
  --pdb your_protein_structure.pdb \
  --ffprot ff14SB \
  --fflip lipid21 \
  --ffwat tip3p \
  --distxy_fix 110 \
  --dist_wat 50 \
  --keepligs \
  --preoriented \
  --parametrize \
  --minimize
```

And this is a glimpse of the multi-lipid system with embedded ATP synthase — we’ll dive deeper into its construction in a separate tutorial:

<p align="center">
  <img src="https://github.com/TheVisualHub/VisualFactory/blob/a6832c514930f962b2357ef171f19dbe59fb7f72/assets/lipidforge_pre1.jpg?raw=true" alt="LipidForge Preview">
</p>

## ⏳ Coming soon:
A streamlined, robust, and fully scriptable tool for constructing complex lipid bilayers with precise control over composition, force fields, and spatial arrangement — perfect for large-scale molecular modeling projects.  
  
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
And get ready to pack your membranes! 📦✨
    
![Lipid Forge Logo](https://github.com/TheVisualHub/VisualFactory/blob/aa62d075e6a471ca173dad8fea53666b5e629b88/assets/lipidforge_logo2.jpeg?raw=true)
