class Header {
    [string]$Synopsis
    [string]$Description

    Header([string]$synopsis, [string]$description) {
        $this.Synopsis    = $synopsis
        $this.Description = $description
    }

    [string] setHeaders() {
        return "`n.SYNOPSIS`n$($this.Synopsis)`n`n.DESCRIPTION`n$($this.Description)`n`n"
    }
}

class Argument {
    [string]$Parameter
    [string]$Inputs
    [string]$Outputs
    [string]$Example

    Argument([string]$parameter) {
        $this.Parameter = $parameter
    }

    Argument([string]$parameter, [string]$example) {
        $this.Parameter = $parameter
        $this.Example   = $example
    }

    Argument([string]$parameter, [string]$inputs, [string]$outputs) {
        $this.Parameter = $parameter
        $this.Inputs    = $inputs
        $this.Outputs   = $outputs
    }

    Argument([string]$parameter, [string]$inputs, [string]$outputs, [string]$example) {
        $this.Parameter = $parameter
        $this.Inputs    = $inputs
        $this.Outputs   = $outputs
        $this.Example   = $example
    }

    [string] setParameter() {
        $param  = ""
        $param += if (![string]::IsNullOrEmpty($this.Parameter)) { ".PARAMETER`n$($this.Parameter)`n" } else { "" }
        $param += if (![string]::IsNullOrEmpty($this.Inputs))    { ".INPUTS`n$($this.Inputs)`n" }       else { "" }
        $param += if (![string]::IsNullOrEmpty($this.Outputs))   { ".OUTPUTS`n$($this.Outputs)`n" }     else { "" }
        $param += if (![string]::IsNullOrEmpty($this.Example))   { ".EXAMPLE`n$($this.Example)`n" }     else { "" }
        return "$param`n"
    }
}

class Note {
    [string]$Author
    [string]$Created
    [string]$Version
    [string]$Links
    [string]$Miscellaneous

    Note() {}

    Note([string]$author, [string]$created, [string]$version, [string]$miscellaneous, [string]$link) {
        $this.Author        = $author
        $this.Created       = $created
        $this.Version       = $version
        $this.Miscellaneous = $miscellaneous
        $this.Links         = $link
    }

    [string] setNotes() {
        $notes  = ".NOTES`n"
        $notes += if (![string]::IsNullOrEmpty($this.Author))        { "Author        : $($this.Author)`n" }        else { "" }
        $notes += if (![string]::IsNullOrEmpty($this.Created))       { "Created       : $($this.Created)`n" }       else { "" }
        $notes += if (![string]::IsNullOrEmpty($this.Version))       { "Version       : $($this.Version)`n" }       else { "" }
        $notes += if (![string]::IsNullOrEmpty($this.Miscellaneous)) { "Miscellaneous : $($this.Miscellaneous)`n" } else { "" }
        $notes += if (![string]::IsNullOrEmpty($this.Links))         { "`n.LINK`n$($this.Links)`n" }                else { "" }
        return "$notes`n"
    }
}

class Skeleton {
    [Header]$Header
    [Argument[]]$Params
    [Note]$Note
    hidden [string]$FileContent

    Skeleton([Header]$header, [Argument[]]$params, [Note]$note) {
        $this.Header = $header
        $this.Params = $params
        $this.Note   = $note
    }

    Skeleton() {
        $this.Header = [Header]::new("", "")
        $this.Note   = [Note]::new()
        $this.Params = @()
    }

    [void] init() {
        $this.FileContent = "<#$($this.Header.setHeaders())"
        foreach ($item in $this.Params) {
            $this.FileContent += "$($item.setParameter())"
        }
        $this.FileContent += "$($this.Note.setNotes())#>`n"
    }

    [void] initScriptFile([string]$name) {
        $this.init()
        New-Item $name -Confirm
        Set-Content -Value $this.FileContent -Path $name
        Write-Host "`nsuccess on create" -ForegroundColor Green
    }

    [void] initScriptFile([string]$name, [string]$location) {
        if ([string]::IsNullOrEmpty($name)) {
            Write-Error "name var error" 
        } elseif (!(Test-Path $location)) {
            Write-Error "path error" 
        } else {
            $this.initScriptFile((Join-Path -Path $location -ChildPath $name))
        }
    }
}