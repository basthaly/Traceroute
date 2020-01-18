# Traceroute

Le programme principal est launch.sh

Les 2 programmes secondaire son Dot.sh et Trace.sh

IMPORTANT : il faut peut être `chmod +x launch.sh` afin de pouvoir le lancer par la suite.
Le programme launch.sh dispose de sa propre aide, il suffit de lancer le programme sans argument ou avec l'argument -h

Les programmes Trace.sh et Dot.sh ne sont pas censés être lancer tout seul.

Le programme Trace.sh va lancer un Traceroute personnalisé et va créer un fichier $addr.route qui va contenir le chemin vers $addr

Le programme Dot.sh va créer un fichier Route.pdf à partir de tous les fichiers créer par Trace.sh
