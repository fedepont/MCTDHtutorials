#!/bin/bash
#
#  Output file 
#$ -o output1.log
#
#  Manda un mail si pasa algo con el proceso
##$ -m eas -M fede.pont@gmail.com
#----------------------------------------------------------------
#$ -cwd
# Set desired checkpoint scheme
#$ -ckpt dmtcp
# Set openmp como entorno paralelo y pide 4 cores.
##$ -pe smp 4
#$ -v OMP_NUM_THREADS={$NSLOTS}
# Pide memoria
#$ -l mem_free=1.0G
# Pide este nodo
##$ -q long@compute-0-18.local
#Excluye este nodo
##$ -l h=!compute-0-12&!compute-0-23&!compute-0-20
#Para cambiar el valor de las variables
##$ -v DMTCP_SIGCKPT=31
#---------------------------------------------------------------
#   put here your executable
#

#export DMTCP_SIGCKPT=31
export OMP_NUM_THREADS=$NSLOTS # number of CPU cores to use
echo 'OMP_NUM_THREADS :' $OMP_NUM_THREADS
export MKL_NUM_THREADS=$NSLOTS
export OMP_SCHEDULE="dynamic,128"  # threading schedule
                          # (consider other schedules as well)

export OMP_STACKSIZE="512M"       # stack size per thread
                          # (you might need to increase this)

                        
# Para controlar el tamaño de los core files creados.
#ulimit -c 0

mctdh86 -w -mnd -p distR 2.0647,au NeHeplus_inwf_relaxed.inp
#----------------------------------------------------------------





