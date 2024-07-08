param location string = resourceGroup().location
param vmName string
param adminUsername string
param adminPassword string
param vmSize string = 'Standard_DS1_v2'
param imagePublisher string = 'MicrosoftWindowsDesktop'
param imageOffer string = 'windows-10'
param imageSku string = '21h1-evd'
param vnetName string
param subnetName string

resource vnet 'Microsoft.Network/virtualNetworks@2021-02-01' existing = {
  name: vnetName
}

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2021-02-01' existing = {
  parent: vnet
  name: subnetName
}

resource avdVm 'Microsoft.Compute/virtualMachines@2021-04-01' = {
  name: vmName
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    storageProfile: {
      imageReference: {
        publisher: imagePublisher
        offer: imageOffer
        sku: imageSku
        version: 'latest'
      }
    }
    osProfile: {
      computerName: vmName
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: subnet.id
        }
      ]
    }
  }
}

resource hostPool 'Microsoft.DesktopVirtualization/hostPools@2021-03-09-preview' = {
  name: 'rrtestHostPool'
  location: location
  properties: {
    friendlyName: 'RR Test Host Pool'
    description: 'Host Pool for Virtual Desktops'
    hostPoolType: 'Pooled'
    preferredAppGroupType: 'Desktop'
    loadBalancerType: 'BreadthFirst'
    maxSessionLimit: 10
  }
}
