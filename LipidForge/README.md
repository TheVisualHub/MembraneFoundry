# Welcome to the **Lipid Forge** 🔥

## 🎞️ Click to watch a high-quality animation of a multi-lipid membrane featuring the visual receptor rhodopsin.
[![Watch the video](https://img.youtube.com/vi/_8Gq76UBun4/maxresdefault.jpg)](https://www.youtube.com/watch?v=_8Gq76UBun4)

## 🔨 Forge Your Own Membranes  
Step into the lipid workshop: design and refine realistic multi-lipid systems tailored to your brilliant research. 💎

Whether you’re modeling muilti-lipid bilayers, mixing exotic lipids, or preparing membrane protein systems for molecular dynamics — **Lipid Forge** gives you artisan-level control with scriptable reproducibility.  

## 🚀 Coming soon:
A streamlined, robust, and fully scriptable tool for constructing complex lipid bilayers with precise control over composition, force fields, and spatial arrangement — perfect for large-scale molecular modeling projects.  

## ⚙️ Example Crafting Recipe of a Four-lipid Membrane  

```bash
packmol-memgen \
  --lipids DOPE:DOPG:DPPC:POPE \        # Types of lipids to include
  --ratio 3:3:3:1 \                     # Lipid molar ratio: e.g., 3 DOPE : 3 DOPG : 3 DPPC : 1 POPE
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

## ⏳ Status. 
  ✨ Currently under active development  
  📚 Betta release, tutorials coming soon!
  
## 📦 Built On  
  ✨ [Packmol-Memgen (AmberTools)](https://ambermd.org/AmberTools.php)
  
## 🧬 Install AmberTools with Conda

```bash
# Create and activate environment
conda create -n ambertools -c conda-forge ambertools
conda activate ambertools

# Test installation calling tleap or cpptraj in the Terminal
tleap -h
cpptraj -h
```
    
![Lipid Forge Logo](https://github.com/TheVisualHub/VisualFactory/blob/aa62d075e6a471ca173dad8fea53666b5e629b88/assets/lipidforge_logo2.jpeg?raw=true)
