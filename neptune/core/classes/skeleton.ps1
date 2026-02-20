class Header {
    hidden [string]$Synopsis
    hidden [string]$Description

    Header([string]$synopsis,[string]$description){
        $this.Synopsis=$synopsis
        $this.Description =$description
    }

    [string]setHeaders(){ return "`n.SYNOPSIS`n$($this.Synopsis)`n`n
                                    .DESCRIPTION`n$($this.Description)`n`n" }
}

class Argument {
    hidden [string]$Parameter
    hidden [string]$Inputs
    hidden [string]$Outputs
    hidden [string]$Example

    Argument([string]$parameter){
        $this.Parameter=$parameter
    }
    
    Argument([string]$parameter,[string]$example){
        $this.Parameter=$parameter
        $this.Example=$example
    }

    Argument([string]$parameter,[string]$inputs,[string]$outputs){
        $this.Parameter=$parameter
        $this.Inputs=$inputs
        $this.Outputs=$outputs
    }

    Argument([string]$parameter,[string]$inputs,[string]$outputs,[string]$example){
        $this.Parameter=$parameter
        $this.Inputs=$inputs
        $this.Outputs=$outputs
        $this.Example=$example
    }

    [string]setParameter(){
        $param+=if(![string]::IsNullOrEmpty($this.Paramater)){".PARAMETER`n$($this.Paramater)`n"}else{""}
        $param+=if(![string]::IsNullOrEmpty($this.Inputs)){".INPUTS`n$($this.Inputs)`n"}else{""}
        $param+=if(![string]::IsNullOrEmpty($this.Outputs)){".OUTPUTS`n$($this.Outputs)`n"}else{""}
        $param+=if(![string]::IsNullOrEmpty($this.Example)){".EXAMPLES`n$($this.Example)`n"}else{""}

        return "$param`n"
    }
}

class Note {
    hidden [string]$Author
    hidden [string]$Created
    hidden [string]$Version
    hidden [string]$Links
    hidden [string]$Miscellaneous

    Note([string]$author,[string]$created,[string]$version,[string]$miscellaneous,[string]$link){
        $this.Author=$author
        $this.Created=$created
        $this.Version=$version
        $this.Miscellaneous=$miscellaneous
        $this.Links=$link
    }

    [string]setNotes (){

        #voir l'utilisation de la classe [System.Text.StringBuilder]
        $notes = ".NOTES`n"
        $notes += if(![string]::IsNullOrEmpty($this.Author)){"Author  :$($this.Author)`n"}else{""}
        $notes += if(![string]::IsNullOrEmpty($this.Created)){"Created :$($this.Created)`n"}else{""}
        $notes += if(![string]::IsNullOrEmpty($this.Version)){"Version :$($this.Version)`n"}else{""}
        $notes += if(![string]::IsNullOrEmpty($this.Miscellaneous)){"miscellaneous:$($this.Miscellaneous)`n"}else{""}
        #for links
        $notes += if(![string]::IsNullOrEmpty($this.Links)){"`n.LINK`n$($this.Links)`n"}else{""}

        return "$notes`n"
    }
}

class Skeleton {
    [Header]$Header
    [Argument[]]$Params
    [Note]$Note
    hidden [string]$FileContent

    Skeleton([Header]$header,[Argument[]]$params,[Note]$note){
        $this.Header = $header
        $this.Params = $params
        $this.Note = $note
    }

    Skeleton(){

    }

    [void]init(){
        $this.FileContent = "<#$($this.Header.setHeaders())"
        foreach($items in $this.Params){
            $this.FileContent+="$($items.setParameter())"
        }
        $this.FileContent +="$($this.Note.setNotes())#>`n"
    }



    [void]initScriptFile([string]$name){
        $this.init
        New-Item $name -Confirm
        Set-Content -Value $this.FileContent -Path $name
    }

    [void]initScriptFile([string]$name,[string]$location){       
        if([string]::IsNullOrEmpty($name)){
            Write-Host "name var error"
        }elseif (!(Test-Path $location)){
            Write-Host "path error"
        }else { $this.initScriptFile((Join-Path -Path $location -ChildPath $name))}
    }
}