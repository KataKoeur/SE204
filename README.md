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

Wishbone Classique
Gestion de la lecture de la memoire. Il n'est pas nécessaire d'utiliser une machine à état.
Gestion de l'écriture avec sel.
Gestion asynchrone de ack avec un cylce de retard pour la validation de la lecture.
Gestion synchrone de la lecture et de l'écriture.

La simulation a enfin fonctionné ! L'erreur se trouvait finalement dans la gestion maladroite de l'ack.
Suite à la synthétisation, j'obtiens les performances suivantes:

	LUTs = 6
	Freq = 1088.139 MHz
	Temps total pour les séquences en mode wishbone classic = 9873800

Wishbone Burst
Ajout des conditions du signal CTI: 000 = mode classique, 010 = début mode burst et 111 = fin mode burst
Ajout d'un compteur d'adresses: incrémente +4 tous les coups d'horloges
Blockage du ACK à 1 lors du mode rafale.
Abandon du bloc gestion compteur d'adresse pour faire ce calcule directement dans le bloc lecture.
Abandon des équations booléennes pour un enchainement de condition if en cascade dans le bloc lecture.
La simulation a enfin aboutie !!!
Après quelques modification, le code à réussi à synthétiser, cela implique que j'ai re veérifier la simulation après avec succès.
Voici les résultas obtenues:

	LUTs = 95
	Freq = 400.000 Mhz
	Temps total pour les séquences en mode registered feedback = 6504410

Les performances ont baissées entre le mode classique et le mode rafale.
Le projet du bus Wishbone est terminé !!!

# Affichage Vidéo (pour fin P1)

L'objectif de ce microprojet est de bâtir une architecture de "carte graphique", pour affichage de vidéo sur la maquette FPGA DE1-SoC. Le travail consistera, partant d'une "page blanche" à construire pas à pas un environnement complet de simulation et de synthèse permettant de vérifier chaque étape du travail:

	Les contraintes liées à l'implantation sur du matériel "Réel" seront traitées tout au long du projet.
	Les étudiants disposerons de briques de base (contrôleur de mémoire, générateur vidéo (logiciel),...)
	Les étudiants disposerons des documentations techniques (carte DE1-SoC, mémoire SDRAM, paramètres VIDEO,...)
	Les échanges entre blocs internes seront basées sur le protocole WishBone

Le système sera composé des éléments suivants :

	Un contrôleur  VIDEO  permettant d'afficher une image sur un écran VGA.
	Une SDRAM servant de mémoire d'image, lue en permanence par le contrôleur video.
	Le HPS (pour Hard Processor System), un double processeur ARM Cortex A9 intégré dans le FPGA
	Un décodeur vidéo logiciel, fonctionnant sur le HPS et écrivant les images dans la SDRAM à travers le FPGA.
	Un arbitre permettant de partager l'accès à la SDRAM entre le contrôleur vidéo et  le décodeur vidéo. 

## Etape 1 : Squelette

Module fpga avec 2 CLK, 2 switch, 1 reset et 4 LED
Le testbench permet de tout tester automatiquement. Le module fpga à passé les testes avec succes.
La synthès compile sans erreur mais releve plusieur Warning : Warning (18236): Number of processors has not been specified which may cause overloading on shared machines.  Set the global assignment NUM_PARALLEL_PROCESSORS in your QSF to an appropriate value for best performance.
Il ne sont néamoins pas important.
Le test sur maquette est un succès. Tout réagis comme il faut.
Etape 1 terminée

## Etape 2 : Controleur vidéo VGA
Tout fonctionne sans problème sur la carte fpga. 
Seul la partie où l'on doit afficher en parallele de la simulation les images généré n'a pas aboutie. 
Etape 2 terminée 

## Etape 3 : Controleur de SDRAM
