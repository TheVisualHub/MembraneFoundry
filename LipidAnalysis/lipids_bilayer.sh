# looping of the trajectories to calculate lipids properties for the equilibration
#an array of the filer
dir=$(pwd)
input=${dir}/input
output=${dir}/output
init_trr=${dir}/input/xtc_AT1
temp_xtc=${dir}/temp_xtc
all_edr=${input}/edr
#all_pdb=${input}
ndx=${dir}/input/ndx/for_bilayer
reference=${input}/popc120new.tpr
ndx_file='popc120new.ndx'
# # to update ndx file #gmx make_ndx -f ../../AT1D.p_IA_100ns.equil.tpr -n indexAT1D.ndx -o indexAT1D_updated.ndx


#rm ${output}/lipids/*.*
rm -r ${output}/lipids/*
mkdir ${output}/lipids/

rm -r ${output}/plots/lipids/
mkdir ${output}/plots/lipids/


#keyword='apo'
name="popc120.tension3_"
skip='10'
last='150000'

for edr in ${all_edr}/*.edr; do
 #traj_name3=${traj##*/[0-9][0-9]_[0-9][0-9]_[0-9][0-9][0-9][0-9].}
 e_name3=$(basename "$edr")
 e_name="${e_name3/.edr/}"
 e_name="${e_name/${name}}"
 #e_name="${e_name/_3/}"
 echo "I am sending ${traj_name} to analysis"
 echo 14 0 | gmx energy -f ${edr} -skip ${skip} -s ${reference} -e ${last} -o ${output}/lipids/pressure_${e_name}
 echo 16 17 0 | gmx energy -f ${edr} -skip ${skip} -s ${reference} -e ${last} -o ${output}/lipids/box_${e_name}
 tail -n +26 ${output}/lipids/box_${e_name}* | awk '{print ($2 * $3) / 60}' > ${output}/lipids/area_${e_name}
 printf "\nFor ${e_name}\n" >> ${output}/lipids/surface.tension_total
 echo 41 0 | gmx energy -f ${edr} -s ${reference} -o ${output}/lipids/surface.tension_${e_name} >> ${output}/lipids/surface.tension_total
done


# pre-processing: remove pereodicity from the trajectories
for dcd in ${init_trr}/*.xtc; do
 dcd_name2=$(basename "$dcd")
 dcd_name3="${dcd_name2/${name}/}"
 dcd_name4="${dcd_name3/_1./}"
 dcd_name="${dcd_name4/xtc/}"
 # to remove PBC and reduce number of frames
 echo 0 0 | gmx trjconv -f ${dcd} -s ${reference} -pbc mol -skip ${skip} -e ${last} -ur compact  -o ${temp_xtc}/temp1.${dcd_name}.xtc 
 #echo 0 0 | gmx trjconv -f ${temp_xtc}/temp1.${dcd_name}.xtc -s ${reference} -pbc nojump -o ${temp_xtc}/temp2.${dcd_name}.xtc
 echo 2 0 | gmx trjconv -f ${temp_xtc}/temp1.${dcd_name}.xtc -s ${reference} -center -o ${temp_xtc}/${dcd_name}.xtc
 #mdconvert -o ${temp_xtc}/dcd/${dcd_name}.dcd -s 10 ${temp_xtc}/${dcd_name}.xtc
 rm ${temp_xtc}/temp*.xtc
done


for traj in ${temp_xtc}/*.xtc; do
 #traj_name3=${traj##*/[0-9][0-9]_[0-9][0-9]_[0-9][0-9][0-9][0-9].}
 traj_name3=$(basename "$traj")
 traj_name="${traj_name3/.xtc/}"
 #traj_name="${traj_name/ss_charmm_tension_NPT_negative_bench_berendsen}"
 #traj_name="${traj_name/_2/}"
 echo "I am sending ${traj_name} to analysis"
 # save snapshot
 echo 0 | gmx trjconv -f ${traj} -s ${reference} -skip 75 -o ${output}/lipids/snapshot.${traj_name}.gro
 # make an analysis
 # !!! to add -n ${ndx}/${ndx_file}
 echo 2 | gmx sasa -f ${traj} -s ${reference} -o ${output}/lipids/sasa_${traj_name}
 echo 2 2 | gmx msd -f ${traj} -s ${reference} -lateral z -o ${output}/lipids/msd_lip_${traj_name} 
 echo 3 3 | gmx msd -f ${traj} -s ${reference} -lateral z -o ${output}/lipids/msd_wat_${traj_name} 
 #echo 17 17 | gmx msd -f ${traj} -s ${reference} -n ${ndx}/${ndx_file} -lateral z -o ${output}/lipids/msd_ions_${traj_name}
 echo 2 2 | gmx density -f ${traj} -s ${reference} -o ${output}/lipids/density_${traj_name}.lipids -center -d Z -symm  
 #echo 3 3 | gmx density -f ${traj} -s ${reference} -o ${output}/lipids/density_${traj_name}.water -center -d Z -symm
 #echo 4 4 | gmx density -f ${traj} -s ${reference} -o ${output}/lipids/density_${traj_name}.ion -center -d Z
 # To calculate order params add into the ndx file the following group:
 # for Charmm:
 # head + 1 tail of POPC lipids
 #2 & a C1| a C2| a C13| a C14| a C12| a C11| a C15| a N| a O11| a O12| a O13| a O14| a P
 # only 1 tail of POPC lipids
 #2 & a C1| a C2| a C11| a C12| a C13| a C14| a C15|
 # for Amber
 #resname POPC & a N | a P | a C1 | a C11 | a C12 | a C13 | a C14 | a C15 | a O11 | a O12 | a O13 | a O14 | a C2
 gmx order -f ${traj} -s ${reference} -n ${ndx}/popc_ord.ndx -d z -od ${output}/lipids/order_${traj_name} 
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
(cd "${output}/lipids" && exec gracebat sasa* -hdevice PNG -legend load -fixed 2560 2048 -printfile "${output}"/plots/lipids/sasa.${name}.tension.png -hardcopy)



# ploting 2
#(cd "${output}/lipids" && exec gracebat order*_sauf* order*_0.0005ps* -hdevice PNG -legend load -fixed 2560 2048 -printfile "${output}"/plots/lipids/lipids_order.weak.png -hardcopy)
#(cd "${output}/lipids" && exec gracebat msd_lip*_no_ss* msd_lip*_0.0005* -hdevice PNG -legend load -fixed 2560 2048 -printfile "${output}"/plots/lipids/msd_lipids.${name}_weak.png -hardcopy)
#(cd "${output}/lipids" && exec gracebat msd_ions*_no_ss* msd_ions*_0.0005* -hdevice PNG -legend load -fixed 2560 2048 -printfile "${output}"/plots/lipids/msd_ions.${name}_weak.png -hardcopy)
#(cd "${output}/lipids" && exec gracebat msd_wat*_no_ss* msd_wat*_0.0005* -hdevice PNG -legend load -fixed 2560 2048 -printfile "${output}"/plots/lipids/msd_water.${name}_weak.png -hardcopy)
#(cd "${output}/lipids" && exec gracebat density*_no_ss* density*_0.0005* -hdevice PNG -legend load -fixed 2560 2048 -printfile "${output}"/plots/lipids/density.${name}_weak.png -hardcopy)
#(cd "${output}/lipids" && exec gracebat sasa*_no_ss* sasa*_0.0005* -hdevice PNG -legend load -fixed 2560 2048 -printfile "${output}"/plots/lipids/sasa.${name}_weak.png -hardcopy)

#remove temporary files
rm ${dir}/order* ${dir}/#*
