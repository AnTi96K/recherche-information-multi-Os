# Fonction pour générer un nom de fichier unique
function Generate-UniqueFilename {
    param (
        [string]$BaseName,
        [string]$Extension
    )
    
    $i = 0
    $Filename = "$BaseName.$Extension"
    
    while (Test-Path $Filename) {
        $Filename = "$BaseName($i).$Extension"
        $i++
    }
    
    return $Filename
}

# Affichage du menu
Write-Host "Welcome to the enumeration script"
Write-Host "------------------------------------------------------------------------"
Write-Host "Select what type of file you want to enumerate:"

# Liste des extensions à rechercher
$extensions = @{
    "Data_base_file" = "*.db, *.sqlite, *.sqlite3, *.db3, *.sdb, *.mdb, *.accdb, *.frm, *.ibd, *.myd, *.myi, *.dbf, *.dmp, *.mdf, *.ndf, *.ldf, *.sql, *.backup, *.bson, *.cql, *.ldb, *.gdb, *.fdb, *.dat, *.pdb, *.cdb, *.nsf, *.h2.db"
    "Data_conf_file" = "*.sql, *.cnf, *.ini, *.yml, *.yaml, *.env"
    "Config_import_file" = "*.php, *.json, *.xml, *.csv"
    "Virtual_machine_file" = "*.vmdk, *.vdi, *.ova, *.ovf, *.qcow2"
    "Active_Directory_file" = "*.ldf, *.csv, *.xml, *.ps1, *.admx, *.adml"
    "mail_files" = "*.eml, *.msg, *.pst, *.ost, *.mbox, *.dbx, *.maildir, *.msgstore"
    "mail_conf_import_file" = "*.ics, *.vcf, *.xml, *.csv"
    "archive_file" = "*.zip, *.tar, *.gzip, *.gz"
    "Key" = "*.rsa"
}

# Obtenir le nom de l'hôte
$hostname = $env:COMPUTERNAME

# Affichage du menu
$choices = $extensions.Keys + "Quitter"
$choice = $null

while ($choice -ne "Quitter") {
    # Affichage des options du menu
    for ($i = 0; $i -lt $choices.Count; $i++) {
        Write-Host "$($i+1)) $($choices[$i])"
    }

    # Sélection de l'utilisateur
    $selection = Read-Host "Entrez le numéro correspondant à votre choix"

    # Vérification de la sélection valide
    if ($selection -match '^\d+$' -and $selection -le $choices.Count) {
        $choice = $choices[$selection - 1]

        if ($choice -eq "Quitter") {
            Write-Host "Fermeture du script."
            break
        }

        # Obtenir les extensions à rechercher
        $fileExtensions = $extensions[$choice] -split ', '

        # Nom de base pour le fichier de sortie (avec extension choisie et hostname)
        $baseFilename = "Resultat_${choice}_$hostname"

        # Génération d'un nom de fichier unique
        $outputFile = Generate-UniqueFilename -BaseName $baseFilename -Extension "txt"

        Write-Host "Recherche des fichiers avec les extensions $fileExtensions..."
        Write-Host "Les résultats seront enregistrés dans $outputFile."

        # Recherche des fichiers et enregistrement des résultats
        foreach ($ext in $fileExtensions) {
            Write-Host "Recherche pour l'extension : $ext"
            Get-ChildItem -Path C:\ -Recurse -Include $ext -ErrorAction SilentlyContinue | 
            ForEach-Object { $_.FullName } >> $outputFile
        }

        Write-Host "Recherche terminée pour $choice. Les résultats sont dans $outputFile."
    } else {
        Write-Host "Option invalide, veuillez réessayer."
    }
}
