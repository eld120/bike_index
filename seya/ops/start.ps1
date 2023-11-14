
# Check for chocolatey
if (Get-Command choco.exe){
    Write-Output "chocolatey is installed"
}
else{
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}


# check for multipass
if (Get-Command multipass.exe){
    Write-Output "multipass is installed"
}
else{
    choco install -y virtualbox --params "'/NoDesktopShortcut /ExtensionPack'"
    choco install -y multipass --force --params "'/HyperVisor:VirtualBox'"
}

# check for our vm
if (multipass info bikeindex ){
    # multipass shell bikeindex
    write-output "instance found"
}
else{
    multipass launch focal --name bikeindex --disk 10G --memory 2G --cloud-init ./ops/cloud-init.yml | multipass transfer ./bike_index bikeindex:/home/ubuntu/ --recursive
}

multipass shell bikeindex # | ./bike_index/kickstand.sh 