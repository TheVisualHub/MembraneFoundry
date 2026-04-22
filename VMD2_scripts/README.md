## 🧭 Overview

`VMD2_BOX.tcl` is a lightweight Tcl script for **VMD2 (Visual Molecular Dynamics)** that evaluates whether your simulation box has sufficient padding around your molecule across all trajectory frames. After execution, the script scans your MD trajectory to:

- Determine the **maximum molecular extent** in X, Y, Z
- Compare it with the **current periodic box dimensions**
- Calculate the **actual padding**
- Recommend an **optimal box size**
- Provide clear status indicators and fix suggestions

---
## ⚡ Default usage:
Run the script without arguments (target padding = 10 Å) in the TCL console:
```tcl
source ./VMD2_BOX.tcl
check_pbc
```

## 👑 Custom execution:
Use these options for 12 Å desired padding and 0 mol id:
```tcl
check_pbc 0 12.0
```

## 📊 Example Output:
```text
PBC PADDING REPORT  •  mol 0  •  100 frame(s)
───────────────────────────────────────────────
              X / a    Y / b    Z / c
───────────────────────────────────────────────
Extent (max)   45.20    42.10    50.30  Å
Current box    60.00    60.00    60.00  Å
Optimal box    65.20    62.10    70.30  Å
Padding now     7.40     8.95     4.85  Å  (target ≥ 10.0)
───────────────────────────────────────────────
Status       TOO SMALL ↑  TOO SMALL ↑  TOO SMALL ↑
───────────────────────────────────────────────
```
