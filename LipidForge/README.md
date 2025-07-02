# Welcome to the **Lipid Forge** 🔥

## 🎞️ Click to watch a 4K animation of a multi-lipid membrane system in molecular dynamics.
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

Now let’s effortlessly generate this complex multi-lipid environment with just one command in Bash terminal:

```bash
packmol-memgen \
  --lipids POPC:POPE:TLCL2:POPI \       # Types of phospho-lipids to include
  --ratio 4:3:2:1 \                     # Lipid molar ratio - mimicking  mitochondrial inner membrane composition
  --salt \                              # Add salt to the system
  --salt_c Na+ \                        # Type of cation (e.g., Na+)
  --ffprot ff14SB \                     # Force field for proteins
  --fflip lipid21 \                      # Force field for lipids
  --ffwat tip3p \                        # Water model (e.g., TIP3P or SPC)
  --distxy_fix 110 \                    # XY box dimensions; controls total number of lipids
  --dist_wat 50 \                        # Z dimension (box height); controls number of water molecules
  --keepligs \                          # Keep ligands for parametrization (covered in tutorial)
  --preoriented \                       # Use a pre-oriented protein structure (e.g., from OPM or PDBTM)
  --parametrize \                       # Generate topology (prmtop) and coordinate files with AmberTools
  --minimize                            # Perform an initial energy minimization of the system
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
