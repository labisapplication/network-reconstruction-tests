#!/usr/bin/bash
set -e

for i in data/*.ready; do
  Rscript main.R "$i"
done

for i in results/*; do
  java -jar gnw/gnw-3.1.2b.jar \
    --evaluate \
    --goldstandard data/InSilicoSize10-Yeast1_goldstandard_signed.tsv \
    --prediction "$i"
done
