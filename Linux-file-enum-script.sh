#!/bin/bash

# Fonction pour générer un nom de fichier unique
generate_unique_filename() {
    base_name="$1"
    ext="$2"
    i=0
    
    # Si le fichier existe déjà, ajouter un numéro entre parenthèses
    if [[ -f "${base_name}.${ext}" ]]; then
        while [[ -f "${base_name}(${i}).${ext}" ]]; do
            ((i++))
        done
        echo "${base_name}(${i}).${ext}"
    else
        echo "${base_name}.${ext}"
    fi
}

# Affichage de bienvenue
printf "Welcome to the enumeration script \n"
printf "------------------------------------------------------------------------ \n"
echo "Select what type of file do you want to enumerate: \n"

# Liste des extensions à rechercher
declare -A extensions
extensions["Data_base_file"]="*.db *.sqlite *.sqlite3 *.db3 *.sdb *.mdb *.accdb *.frm *.ibd *.myd *.myi *.dbf *.dmp *.mdf *.ndf *.ldf *.sql *.backup *.bson *.cql *.ldb *.dbf *.db *.gdb *.fdb *.dat *.pdb *.cdb *.nsf *.h2.db"
extensions["Data_conf_file"]="*.sql *.cnf *.ini *.yml *.yaml *.env"
extensions["Config_import_file"]="*.php *.json *.xml *.csv"
extensions["Virtual_machine_file"]="*.vmdk *.vdi *.ova *.ovf *.qcow2"
extensions["Active_Directory_file"]="*.ldf *.csv *.xml *.ps1 *.admx *.adml"
extensions["mail_files"]="*.eml *.msg *.pst *.ost *.mbox *.dbx *.maildir *.msgstore"
extensions["mail_conf_import_file"]="*.ics *.vcf *.xml *.csv"
extensions["archive_file"]="*.zip *.tar *.gzip *.gz"

# Obtenir le nom de l'hôte
hostname=$(hostname)

# Affichage du menu et sélection
select choix in "Data_base_file" "Data_conf_file" "Config_import_file" "Virtual_machine_file" "Active_Directory_file" "mail_files" "mail_conf_import_file" "archive_file" "Quitter"; do
    case $choix in
        "Data_base_file"|"Data_conf_file"|"Config_import_file"|"Virtual_machine_file"|"Active_Directory_file"|"mail_files"|"mail_conf_import_file"|"archive_file")
            # Nom de base pour le fichier de sortie (avec extension choisie et hostname)
            base_filename="Resultat_${choix}_Linux_$hostname"
            
            # Génération d'un nom de fichier unique
            outputFile=$(generate_unique_filename "$base_filename" "txt")
            
            echo "Recherche des fichiers ${extensions[$choix]}..."
            echo "Les résultats seront enregistrés dans $outputFile."
            
            # Recherche des fichiers et enregistrement des résultats
            for ext in ${extensions[$choix]}; do
                echo "Recherche pour l'extension : $ext"
                find / -type f -name "$ext" 2>/dev/null >> $outputFile
            done

            echo "Recherche terminée pour $choix. Les résultats sont dans $outputFile."
            ;;
        "Quitter")
            echo "Fermeture du script."
            break
            ;;
        *)
            echo "Option invalide, veuillez réessayer."
            ;;
    esac
done
