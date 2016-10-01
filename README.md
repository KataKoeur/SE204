# SE204 Dépôt Git

Bienvenue sur le gitLab de Erwan CHERIAUX !

23/09/2016: ExoSim, simulation d'un compteur cadencé par une bascule.

07/10/2016: Filtre médian

	Module MCE:		Compare 2 nombres et les renvoie triés 
	Module MCE-testbench: 	Test sur mille valeurs randoms le module MCE

La simulation sur ModelSim renvoie un message de confirmation du bon fonctionnement du module MCE.
IMPORTANT: Il faut compiler le fichier testbench.sv avant de réaliser la simulation.

Ajout d'un Makefile capable de synthétiser les modules et de renseigner l'optimalité du code.
La synthèse du module MCE indique bien 24 LUTs, ce qui est conforme à l'optimalité attendu.

	Module MED: 		Récupere n pixel et renvoie la médiane
        Module MED-testbench:   Test sur mille valeurs randoms le module MED

Le module MED est terminé et a passé la phase de simulation avec succes.
La synthétisation du module MED nous informe que le code utilise 25 LUTs ce qui me semble 
peu mais optimale. Le schéma RTL correspond à ce que l'on attend. Le slack vaut 16.254ns sur 20ns.

	Module MEDIAN:		Exploite le module MED via un algo adapté à 9 pixels

Le module MEDIAN compile, il faut maintenant le simuler pour verifier son bon fonctionnement
