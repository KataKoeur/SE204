# SE204 Dépôt Git

Bienvenue sur le gitLab de Erwan CHERIAUX !

# ExoSim (pour le 23/09/2016)

Simulation d'un compteur cadencé par une bascule.

# Filtre médian (pour le 07/10/2016)

	Module MCE:		Compare 2 nombres et les renvoie triés 
	Module MCE-testbench: 	Test sur mille valeurs randoms le module MCE

La simulation sur ModelSim renvoie un message de confirmation du bon fonctionnement du module MCE.
IMPORTANT: Il faut compiler le fichier testbench.sv avant de réaliser la simulation.

Ajout d'un Makefile capable de synthétiser les modules et de renseigner l'optimalité du code.
La synthèse du module MCE indique bien 24 LUTs, ce qui est conforme à l'optimalité attendue.

	Module MED: 		Récupere n pixel et renvoie la médiane
    Module MED-testbench:   Test sur mille valeurs randoms le module MED

Le module MED est terminé et a passé la phase de simulation avec succes.
La synthétisation du module MED nous informe que le code utilise 25 LUTs ce qui me semble 
peu mais optimal. Le schéma RTL correspond à ce que l'on attend. Le slack vaut 16.254ns sur 20ns.

	Module MEDIAN:			Exploite le module MED via un algo adapté à 9 pixels
    Module MEDIAN-testbench:  	Test le module MEDIAN

Le module MEDIAN compile. La simulation est une réussite fulgurante.
Après quelques modifications dans le fichier MEDIAN.sv suite aux erreurs de la synthèse. 
J'obtiens les résultats suivants: LUTs = 51, registres = 14, slack = 16.227

La seconde simulation consistant à ajouter les cellules de la technologie utilisée ne fonctionne pas !
Le fichier MEDIAN.vo contient le code du fichier MEDIAN.sv adapté à la cible: Cyclone II.

    Module median_image_tb.sv: Test le module MEDIAN sur une image au format .HEX

Le filtrage de l'image de Bogart bruité est un succès !
Le projet du filtre médian est terminée !!!

# Bus Wishbone (pour le 14/10/2016)

Codage d'un contrôleur de mémoire suivant la norme Wishbone.

Gestion de la lecture de la memoire. Il n'est pas nécessaire d'utiliser une machine à état.
Gestion de l'écriture sans prendre en compte sel.
