<#
.synopsis
skeloton of initial scripts'file of netptune

.description
initialize the entire script file

.notes
Author  : aliceQueenImpress
Created : 2/19/2026
Version : 1.0
Compatible with PowerShell 5.x only — not supported in Core / 7+

#>

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
    hidden [string]$Paramater
    hidden [string]$Inputs
    hidden [string]$Outputs
    hidden [string]$Example

    Header([string]$parameter){
        $this.Parameter=$parameter
    }
    
    Header([string]$parameter,[string]$example){
        $this.Parameter=$parameter
        $this.Example=$example
    }

    Header([string]$parameter,[string]$inputs,[string]$outputs){
        $this.Parameter=$parameter
        $this.Inputs=$inputs
        $this.Outputs=$outputs
    }

    Header([string]$parameter,[string]$inputs,[string]$outputs,[string]$example){
        $this.Parameter=$parameter
        $this.Inputs=$inputs
        $this.Outputs=$outputs
    }

    [string]setParameter(){
        $param+=if([string]::IsNullOrEmpty($this.Paramater)){".PARAMETER`n$($this.Paramater)`n"}else{""}
        $param+=if([string]::IsNullOrEmpty($this.Inputs)){".INPUTS`n$($this.Inputs)`n"}else{""}
        $param+=if([string]::IsNullOrEmpty($this.Outputs)){".OUTPUTS`n$($this.Outputs)`n"}else{""}
        $param+=if([string]::IsNullOrEmpty($this.Example)){".EXAMPLES`n$($this.Example)`n"}else{""}

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
        $notes = ".NOTES`n"
        $notes += if(![string]::IsNullOrEmpty($this.Author)){"Author  :$($this.Author)`n"}else{""}
        $notes += if(![string]::IsNullOrEmpty($this.Created)){"Created :$($this.Created)`n"}else{""}
        $notes += if(![string]::IsNullOrEmpty($this.Version)){"Version :$($this.Version)`n"}else{""}
        $notes += if(![string]::IsNullOrEmpty($this.Miscellaneous)){"miscellaneous:$($this.Miscellaneous)`n"}else{""}
        #for links
        $notes += if(![string]::IsNullOrEmpty($this.Links)){"`n.LINK`n$($this.Links)`n"}else{""}

        return "$notes$`n"
    }
}

