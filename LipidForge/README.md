# 🧬 Welcome to the **Lipid Forge**

## 🎞️ Watch the video illustration of a multi-lipid system with the embedded visual receptor rhodopsin  
[![Watch the video](https://img.youtube.com/vi/_8Gq76UBun4/maxresdefault.jpg)](https://www.youtube.com/watch?v=_8Gq76UBun4)

## 🔨 Forge Your Own Membranes  
Step into the workshop: design, shape, and refine realistic lipid assemblies tailored to your research needs.

Whether you’re modeling asymmetric bilayers, mixing exotic lipids, or preparing systems for molecular dynamics — **Lipid Forge** gives you artisan-level control with scriptable reproducibility.

##🚀 Coming soon:
A streamlined, robust, and fully scriptable tool for constructing complex lipid bilayers with precise control over composition, force fields, and spatial arrangement — perfect for large-scale molecular modeling projects.

##🌱 Why?

Modern membrane simulations demand more than single-lipid bilayers.
Our tool bridges flexibility and reproducibility, empowering users to:

    Mix multiple lipid types in custom ratios

    Seamlessly integrate with AmberTools force fields & protocols

    Automate parameterization & minimization steps

    Reproduce realistic asymmetric or symmetric membranes effortlessly
  

## ⚙️ Example Crafting Recipe

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

⏳ Status

  ✨ Currently under active development
  📚 Alpha release, tutorials & notebooks coming soon!

🤝 Welcome to the Family

  I welcome feedback, testing, and new ideas!
