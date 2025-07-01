#!/bin/bash

#
# This is a shell script called "full_contact"
# which performs analysis of protein-protein contacts
# Separate snapshots (pdb) extracted from MD trajectory are going to be analysed using several loop routine (see detailed description below).
# Find clash/contacts plugin of Headless-chimera (executed without gui) is used to calculate number of protein-protein overlaps observed in molecular dynamics
#

# set work-dir
home=$(pwd)

# specify a folder with several PDBs for the analysis
ref_folder="${home}"/pdb
# Name of the project
project="GPCR_oligomerization"

output=${home}/${project}
rm -r ${output}
mkdir  ${output}
mkdir  ${output}/temp

# today's date (to be provided for your science-boss) 
now=$(date +"%m_%d_%Y")

# Define the list of the separate chains, corresponded to separate monomers that are going to be analysed
# check your PDB files that should contain monomers (separate chains) with the same naming
#chain_array=('a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 'p');
chain_array=('A' 'B' 'C' 'D' 'E' 'F' 'G' 'H' 'I' 'J' 'K' 'L' 'M' 'N' 'O' 'P');
# set the overlap cutoff for contact calculations by UCSF Chimera
# !NB: use gui UCSF Chimera and single pdb file (where oligomerization patters have already been observed) to calibrate the cut-off
cut='-1.2'

# The 1st outside loop - make all calculations;
# assuming that "chimera_batch" is variable for headless chimera - check .bashsc file for variables;
# we loop each pdb and create for it input file that will be processed to headless Chimera in order to calculate number of protein-protein contacts;
# chimera's outputs will be post-processed using awk and perl to obtain a summary logs;
for pdb in ${ref_folder}/*.pdb; do
  pdb_title=$(basename "$pdb")
  pdb_title=${pdb_title/.pdb/}
  echo "I am going to make analysis of $pdb_title ..."
  sleep 1
  echo "System info: ${pdb_title} will be analyzed "${#chain_array[*]}" times"
  sleep 2
  mkdir  ${output}/${pdb_title}
  cd ${output}/${pdb_title}
# 1st sub-loop: calculate contacts with Chimera in batch mode
for i in "${chain_array[@]}"
do
  printf "findclash :.${i} test other overlapCutoff ${cut} intraMol false saveFile ./chain.${i}.log  log false" > "${output}/${pdb_title}/chimera_ch.${i}.cmd"
  chimera_batch ${ref_folder}/${pdb_title}.pdb "${output}/${pdb_title}/chimera_ch.${i}.cmd"
  rm chimera_ch.${i}.cmd
done

# 2st sub-loop: combine all of the outputs from the 1st sub-loop within the same log
# to obrain summary of protein-protein interactions
for i in ${output}/${pdb_title}/*.log; do 
i_tit=$(basename "$i")
i_tit=${i_tit/.log/}
printf "For ${i_tit} it has been detected " >> ${output}/detailed_${pdb_title}.log
sed -n '/^[0-9]/,$p'  $i; done >> ${output}/detailed_${pdb_title}.log
# rm old files
rm -r ${output}/${pdb_title}

#3rd sub loop: make a final reduced log with the TOTAL number of contacts
for log in ${output}/detailed_*.log; do 
log_tit=$(basename "$log")
log_tit=${log_tit/.log/}
log_tit=${log_tit/detailed_/}
#make reduced contact summary for each simulation
perl -ne '/For chain/g && /(\d+)/ && print && ($str.=$1.",") && ($sum+=$1); END{print "TOTAL=",join "+",(split/,/,$str);print "=$sum contacts\n",}' $log > ${output}/${log_tit}_Contacts.log
#make a contact summary to all simulations
printf "The total number of observed protein-protein contacts under the pressure of ${log_tit}: " >> ${output}/Total_Contacts.log
awk '/For chain.*detected.*contacts/{count+=$(NF-1)} END{print count}' $log >> ${output}/Total_Contacts.log
done

mkdir ${output}/temp
mv ${output}/detailed_*.log ${output}/temp
  cd -
done

# The 2nd outside loop - combine all outputds into a "scientific" log :-)
echo -e "The final output of the ${project}\n" >> ${output}/Summary_Final.log
for res in ${output}/*.log; do
res_tit=$(basename "$res")
res_tit=${res_tit/.log/}
echo -e "$res_tit\n";cat "$res";echo -e "";done >> ${output}/Summary_Final.log
# rm old files
mv ${output}/*bar*.log ${output}/temp
