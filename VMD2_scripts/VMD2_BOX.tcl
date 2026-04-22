##############################################################################
#  check_pbc.tcl — PBC padding analyser for VMD 2
#  Usage : source check_pbc.tcl
#          check_pbc          ;# uses top molecule, 10 Å target padding
#          check_pbc 0 12.0   ;# molid 0, 12 Å target padding
##############################################################################

proc check_pbc { {molid top} {target_pad 10.0} } {

    # ── resolve molid ────────────────────────────────────────────────────────
    if { $molid eq "top" } { set molid [molinfo top] }
    set nframes [molinfo $molid get numframes]
    if { $nframes == 0 } { puts "  [!] No frames loaded."; return }

    set sel [atomselect $molid all]

    # ── read current PBC (frame 0) ────────────────────────────────────────────
    set pbc_now [molinfo $molid get {a b c alpha beta gamma}]
    lassign $pbc_now cur_a cur_b cur_c cur_al cur_be cur_ga

    # ── scan all frames → maximum molecular extent ────────────────────────────
    set max_dx 0; set max_dy 0; set max_dz 0

    for { set f 0 } { $f < $nframes } { incr f } {
        $sel frame $f
        $sel update
        lassign [measure minmax $sel] lo hi
        lassign $lo xlo ylo zlo
        lassign $hi xhi yhi zhi
        set dx [expr { $xhi - $xlo }]
        set dy [expr { $yhi - $ylo }]
        set dz [expr { $zhi - $zlo }]
        if { $dx > $max_dx } { set max_dx $dx }
        if { $dy > $max_dy } { set max_dy $dy }
        if { $dz > $max_dz } { set max_dz $dz }
    }
    $sel delete

    # ── optimal box = max extent + 2 × target padding ─────────────────────────
    set opt_a [expr { $max_dx + 2.0 * $target_pad }]
    set opt_b [expr { $max_dy + 2.0 * $target_pad }]
    set opt_c [expr { $max_dz + 2.0 * $target_pad }]

    # ── compute actual padding in current box ─────────────────────────────────
    set pad_a [expr { ( $cur_a - $max_dx ) / 2.0 }]
    set pad_b [expr { ( $cur_b - $max_dy ) / 2.0 }]
    set pad_c [expr { ( $cur_c - $max_dz ) / 2.0 }]

    # ── tolerance: within 0.5 Å of target is "optimal" ───────────────────────
    set tol 0.5
    proc pad_status { pad tgt tol } {
        if   { $pad < 0              } { return "OVERLAP  ⚠" }
        if   { $pad < $tgt - $tol    } { return "TOO SMALL ↑" }
        if   { $pad > $tgt + $tol    } { return "TOO LARGE ↓" }
        return "OK  ✓"
    }

    set sa [pad_status $pad_a $target_pad $tol]
    set sb [pad_status $pad_b $target_pad $tol]
    set sc [pad_status $pad_c $target_pad $tol]
    set all_ok [expr { $sa eq "OK  ✓" && $sb eq "OK  ✓" && $sc eq "OK  ✓" }]

    # ── pretty report ─────────────────────────────────────────────────────────
    set sep "─────────────────────────────────────────────────────────"
    puts ""
    puts "  PBC PADDING REPORT  •  mol $molid  •  $nframes frame(s)"
    puts "  $sep"
    puts [format "  %-12s  %8s  %8s  %8s" "" "  X / a" "  Y / b" "  Z / c"]
    puts "  $sep"
    puts [format "  %-12s  %8.2f  %8.2f  %8.2f  Å" \
          "Extent (max)"  $max_dx  $max_dy  $max_dz]
    puts [format "  %-12s  %8.2f  %8.2f  %8.2f  Å" \
          "Current box"   $cur_a   $cur_b   $cur_c]
    puts [format "  %-12s  %8.2f  %8.2f  %8.2f  Å" \
          "Optimal box"   $opt_a   $opt_b   $opt_c]
    puts [format "  %-12s  %8.2f  %8.2f  %8.2f  Å  (target ≥ %.1f)" \
          "Padding now"   $pad_a   $pad_b   $pad_c  $target_pad]
    puts "  $sep"
    puts [format "  %-12s  %11s  %8s  %8s" "Status" $sa $sb $sc]
    puts "  $sep"

    if { $all_ok } {
        puts "  ✓  All axes are within tolerance. No changes needed."
    } else {
        puts "  Suggested fix — run in VMD console:"
        puts ""
        puts [format "    pbc set {%.2f %.2f %.2f} -all" $opt_a $opt_b $opt_c]
        puts ""
        puts "  Or regenerate your water box with these dimensions:"
        puts [format "    packmol / tleap / gmx solvate  →  %.2f × %.2f × %.2f Å" \
              $opt_a $opt_b $opt_c]
    }
    puts "  $sep"
    puts ""

    # ── return dict for scripting ─────────────────────────────────────────────
    return [dict create \
        cur_box  [list $cur_a $cur_b $cur_c] \
        opt_box  [list $opt_a $opt_b $opt_c] \
        padding  [list $pad_a $pad_b $pad_c] \
        status   [list $sa $sb $sc] \
        optimal  $all_ok]
}

# ── auto-run if a molecule is already loaded ──────────────────────────────────
if { [llength [molinfo list]] > 0 } {
    check_pbc
} else {
    puts "  check_pbc.tcl loaded. Call:  check_pbc \[molid\] \[target_padding_Å\]"
}
