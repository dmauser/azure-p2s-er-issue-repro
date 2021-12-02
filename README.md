# azure-p2s-er-issue-repro


## Goal
This a lab to repro connectivity instability between P2S Clients connecting over VPN Gateway using an ASN different of 65515.


## Deploy based LAB

Deploy base lab environment = Hub with ER and VPN Gateway + VM and two Spokes with one VM on each.
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

Deployment takes approximately 30 minutes.

## Configure P2S VPN Client

You need to go over two steps to get your P2S VPN Client ready

### 1) Install IKEv2 VPN Client

### 2)

### Validate connectivity

Connected P2S VPN and Check connectivity to Hub and Spoke VMs using ping and psping to SSH port for the following targets:

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

Example:

## Repro the issue

Change the ASN

1) Set 