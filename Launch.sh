#!/bin/bash

for z in `seq 1 $(cat ip.txt | wc -l)`; do
    echo "./Trace.sh $z"
done

echo $(./Dot.sh)
echo $(dot -Tpdf Route.txt -o Route.pdf)
chmod 764 Route.pdf