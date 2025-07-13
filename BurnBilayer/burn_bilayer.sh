# In this example we perform molecular dynamics simulations with Gromacs of lipid bilayer at different temperatures. 
# All simulations are going to be performed in NPT conditions with Nose-Hoover thermostat and Parrinello-Rahman barostat on the typical model of the
# POPC membrane bilayer that has been pre-equilibrated during 100 ns at the same conditions;
# Here is a tutotial for lipid simulations in gromacs, which explains how to build and equilibrate the same system
# http://www.bevanlab.biochem.vt.edu/Pages/Personal/justin/gmx-tutorials/membrane_protein/index.html
# Anyway, you can quickly assembly biomembrane system using http://www.charmm-gui.org/
# here the methodological tutorial of the selection of barostat and thermostat: http://molsim.org/ru/methods/MD_basics_2
# After execution the script takes gro, ndx and topol top files (from ./ref/) as well as script file for gromacs (mdp)
# 
#
#!/bin/bash

home=$(pwd)
output_sys="${home}"/output
mkdir ${output_sys}

# folder with the system which is going to be replicated
# it is possible to add several system and change it within the replication loop of script
ref_folder="${home}"/ref


# set name of the project and remove previous iutput of the script
project="bilayer.burning"
rm -r "${output_sys}"/${project}
mkdir "${output_sys}"/${project}

root="${output_sys}"/${project}

#system info
now=$(date +"%m_%d_%Y") # today date, which may be added as the suffix
cpus='32' # number of cpus, which will be reserved for each simulation on the server
sim_time='1-10:30:00' # time limit of simulation: 1 day, 10 hours and 30 minutes

# Here we define range of the temperature, which will be used for each simulation
temp_array=('323' '350' '400' '450' '500'); # temprerature in K


# we take an input gro file with the gromacs topology and ndx file and prepare for it MDP files as well as run.pbs file
# this is begining of replication loop
for ref_md in ${ref_folder}/popc_bilayer; do
  ref_title=$(basename "$ref_md")
  echo "System ${ref_title} will be replicated "${#temp_array[*]}" times"
  sleep 2
  server=${output_sys}/${project}/simulations
  output="${server}"
  mkdir  ${root}
  mkdir ${server}
  cd ${server}
for i in "${temp_array[@]}"
do
   cp -r ${ref_md} ${output}/${project}_${i}K
   cd ${output}/${project}_${i}K
  # print mpd file for production run;
  printf "integrator              = md
dt                      = 0.002
nsteps                  = 25000000 ; 50ns test production run
nstlog                  = 5000
nstxout                 = 2500000
nstxout-compressed      = 5000
nstvout                 = 5000
nstfout                 = 5000
nstcalcenergy           = 100
nstenergy               = 5000
;
cutoff-scheme           = Verlet
nstlist                 = 20
rlist                   = 1.2
coulombtype             = pme
rcoulomb                = 1.2
vdwtype                 = Cut-off
vdw-modifier            = Force-switch
rvdw_switch             = 1.0
rvdw                    = 1.2
;
tcoupl                  = Nose-Hoover
tc_grps                 = MEMB   SOL_ION
tau_t                   = 2.0    2.0
ref_t                   = ${i} ${i}
;
pcoupl                  = Parrinello-Rahman
pcoupltype              = semiisotropic
tau_p                   = 5.0
compressibility         = 4.5e-5  4.5e-5
ref_p                   = 1.0     1.0
gen_vel                 = no
;
constraints             = h-bonds
constraint_algorithm    = LINCS
continuation            = yes
;
nstcomm                 = 100
comm_mode               = linear
comm_grps               = MEMB   SOL_ION
;
refcoord_scaling        = com
; Deformation is off
; Deform = 0 0 0 0 0 0" > "${output}/${project}_${i}K/production_${i}K.mdp"

   # print script file to submit job on Q server
   # !!should be adapted for specific server
   printf "#PBS -N ${ref_title}_${i}.dynamics
#PBS -l nodes=1:ppn=${cpus}           #1 node, 32 cpus
#PBS -q day
#PBS -V

# run production run for 50 ns at ${i}K
gmx grompp -f production_${i}K.mdp -o ${project}_${i}K_0.tpr -c System.gro -t System.cpt -n System.ndx -p System.top -maxwarn -1
mpirun -np \${NB_TASKS} mdrun_mpi -v -deffnm ${project}_${i}K_0" > "${output}/${project}_${i}K/run.pbs"

done

cd -
done

# print submit.sh script to run all jobs in parallel on multi-CPU server

# this script will submit all md jobs in parallel
{
  ## print the header, and substitute our own value for HOME
  printf '#!/bin/bash\n'
  printf "cpus='${cpus}'\n"
  printf "time='${sim_time}'\n"
  ## EVERYTHING BELOW HERE UNTIL THE EOF IS LITERAL
  cat <<'EOF'
output=$(pwd)/simulations
run_file=run.pbs

#run GROMACS for each simulation
for sim in "${output}"/* ; do
 if [[ -d $sim ]]; then
  simulation=$(basename "${sim}")
  cd "${sim}"
  chmod +x "${sim}"/${run_file}
  sbatch -n ${cpus} --time=${time} ompi  "${sim}"/${run_file}
  echo "${simulation} has been submitted!"
  cd -
 fi
done
EOF
} > "${root}/submitter.sh"

chmod +x "${root}"/*.sh
# upload simulations on server with your login (should be adapted!)
#scp -r "${root}" login@server
