
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
# redirect output to > NUL
if ( multipass info bikeindexv2   ){
    
   ( write-output "instance found") -and (multipass shell bikeindexv2)
}
else{
    # the following is already set - so should work?
    # multipass set local.privileged-mounts=true
    # multipass set local.bridged-network=Wi-Fi
    # refreshenv 
    # need to input a 5s sleep
    # Start-Sleep 5
    multipass launch focal --name bikeindexv2 --bridged --disk 10G --memory 2G --cloud-init bike_index\seya\ops\cloud-init.yml
    Start-Sleep 12
    multipass transfer ./bike_index bikeindexv2:/home/ubuntu/ --recursive  
    Start-Sleep 12
    # multipass mount . bikeindex:/home/ubuntu/ --recursive 
    multipass shell bikeindexv2
}

# multipass shell bikeindex # | ./bike_index/kickstand.sh 
