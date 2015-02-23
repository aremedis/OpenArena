
[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") 

$FileServer = "filebox4.mc.tmaresources.com"
$source = "\\"+$FileServer+"\transfer\rwatson\OpenArena\openarena-0.8.8" 
$user = [Environment]::UserName
$destination = "C:\Users\"+$user+"\OpenArena"
$CurrentComputer = $env:computername
$today = Get-Date
$configLoc = "C:\Users\"+$user+"\AppData\Roaming\OpenArena"
$configFile = $configloc+"\baseoa\q3config.cfg"
$ConfigSRC = "\\"+$FileServer+"\transfer\rwatson\OpenArena\baseoa"


function OpenArenaInstall()
    {
        Copy-Item $source -Destination $destination -recurse -force
        ####
        # Create Desktop shortcut for OpenArena
        $shell = New-Object -ComObject WScript.shell
        $desktop = [System.Environment]::GetFolderPath('Desktop')
        $shortcut = $shell.CreateShortcut("$desktop\OpenArena.lnk")
        $shortcut.TargetPath = "$destination\openarena.exe"
        $shortcut.IconLocation = "$destination\openarena.exe"
        $shortcut.Save()
        ###
        "Install Complete"
        ###

        #Append to logfile when copy Complete
        ###
        Add-Content -Path \\filebox4\Transfer\rwatson\OpenArena\installed.log -Value "$today, $CurrentComputer, $user`n"
        ###
       ModConfig
        [System.Windows.Forms.MessageBox]::Show("Click the OpenArena icon on your Desktop to play")
    }

function ModConfig()
{
    "Modifying Config Files"
    Copy-Item $ConfigSRC -Destination $configLoc -recurse -force
    
    Add-Content $configFile "seta name  `"$user`""
    SetModel
    
}

function SetModel()
{
    $Models = @("tony", "beret", "beret/red", "gargoyle", "assassin", "smarine", "skelebot",  "merman", "sergei", "sarge")

    $randModel = Get-Random $Models



    "Setting Player Model"

    Add-Content $configFile "seta model `"$randModel`""
    Add-Content $configfile "seta headmodel `"$randModel`""
    Add-Content $configFile "seta team_model `"$randModel`""
    Add-Content $configFile "seta team_headmodel `"$randModel`""
}

## Test connection to fileserver, and then begin copying.
function ConnTest ()
    {
        if (test-Connection -Cn $FileServer -quiet)
            {
                "Installing OpenArena, please wait..."
                ## Create logfile if it does not already exist
                if (!(Test-Path -Path \\filebox4\Transfer\rwatson\OpenArena\installed.log)){
                    new-item -Path \\filebox4\Transfer\rwatson\OpenArena\installed.log -itemtype file
                }
                
                OpenArenaInstall
            }
        else
            {
                $Message = [System.Windows.Forms.MessageBox]::Show("Unable to connect to TMAR, please ensure you are connected to the network via VPN, or in the office.", "Status", 5)
                if ($Message -eq "Retry")
                {
                    ConnTest
                }
                else {exit}

            }

    }

## Begin Script
ConnTest

