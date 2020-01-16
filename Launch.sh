#!/bin/bash

help="0"
serv="0"
all="0"
trac="0"
dot="0"
list="0"
debug="0"

fichier="ip.txt"

while getopts "hxlatdf:s:" option
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

    l)
        list="1"
        ;;
    
    x)
        debug="1"
        ;;

    \?)
        exit 1
        ;;

    :)
        exit 1
        ;;

esac
done

echo " "
mkdir ./Traceroute

dos2unix "$fichier" &
dos2unix ./Dot.sh &
dos2unix ./Trace.sh &

chmod +x ./Dot.sh
chmod +x ./Trace.sh
echo " "

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

    launch -l
        donne la liste de site

    launch [-a] [-s google.fr] -x
        Va executer le programme en mode débug

    """

elif [ "$list" == "1" ]; then
    echo $(cat $fichier)

elif [ "$all" == "1" -a "$serv" == "1" ]; then
    echo -e "\nVous ne pouvez pas utiliser l'option -a et -s en même temps \n"

elif [ "$all" == "1" -o "$trace" == "1" -a "$dire" == "1" ]; then
    > except.txt
    chmod 764 except.txt

    for z in `seq 1 $(cat "$fichier" | wc -l)`; do
        if [ "$debug" == "0" ]; then
            addr=$(cat $fichier | tr "\n" " " | cut -d" " -f$z)
            if [ "$addr" != "" ];then
                sudo ./Trace.sh $addr
            fi
        else
            addr=$(cat $fichier | tr "\n" " " | cut -d" " -f$z)
            if [ "$addr" != "" ];then
                sudo bash -x ./Trace.sh $addr
            fi
        fi
    done

    sudo ./Dot.sh

elif [ "$serv" == "1" ]; then
    nslookup $serveur &
    test=$(echo $?)
    if ["$test" == "0" ]; then
        if [ "$debug" == "0" ]; then
            sudo ./Trace.sh $serveur
        else
            sudo bash -x ./Trace.sh $serveur
        fi
    else
        echo -e "\nPrenez un site valide \n"
    fi

elif [ "$trace" == "1" ]; then
    > except.txt
    chmod 764 except.txt

    for z in `seq 1 $(cat $fichier | wc -l)`; do
        if [ "$debug" == "0" ]; then
            addr=$(cat $fichier | tr "\n" " " | cut -d" " -f$z)
            if [ "$addr" != "" ];then
                sudo ./Trace.sh $addr
            fi
        else
            addr=$(cat $fichier | tr "\n" " " | cut -d" " -f$z)
            if [ "$addr" != "" ];then
                sudo bash -x ./Trace.sh $addr
            fi
        fi
    done

elif [ "$dot" == "1" ]; then
    sudo ./Dot.sh

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

    launch -l
        donne la liste de site

    launch [-a] [-s google.fr] -x
        Va executer le programme en mode débug

    """

fi
