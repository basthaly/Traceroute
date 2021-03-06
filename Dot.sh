#!/bin/bash

echo -e "\e[35m\nCréation du graph dot\n"

nbr=$(ls -l Traceroute | grep route | wc -l)

echo "digraph mon_graphe {" > Route.txt
for i in `seq 1 $nbr`; do
    var=$(ls Traceroute/ | tr '\n' ' ' | cut -d" " -f$i)
    echo "$(cat Traceroute/$var | tr '\n' '|' | sed -e "s/|/ -> /g" | sed -e "s/ -> $//g") [color= \"$(awk -v n=10 -v seed="$RANDOM" 'BEGIN { srand(seed); for (i=0; i<n; ++i) printf("%.4f\n", rand()) }' | tr "\n" " ")\"];" >> Route.txt
done

echo "$(cat except.txt)" >> Route.txt

echo "}" >> Route.txt

dot -Tpdf Route.txt -o Route.pdf
chmod 764 Route.pdf

echo -e "\e[35m\Graph dot créer\n"