#!/bin/bash

dir=${1%/*}

echo $dir
echo $1
echo $2
pwd

obabel "$1" --gen3d -oxyz -O "$dir/$2.xyz" -m -h --minimize --ff MMFF94 --steps 10000 --sd --verbose

cd "$dir"
echo "starting .inp generation"
pwd

for input in *.xyz
do
	orcafile="$(echo $input | sed 's/\.xyz//').inp"
	echo '! B3LYP OPT def2-SVP NormalPrint Grid4  NormalSCF PAL2' >> "$orcafile"
	echo $'%scf\n     MaxIter 125\n     CNVDIIS 1\n     CNVSOSCF 1\nend\n' >> "$orcafile"
	echo '* xyz 0 1' >> "$orcafile"
	tail -n+3 $input | while IFS= read -r line
	do
		echo "   $line" >> "$orcafile"
	done
	echo "*" >> "$orcafile"
	rm $input
done
