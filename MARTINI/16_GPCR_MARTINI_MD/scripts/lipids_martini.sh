# looping of the trajectories to calculate lipids properties for the equilibration
#an array of the filer
dir=$(pwd)
input=${dir}/input
output=${dir}/output
all_trr=${input}/xtc_martini
all_edr=${input}/edr_martini
all_pdb=${input}
ndx=${dir}/input/ndx/for_martini
#name of the systems
name='AT1_MARTINI'
top='AT1R_MARTINI2'
ndx_file='AT1_MARTINI'


#rm ${output}/lipids/*.*
rm -r ${output}/lipids/*
mkdir ${output}/lipids/

rm -r ${output}/plots/lipids/
mkdir ${output}/plots/lipids/


keyword='apo'
for edr in ${all_edr}/*.edr; do
 #traj_name3=${traj##*/[0-9][0-9]_[0-9][0-9]_[0-9][0-9][0-9][0-9].}
 e_name3=$(basename "$edr")
 e_name="${e_name3/.edr/}"
 e_name="${e_name/AT1R_16.martini.POPC_stretch_bench_tension}"
 #e_name="${e_name/_2/}"
 #echo "I am sending ${traj_name} to analysis"
 gmx energy -f ${edr} -s ${all_pdb}/${top}.tpr -o ${output}/lipids/box_${e_name} < ${ndx}/enterBox_MARTINI  
 tail -n +26 ${output}/lipids/box_${e_name}* | awk '{print ($2 * $3) / 2400}' > ${output}/lipids/area_${e_name}
 printf "\nFor ${e_name}\n" >> ${output}/lipids/surface.tension_total
 gmx energy -f ${edr} -s ${all_pdb}/${top}.tpr -o ${output}/lipids/surface.tension_${e_name} >> ${output}/lipids/surface.tension_total < ${ndx}/enterSurf_martini
done



for traj in ${all_trr}/*.xtc; do
 #traj_name3=${traj##*/[0-9][0-9]_[0-9][0-9]_[0-9][0-9][0-9][0-9].}
 traj_name3=$(basename "$traj")
 traj_name="${traj_name3/.xtc/}"
 traj_name="${traj_name/AT1R_16.martini.POPC_stretch_bench_tension}"
 #traj_name="${traj_name/_2/}"
 echo "I am sending ${traj_name} to analysis"
 #remove a pereodicity from the trajectory for WHOLE system
 #gmx trjconv -f ${traj} -s ${all_pdb}/${top}.tpr -pbc mol -ur compact -o ${output}/xtc_proc/${traj_name}.nopbc.xtc < $ndx/enterPCA2
  #remove a pereodicity from the trajectory for a protein only
 #gmx trjconv -f ${traj} -s ${all_pdb}/${top}.tpr -pbc mol -ur compact -o ${output}/xtc_proc/${traj_name}.nopbc.xtc -n ${ndx}/${ndx_file}.ndx < $ndx/enterMARTINI
 #gmx editconf -f ${pdb_all}/*${traj_name}.pdb -o ${output}/xtc_proc/${traj_name}.pdb
 # make an analysis
 #gmx sasa -f ${traj} -s ${all_pdb}/${top}.tpr -n ${ndx}/${ndx_file}.ndx -o ${output}/lipids/sasa_${traj_name} < ${ndx}/enterLipids 
 #gmx msd -f ${traj} -s ${all_pdb}/${top}.tpr -lateral z -o ${output}/lipids/msd_lip_${traj_name} < ${ndx}/enterLipids
 #gmx msd -f ${traj} -s ${all_pdb}/${top}.tpr -n ${ndx}/${ndx_file}.ndx -lateral z -o ${output}/lipids/msd_wat_${traj_name} < ${ndx}/enterWat
 #gmx msd -f ${traj} -s ${all_pdb}/${top}.tpr -lateral z -o ${output}/lipids/msd_ions_${traj_name} < ${ndx}/enterIon
 #gmx density -f ${traj} -s ${all_pdb}/${top}.tpr -o ${output}/lipids/density_${traj_name}.lipids -center -d Z -symm < ${ndx}/enterLipids  
 #gmx density -f ${traj} -s ${all_pdb}/${top}.tpr -o ${output}/lipids/density_${traj_name}.water -center -d Z -symm < ${ndx}/enterWat 
 #gmx density -f ${traj} -s ${all_pdb}/${top}.tpr -o ${output}/lipids/density_${traj_name}.ion -center -d Z < ${ndx}/enterIon
 #gmx order -f ${traj} -s ${all_pdb}/${top}.tpr -n ${ndx}/popc_charmm36_order.ndx -d z -od ${output}/lipids/order_${traj_name} #< ${ndx}/enterLipids
