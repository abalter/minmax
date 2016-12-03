#!/bin/bash

if [[ $1 == "help" ]]; then
    echo "timeminmax.sh medsize longsize ncols"
    exit
fi

medsize=$1
longsize=$2
ncols=$3

echo "medsize: $medsize"
echo "longsize: $longsize"
echo "ncols: $ncols"

###-------   Writing sample files   ------------###
echo "writing medsample.tsv"
time python -c "import numpy as np; a = np.random.randint(-1000, 1000, size=($medsize, $ncols)); np.savetxt('medsample.tsv', a, fmt='%d', delimiter='\t')"
echo "writing longsample.tsv"
time python -c "import numpy as np; a = np.random.randint(-1000, 1000, size=($longsize, $ncols)); np.savetxt('longsample.tsv', a, fmt='%d', delimiter='\t')"


###--------   Doing the timing trials   --------###
echo "MEDIUM SAMPLES"
echo "-------------"
echo "timing minmax.awk"
cmd="time for col in \$(seq 1 \$ncols); do echo \$col; awk -f minmax.awk \$col medsample.tsv; done"
echo $cmd
eval "$cmd"

echo "-------------"
echo "timing minmax.py"
cmd="time for col in \$(seq 1 \$ncols); do echo \$col; python minmax.py -c \$col -f medsample.tsv; done"
echo $cmd
eval "$cmd"

echo "LONG SAMPLES"
echo "-------------"
echo "timing minmax.awk"
cmd="time for col in \$(seq 1 \$ncols); do echo \$col; awk -f minmax.awk \$col longsample.tsv; done"
echo $cmd
eval "$cmd"

echo "timing minmax.py"
cmd="time for col in \$(seq 1 \$ncols); do echo \$col; python minmax.py -c \$col -f longsample.tsv; done"
echo $cmd
eval "$cmd"

