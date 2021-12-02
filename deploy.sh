#Set parameters (modify for your needs)
rg=p2s-lab2 #Resource Group Name
location=eastus #Region
mypip=$(curl -4 ifconfig.io/ip -s)

#Deploy base
az group create --name $rg --location $location
az deployment group create --name P2SRepro-$RANDOM --resource-group $rg \
--template-uri https://raw.githubusercontent.com/dmauser/azure-p2s-er-issue-repro/main/azuredeploy.json \
--parameters gatewaySku=VpnGw2 vpnGatewayGeneration=Generation2 Restrict_SSH_VM_AccessByPublicIP=$mypip

# Note you will be prompted by username and password

#Variables
gwname=Az-Hub-vpngw
vnet=Az-Hub-vnet


#Point to Site config OpenVPN + IKEv2 + Certificate
az network vnet-gateway update -g $rg -n $gwname \
--client-protocol OpenVPN IkeV2  \
--address-prefixes 172.16.50.0/24 \
--root-cert-name LabRootCA \
--root-cert-data cert/labrootca.cer