done

for xvg in ${output}/lipids/*.xvg; do
 xvg_name=$(basename "$xvg")
 xvg_name2="${xvg_name/.xvg/}"
 mv ${xvg} ${output}/lipids/${xvg_name2}
done


# ploting area-per-lipids
(cd "${output}/lipids" && exec gracebat area* -hdevice PNG -legend load -fixed 2560 2048 -printfile "${output}"/plots/lipids/area_per_lipids.${name}.png -hardcopy)

# ploting 1
(cd "${output}/lipids" && exec gracebat order* -hdevice PNG -legend load -fixed 2560 2048 -printfile "${output}"/plots/lipids/lipids_order.${name}.png -hardcopy)
(cd "${output}/lipids" && exec gracebat msd_lip* -hdevice PNG -legend load -fixed 2560 2048 -printfile "${output}"/plots/lipids/msd_lipids.${name}.png -hardcopy)
(cd "${output}/lipids" && exec gracebat msd_ions* -hdevice PNG -legend load -fixed 2560 2048 -printfile "${output}"/plots/lipids/msd_ions.${name}.png -hardcopy)
(cd "${output}/lipids" && exec gracebat msd_wat* -hdevice PNG -legend load -fixed 2560 2048 -printfile "${output}"/plots/lipids/msd_water.${name}.png -hardcopy)
(cd "${output}/lipids" && exec gracebat density*.lipids -hdevice PNG -legend load -fixed 2560 2048 -printfile "${output}"/plots/lipids/density_lipids.${name}.png -hardcopy)
(cd "${output}/lipids" && exec gracebat density*.water -hdevice PNG -legend load -fixed 2560 2048 -printfile "${output}"/plots/lipids/density.${name}.water.png -hardcopy)
(cd "${output}/lipids" && exec gracebat density*.ion -hdevice PNG -legend load -fixed 2560 2048 -printfile "${output}"/plots/lipids/density_ions.${name}.png -hardcopy)
#(cd "${output}/lipids" && exec gracebat sasa* -hdevice PNG -legend load -fixed 2560 2048 -printfile "${output}"/plots/lipids/sasa.${name}.tension.png -hardcopy)



# ploting 2
#(cd "${output}/lipids" && exec gracebat order*_sauf* order*_0.0005ps* -hdevice PNG -legend load -fixed 2560 2048 -printfile "${output}"/plots/lipids/lipids_order.weak.png -hardcopy)
#(cd "${output}/lipids" && exec gracebat msd_lip*_no_ss* msd_lip*_0.0005* -hdevice PNG -legend load -fixed 2560 2048 -printfile "${output}"/plots/lipids/msd_lipids.${name}_weak.png -hardcopy)
#(cd "${output}/lipids" && exec gracebat msd_ions*_no_ss* msd_ions*_0.0005* -hdevice PNG -legend load -fixed 2560 2048 -printfile "${output}"/plots/lipids/msd_ions.${name}_weak.png -hardcopy)
#(cd "${output}/lipids" && exec gracebat msd_wat*_no_ss* msd_wat*_0.0005* -hdevice PNG -legend load -fixed 2560 2048 -printfile "${output}"/plots/lipids/msd_water.${name}_weak.png -hardcopy)
#(cd "${output}/lipids" && exec gracebat density*_no_ss* density*_0.0005* -hdevice PNG -legend load -fixed 2560 2048 -printfile "${output}"/plots/lipids/density.${name}_weak.png -hardcopy)
#(cd "${output}/lipids" && exec gracebat sasa*_no_ss* sasa*_0.0005* -hdevice PNG -legend load -fixed 2560 2048 -printfile "${output}"/plots/lipids/sasa.${name}_weak.png -hardcopy)
