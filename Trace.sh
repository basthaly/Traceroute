#!/bin/bash

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
echo "$addr"

cd ./Traceroute

for i in `seq 1 9`
do
	if [ $(echo "$addr" | cut --byte=1) == "$i" ]
	then
	test=1
	fi
done

if [ $test = 0 ]
then
	addr=$(nslookup $addr | grep Address | cut -d$'\n' -f2 | awk '{print $2}')
fi

#Ici l addr est défini, il faut maintenant l exploiter

echo $addr
> $addr.route
chmod 764 $addr.route

# fichier de stockage de la requête vers $addr fait

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

while [ "$test" != $addr ]
do
	var=$(traceroute -q 1 -n -A -f $a -m $a $addr | awk '{print $2 " " $3}' | cut -d$'\n' -f2)
	test=$(echo $var | cut -d" " -f1)

	if [ "$var" = "* " ]; then

		for i in "${list[@]}"; do
			var=$(traceroute -q 1 -n -A -f $a -m $a $i $addr | awk '{print $2 " " $3}' | cut -d$'\n' -f2)
			test=$(echo "$var" | cut -d" " -f1)

			echo "$a : $var"
			if [ "$var" != "* " ]; then
				num=$(cat ../except.txt | wc -l)
				if [ $num = "0" ]; then
					b=0
					for z in "${list[@]}"; do
						if [ "$1" = "$i" ]; then
							echo $(echo $1 | sed -e 's/\"//g' | cut -d"." -f1)
							var2=$(ip_calc $var) 
							echo "\"$var $var2\" [style=filled fillcolor=\"""${colors[$b]}""\"];" >> ../except.txt
							break
						fi
						b=`expr $b + 1`
					done
				else
					test_var="False"
					for j in `seq 1 $num` ; do
						if [ "$(cat ../except.txt | tr "\n" "|" | cut -d"|" -f$j | cut -d" " -f1-2 | sed -e "s/\"//g")" = "$var" ] ; then
							test_var="True"
							break
						fi
					done
					if [ $test_var = "False" ]; then
						b=1
						for z in "${list[@]}"; do
							if [ "$1" = "$i" ]; then
								echo $(echo $1 | sed -e 's/\"//g' | cut -d"." -f1)
								var2=$(ip_calc $var) 
								echo "\"$var $var2\" [style=filled fillcolor=\"""${colors[$b]}""\"];" >> ../except.txt
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
		echo "$a : $var"
	fi
	if [ "$var" != "* " ]; then
		echo $(echo $1 | sed -e 's/\"//g' | cut -d"." -f1)
		var2=$(ip_calc $var)
		echo "\"$var $var2\"" >> $addr.route
	else
		if [ $a == "4" ]; then
			echo "\"No reply : $a\"" >> $addr.route
		else
			echo "\"No reply : $a ($addr)\"" >> $addr.route
		fi
	fi
	a=`expr $a + 1`
done

cd ..
