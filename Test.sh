#!/bin/bash

while getopts "hatdf:s:" option
do
    fichier="ip.txt"
    case $option in
        h)
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
            ;;

        s)
            ./Trace.sh $OPTARG
            shift $((OPTIND-1))
            ;;
        
        f)
            fichier=$OPTARG
            ;;
        
        a)
            #Création fichier d'exception
            > except.txt
            chmod 764 except.txt

            for z in `seq 1 $(cat $fichier | wc -l)`; do
                ./Trace.sh $z
            done

            ./Dot.sh
            dot -Tpdf Route.txt -o Route.pdf
            chmod 764 Route.pdf
            ;;

        t)
            for z in `seq 1 $(cat ip.txt | wc -l)`; do
                ./Trace.sh $z
            done
            ;;

        d)
            ./Dot.sh
            dot -Tpdf Route.txt -o Route.pdf
            chmod 764 Route.pdf
            ;;

        *) echo "Option $OPTNAME inconnue" ;;

    esac
done