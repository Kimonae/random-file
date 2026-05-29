📘 FICHE TECHNIQUE — VERSION SYSADMIN 

(Documentation interne pour administrateurs / techniciens) 

🧩 Objectif du script 

Script batch permettant : 

de sélectionner un dossier source contenant des fichiers multimédias 

de gérer dynamiquement la liste des extensions autorisées 

de scanner automatiquement les extensions présentes 

d’effectuer un tirage aléatoire sécurisé d’un fichier 

d’exporter une copie du script avec les paramètres actuels 

d’intégrer des règles de sécurité pour éviter l’exécution de fichiers dangereux 

🏗️ Structure générale 

Le script repose sur : 

un menu interactif (set /p) 

des labels (:MENU, :CHG_DIR, :EXT_MENU, etc.) 

une configuration persistante réécrite dans le script via :SAVE_CONFIG 

un moteur de tirage aléatoire basé sur %random% 

un filtrage de sécurité via attrib, findstr et règles d’exclusion 

un export automatique du script (copy "%~f0") 

📁 Gestion du dossier source 

Fonction : :CHG_DIR 

Vérifie l’existence du chemin 

Met à jour SRC_DIR 

Sauvegarde la configuration dans le script 

🧩 Gestion des extensions 

Menu : :EXT_MENU Fonctions : 

Ajouter une extension (:ADD_EXT) 

Supprimer une extension (:DEL_EXT) 

Scanner automatiquement les extensions présentes dans le dossier (:SCAN_EXT) 

Mise à jour persistante via :SAVE_CONFIG 

Format : EXT_LIST=mp4;avi;mov 

🎲 Tirage aléatoire sécurisé 

Fonction : :RANDOM Le script : 

Parcourt récursivement le dossier source 

Filtre les fichiers selon les extensions autorisées 

Applique 5 règles de sécurité : 

Ignorer fichiers cachés (H) 

Ignorer fichiers système (S) 

Ignorer fichiers sans extension 

Ignorer extensions dangereuses (exe, bat, cmd, vbs, ps1, msi, scr) 

Ignorer dossiers sensibles Windows (Windows\, Program Files\, System32\, etc.) 

Stocke les fichiers valides dans un tableau 

Sélectionne un fichier aléatoire 

Ouvre le fichier via start "" "chemin" 

📤 Export du script 

Fonction : :EXPORT 

Copie le script actuel dans Scrp03_Export.bat 

Permet de distribuer une version figée avec les paramètres personnalisés 

💾 Persistance de la configuration 

Fonction : :SAVE_CONFIG 

Réécrit les lignes set "SRC_DIR=..." et set "EXT_LIST=..." dans le script lui‑même 

Permet de conserver les paramètres entre deux exécutions 

Utilise un fichier temporaire %~f0.tmp 

🔐 Sécurité & bonnes pratiques 

Le moteur de tirage exclut explicitement les fichiers exécutables 

Les dossiers système sont ignorés pour éviter les faux positifs 

Recommandé : exécuter dans un environnement utilisateur standard (pas admin) 

 

 

 
