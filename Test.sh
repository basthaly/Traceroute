#!/bin/bash

help="0"
serv="0"
all="0"
trac="0"
dot="0"

fichier="ip.txt"

while getopts "hatdf:s:" option
do
case $option in
    h)
        help="1"
        ;;

    s)
        serv="1"
        serveur=$OPTARG
        ;;
    
    f)
        fichier=$OPTARG
        ;;
    
    a)
        all="1"
        ;;

    t)
        trac="1"
        ;;

    d)
        dot="1"
        ;;

    \?)
        exit 1
        ;;

    :)
        exit 1
        ;;

esac
done

if [ "$help" == "1" ]; then
    echo """
Name :
    Launch : Script permettant d'utiliser Traceroute et d'en sortir un graphe dot.

Description :
    Le programme execute un Traceroute sous certaines condition afin d'essayer de faire répondre un maximum de serveur qui en tant normal ne répondrais pas forcément.
    Le programme peut générer à partir de cette manipulation de Traceroute générer un graph dot.

Exemple:
    launch -h
        Afficher l'aide ci contre

    launch -a
        Va executer l'entièreter du programme

    launch -t -d
        Va executer un traceroute et va en créer le graph à partir d'un ficher de site déja défini

    launch -t -d -f fichier
        va executer un traceroute et va en créer le graph à partir d'un fichier donnée
        Le fichier doit avoir un site par ligne
        '
        google.fr
        yahoo.com
        '

    launch -s google.fr
        va executer un traceroute sur le site en question

    """

elif [ "$all" == "1" -a "$serv" == "1" ]; then
    echo -e "\nVous ne pouvez pas utiliser l'option -a et -s en même temps \n"

elif [ "$all" == "1" -o "$trace" == "1" -a "$dire" == "1" ]; then
    > except.txt
    chmod 764 except.txt

    for z in `seq 1 $(cat $fichier | wc -l)`; do
    sudo ./Trace.sh $z
    done

    sudo ./Dot.sh
    dot -Tpdf Route.txt -o Route.pdf
    chmod 764 Route.pdf

elif [ "$serv" == "1" ]; then
    sudo ./Trace.sh $serveur

elif [ "$trace" == "1" ]; then
    > except.txt
    chmod 764 except.txt

    for z in `seq 1 $(cat $fichier | wc -l)`; do
    sudo ./Trace.sh $z
    done

elif [ "$dot" == "1" ]; then
    sudo ./Dot.sh
    dot -Tpdf Route.txt -o Route.pdf
    chmod 764 Route.pdf

else
    echo """
Name :
    Launch : Script permettant d'utiliser Traceroute et d'en sortir un graphe dot.

Description :
    Le programme execute un Traceroute sous certaines condition afin d'essayer de faire répondre un maximum de serveur qui en tant normal ne répondrais pas forcément.
    Le programme peut générer à partir de cette manipulation de Traceroute générer un graph dot.

Exemple:
    launch -h
        Afficher l'aide ci contre

    launch -a
        Va executer l'entièreter du programme

    launch -t -d
        Va executer un traceroute et va en créer le graph à partir d'un ficher de site déja défini

    launch -t -d -f fichier
        va executer un traceroute et va en créer le graph à partir d'un fichier donnée
        Le fichier doit avoir un site par ligne
        '
        google.fr
        yahoo.com
        '

    launch -s google.fr
        va executer un traceroute sur le site en question

    """

fi
