#Install Certificate on P2SVPN Client (To be executed over Powershell on P2S VPN)
Start-BitsTransfer -source https://github.com/dmauser/azure-p2s-er-issue-repro/raw/main/cert/labuser.pfx -destination "$env:temp\labuser.pfx"
$mypass="Password1234" | ConvertTo-SecureString -AsPlainText -Force
Import-PfxCertificate -FilePath $env:temp\labuser.pfx -CertStoreLocation Cert:\LocalMachine\My -Password $mypass
