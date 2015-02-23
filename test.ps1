$user = [Environment]::UserName
$CurrentComputer = $env:computername
$today = Get-Date

if (!(Test-Path -Path \\filebox4\Transfer\rwatson\OpenArena\installed.txt)){
            new-item -Path \\filebox4\Transfer\rwatson\OpenArena\installed.txt -itemtype file
        }
        else {
            Add-Content -Path \\filebox4\Transfer\rwatson\OpenArena\installed.txt -Value "$today , $CurrentComputer  ,  $user`n"
        }