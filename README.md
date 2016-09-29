# SE204 Dépôt Git

Bienvenue sur le gitLab de Erwan CHERIAUX !

23/09/2016: ExoSim, simulation d'un compteur cadencé par une bascule.

07/10/2016: Filtre médian

	Module MCE:		Compare 2 nombres et les renvois triés 
	Module MCE-testbench: 	Test sur mille valeurs randoms le module MCE

La simulation sur ModelSim renvoie un message de confirmation du bon fonctionnement du module MCE.
IMPORTANT: Il faut compiler le fichier testbench.sv avant de réaliser la simulation.

Ajout d'un Makefile capable de synthétiser les modules et de renseigner l'optimalité du code.
La synthèse du module MCE indique 32 LUTs, ce qui est sous optimal ! Il faudrait avoir 24 LUTs 
tout au plus. Néanmoins, je ne vois pas comment améliorer le code du module MCE.
