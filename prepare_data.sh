#!/usr/bin/bash
set -e

awk -v RS= '{print > ("data/dataset-" NR ".csv")}' "$1"

for i in data/dataset-*; do
  cut -f 2- "data/dataset-1.csv" "$i" > "$i.ready"
done

rm data/dataset-1.csv{,.ready}
