using module ".\classes\skeleton.psm1"

##############################################################
########## SKELETON OF SCRIPTS ###############################
##############################################################

function create() {
    $file = [Skeleton]::new()
    Write-Host "new scripting init`n`n"

    $synopsis    = Read-Host "Synopsis"
    $description = Read-Host "Description"
    $file.Header = [Header]::new($synopsis, $description)

    $author = Read-Host "Auteur"
    $date = Read-Host "Date de creation"
    $created = if ([string]::IsNullOrEmpty($date)) { (Get-Date).ToString() } else { $date }
    $version = Read-Host "Version"
    $version = if ([string]::IsNullOrEmpty($version)) { "1.0" } else { $version }
    $links  = Read-Host "Liens"
    $misc = Read-Host "Divers"
    $file.Note = [Note]::new($author, $created, $version, $misc, $links)

    $name = Read-Host "Nom du fichier"
    $file.initScriptFile($name)
}

create
