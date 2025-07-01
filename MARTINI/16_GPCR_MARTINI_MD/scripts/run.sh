#!/bin/bash

# this script run MD simulation of GPCR system using Gromacs installed on local multi-CPU cluster:
# please adapt all pathways listed below !
# othervise it does not work :-)

# !! NB you have to change these pathways according to your system !!
SYSTEM="16_GPCR_MARTINI"
CASE="TUTO1"
HOME=$(pwd)
WORKDIR=${HOME}/${SYSTEM}


# !! NB you have to change these variables according to your version of Gromacs, MPI and number of used CPUs for MD run
PREP=grompp
DO=mpirun
PROG=mdrun_mpi
cpu=72


# We are performing equilibration and production run of the pre-minimized system;
# this is example sequence of the workflow, which can be customized;
cd $WORKDIR
$PREP -f ${HOME}/${SYSTEM}/mdp/equil.mdp -c ${WORKDIR}/system_start.gro -p ${WORKDIR}/topol.top -n ${WORKDIR}/index.ndx -o ${WORKDIR}/equil1_${CASE} -maxwarn 1
$DO -np ${cpu} $PROG -v -deffnm equil1_${CASE} -rdd 1.8

$PREP -f ${HOME}/${SYSTEM}/mdp/equil_long.mdp -c ${WORKDIR}/equil1_${CASE} -t ${WORKDIR}/equil1_${CASE} -p ${WORKDIR}/topol.top -n ${WORKDIR}/index.ndx -o ${WORKDIR}/equil2_${CASE} -maxwarn 1
$DO -np ${cpu} $PROG -v -deffnm equil2_${CASE} -rdd 1.8

$PREP -f ${HOME}/${SYSTEM}/mdp/equil_long2.mdp -c ${WORKDIR}/equil2_${CASE} -t ${WORKDIR}/equil2_${CASE} -p ${WORKDIR}/topol.top -n ${WORKDIR}/index.ndx -o ${WORKDIR}/equil3_${CASE} -maxwarn 2
$DO -np ${cpu} $PROG -v -deffnm equil3_${CASE} -rdd 1.8

$PREP -f ${HOME}/${SYSTEM}/mdp/equil_long3.mdp -c ${WORKDIR}/equil3_${CASE} -t ${WORKDIR}/equil3_${CASE} -p ${WORKDIR}/topol.top -n ${WORKDIR}/index.ndx -o ${WORKDIR}/equil4_${CASE} -maxwarn 2
$DO -np ${cpu} $PROG -v -deffnm equil4_${CASE} -rdd 1.8

$PREP -f ${HOME}/${SYSTEM}/mdp/equil_long3.mdp -c ${WORKDIR}/equil4_${CASE} -t ${WORKDIR}/equil4_${CASE} -p ${WORKDIR}/topol.top -n ${WORKDIR}/index.ndx -o ${WORKDIR}/equil5_${CASE} -maxwarn 2
$DO -np ${cpu} $PROG -v -deffnm equil5_${CASE} -rdd 1.8

$PREP -f ${HOME}/${SYSTEM}/mdp/equil_long3.mdp -c ${WORKDIR}/equil5_${CASE} -t ${WORKDIR}/equil5_${CASE} -p ${WORKDIR}/topol.top -n ${WORKDIR}/index.ndx -o ${WORKDIR}/equil6_${CASE} -maxwarn 2
$DO -np ${cpu} $PROG -v -deffnm equil6_${CASE} -rdd 1.8

$PREP -f ${HOME}/${SYSTEM}/mdp/dynamic.mdp -c ${WORKDIR}/equil6_${CASE} -t ${WORKDIR}/equil6_${CASE} -p ${WORKDIR}/topol.top -n ${WORKDIR}/index.ndx -o ${WORKDIR}/md_${CASE}_prod_5ms -maxwarn 2
$DO -np ${cpu} $PROG -v -deffnm md_${CASE}_prod_5ms -rdd 1.8

#$DO -np ${cpu} $PROG -s md_${CASE}_prod_5ms -cpi md_${CASE}_prod_5ms.cpt -deffnm md_${CASE}_reboot -rdd 1.8
#$DO -np ${cpu} $PROG -s md_${CASE}_reboot -cpi md_${CASE}_reboot.cpt -deffnm md_${CASE}_reboot_2 -rdd 1.8


exit
