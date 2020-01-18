#!/bin/bash


######################################################
##   Fonction qui permet de connaitre la "classe"   ##
######################################################

function ip_calc {
var=$(echo $1 | sed -e 's/\"//g' | cut -d"." -f1)

if [ $var -ge 0 -a $var -le 126 ]; then
    echo "/8"
elif [ $var -ge 128 -a $var -le 191 ]; then
    echo "/16"
elif [ $var -ge 192 -a $var -le 223 ]; then
    echo "/24"
else
    echo "/?"
fi
}

test=0
addr=$1
echo -e "\n\e[35m$addr : \c"

##################################################
##   Vérifie si c'est une addr ip ou linéaire   ##
##################################################

for i in `seq 1 9`
do
	if [ $(echo "$addr" | cut --byte=1) == "$i" ]
	then
	test=1
	fi
done

###########################################
##   Récupérer l'ip de l'addr linéaire   ##
###########################################

if [ $test = 0 ]
then
	addr=$(nslookup $addr | grep Address | cut -d$'\n' -f2 | awk '{print $2}')
fi

####################################
##   Création du fichier .route   ##
####################################

echo -e "\e[35m$addr"
> Traceroute/$addr.route
chmod 764 Traceroute/$addr.route

####################################
##   Création des listes utiles   ##
####################################

	list=(
		"-I"
		"-T -p 80"
		"-U -p 53"
		"-U -p 123"
		"-T -p 21"
		"-T -p 22"
		"-T -p 443"
		"-T -p 5060"
		"-U -p 5060"
		"-w 30"
	)

	colors=(
		"#d63031"
		"#0984e3"
		"#e84393"
		"#e17055"
		"#fdcb6e"
		"#6c5ce7"
		"#a29bfe"
		"#636e72"
		"#55efc4"
		"#ffeaa7"
	)

a=1

###########################################
##   Début du Traceroute  personnalisé   ##
###########################################

while [ "$test" != "$addr" ]
do
	var=$(traceroute -q 1 -n -A -f $a -m $a $addr | awk '{print $2 " " $3}' | cut -d$'\n' -f2)
	test=$(echo "$var" | cut -d" " -f1)

	if [ "$var" = "* " ]; then

		#Boucle dans la list de test
		for i in "${list[@]}"; do
			var=$(traceroute -q 1 -n -A -f $a -m $a $i $addr | awk '{print $2 " " $3}' | cut -d$'\n' -f2)
			test=$(echo "$var" | cut -d" " -f1)

			echo -e "\e[36m$a : $var"

			#Si $var différent de *, rentre dans cette boucle
			if [ "$var" != "* " ]; then
				num=$(cat "except.txt" | wc -l)
				#Si le fichier except.txt est vide
				if [ $num = "0" ]; then
					b=0
					for z in "${list[@]}"; do
						#Permet de comparer les lists afin d'appliquer une couleur sur le graph
						if [ "$z" = "$i" ]; then
							var2=$(ip_calc $var) 
							echo "\"$var $var2\" [style=filled fillcolor=\"""${colors[$b]}""\"];" >> except.txt
							break
						fi
						b=`expr $b + 1`
					done
				else
					test_var="False"
					#Regarde si une exception correspond déja à l'adresse et si ce n'est pas le cas, compare les lists afin d'appliquer une couleur sur le graph
					for j in `seq 1 $num` ; do
						if [ "$(cat except.txt | tr "\n" "|" | cut -d"|" -f$j | cut -d" " -f1-2 | sed -e "s/\"//g")" = "$var" ] ; then
							test_var="True"
							break
						fi
					done
					if [ $test_var = "False" ]; then
						b=1
						for z in "${list[@]}"; do
							#Permet de comparer les list afin d'appliquer une couleur sur le graph
							if [ "$z" = "$i" ]; then
								var2=$(ip_calc $var) 
								echo "\"$var $var2\" [style=filled fillcolor=\"""${colors[$b]}""\"];" >> except.txt
								break
							fi
							b=`expr $b + 1`
						done
					fi
				fi
				break
			fi

		done
	else
		echo -e "\e[36m$a : $var"
	fi
	#Si $var est différent de *, alors il écrit l'addresse dans le fichier qui lui correspond
	if [ "$var" != "* " ]; then
		var2=$(ip_calc $var)
		echo "\"$var $var2\"" >> Traceroute/$addr.route
	#Si $var est toujours égale à *, alors il écrit No reply dans le fichier qui lui correspond
	else
		#Le serveur 4 est souvent le même, on évite de dupliquer le serveur pour rien
		if [ $a == "4" ]; then
			echo "\"No reply : $a\"" >> Traceroute/$addr.route
		else
			echo "\"No reply : $a ($addr)\"" >> Traceroute/$addr.route
		fi
	fi
	a=`expr $a + 1`
done
