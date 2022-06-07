function Chromium-RemoveProfileFolder {
    param (
        [Parameter(Mandatory)]
        [String] $ComputerName
        )

    if (Test-Connection -TargetName $ComputerName -Count 2 -Quiet) {
        $profiles = Invoke-Command -ComputerName $ComputerName -ScriptBlock {
            Get-ChildItem -Path "C:\Users"
        } | Select-Object -Property Name

        for ($i = 0; $i -lt $profiles.Length; $i++) {
            Write-Host $i")" $profiles[$i].Name
        }

        $userChoice = Read-Host "Select user [0 - 9]"
        $selectedUser = $profiles[$userChoice].Name

        Invoke-Command -ComputerName $ComputerName -ScriptBlock {
            if (-not(Test-Path -Path "C:\Users\$Using:selectedUser\AppData\Local\Chromium")) {
                Write-Host "Profile folder Chromium is not exist" -ForegroundColor Yellow
                break
            }

            $answerUser = Read-Host "Profile folder found. Remove? [Y/n]"

            switch ($answerUser) {
                "Y" {
                    Remove-Item -Path "C:\Users\$Using:selectedUser\AppData\Local\Chromium" -Recurse -Force
                    Write-Host "Profile folder Chromium is remove" -ForegroundColor Yellow
                }
                "n" {
                    break
                }
            }
        }
    } else {
        Write-Error "Remote computer $ComputerName is not available."
    }
}
