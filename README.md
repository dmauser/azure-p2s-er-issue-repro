# azure-p2s-er-issue-repro


## Goal

The goal of this lab is to reproduce connectivity instability observed between P2S Clients connecting over VPN Gateway using an ASN different of 65515 when ExpressRoute VPN Gateway is also present on the VNET.

## Deploy based LAB

Deploy base lab environment. It will create the following components:

- Hub VNET (10.0.0.0/24)
    - Linux VM: az-hub-lxvm - 10.0.0.4 
    - VPN Gateway Active/Active + P2S enabled: az-hub-vpngw
    - VPN Gateway ASN: 65515
    - P2S address pool: 172.16.50.0/24
    - ExpressRoute Gateway Standard SKU: az-hub-ergw
- Spoke 1 VNET (10.0.1.0/24)
    - az-spk1-lxvm (10.0.1.4)
- Spoke 2 VNET (10.0.2.0/24)
    - az-spk2-lxvm (10.0.2.4)

 Hub with ER and VPN Gateway + VM and two Spokes with one VM on each.
VPN Gateway will be deployed with ASN 65515 and later we will repro the issue by change it to different ASN like 65100.

### Prerequisites

- Log in to Azure Cloud Shell at https://shell.azure.com/ and select Bash
- Ensure Azure CLI and extensions are up to date:
  
  `az upgrade --yes`
  
- If necessary select your target subscription:
  
  `az account set --subscription <Name or ID of subscription>`
  
- Clone the  GitHub repository:
  
  `git clone https://github.com/dmauser/azure-p2s-er-issue-repro`
  
  - Change directory:
  
  `cd ./azure-p2s-er-issue-repro`

  - Run deploy.sh script

Deployment takes approximately 30 minutes.

### Configure P2S VPN Client

You need to go over two steps to get your P2S VPN Client ready

1) Install IKEv2 VPN Client

Using VPN Client packet output URL from Cloud Shell.

Extract the zip file and install VpnClientSetupAmd64.exe under WindowsAmd64 folder.

Note: You may be prompted by Windows protected your PC. Click in More Info - set Run anyway.

2) Run the following PowerShell script to install client Certificate

```powershell
#Install Certificate on P2SVPN Client (To be executed over Powershell on P2S VPN)
Start-BitsTransfer -source https://github.com/dmauser/azure-p2s-er-issue-repro/raw/main/cert/labuser.pfx -destination "$env:temp\labuser.pfx"
$mypass="Password1234" | ConvertTo-SecureString -AsPlainText -Force
Import-PfxCertificate -FilePath $env:temp\labuser.pfx -CertStoreLocation Cert:\LocalMachine\My -Password $mypass
```

## Validate connectivity

Connected P2S VPN and Check connectivity to Hub and Spoke VMs using ping and psping to SSH port for the following targets:

Note: you can open a command prompt for each one of the commands and leave it running.

-  HubVM
ping -t 10.0.0.4 
psping -t 10.0.0.4:22

- Spoke1 VM
ping 10.0.1.4 -t 
psping -t 10.0.1.4:22

- Spoke2 VM
ping -t 10.0.1.4 
psping -t 10.0.1.4:22

Note: If you are using Windows 11 you can use Windows Terminal and Split screen to leave both commands above running.

## Repro the issue

Change the ASN to 65050

1) Return to Cloud shell and run the following command:

  `az network vnet-gateway update -g $rg -n $gwname --asn 65050`

2) Check the status of psping connectivity over P2S and you may see connectivity failing. Ping (icmp) maybe working fine.

## Resolving the issue

You can resolve the issue by either running one of the options below:

1) Option 1: Set VPN Gateway to 65515 = resolves the issue

  `az network vnet-gateway update -g $rg -n $gwname --asn 65515`

2) Option 2: Delete ExpressRoute Gateway:

  `az network vnet-gateway delete -g $rg -n Az-Hub-ergw`