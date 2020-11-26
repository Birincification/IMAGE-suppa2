#!/bin/bash


SUPPA="python3 /home/software/SUPPA/suppa.py"

outDir=$1
pData=$2
GTF=$3
GTFNAME=`basename $GTF`

mkdir -p $outDir

$SUPPA generateEvents -i $GTF -o $outDir/SUPPA2/$GTFNAME -f ioi

##need to mute these 2 calls
$SUPPA psiPerIsoform -g $GTF -e $outDir/COUNTS/tpm.counts.0 -o $outDir/SUPPA2/c1 &> /dev/null
$SUPPA psiPerIsoform -g $GTF -e $outDir/COUNTS/tpm.counts.1 -o $outDir/SUPPA2/c2 &> /dev/null

$SUPPA diffSplice -m empirical --input $outDir/SUPPA2/$GTFNAME.ioi --psi $outDir/SUPPA2/c1_isoform.psi $outDir/SUPPA2/c2_isoform.psi \
    -e $outDir/COUNTS/tpm.counts.0 $outDir/COUNTS/tpm.counts.1 -pa -gc -c -o $outDir/SUPPA2/SUPPA.out


#cat $outDir/SUPPA2/SUPPA.out.dpsi.temp.0 | awk '{split($1,a,";"); print a[1]"\t"$2"\t"$3}' > $outDir/SUPPA2/test_suppa.out

cat $outDir/SUPPA2/SUPPA.out.dpsi | awk '{split($1,a,";"); print a[1]"\t"$2"\t"$3}' > $outDir/diff_splicing_outs/SUPPA.out

#mv $OUTDIR/SUPPA.out.dpsi $5
#rm -r $OUTDIR
