
#
y-NSX-T: automatically deploy and configure NSX-T
This project contains scripts to Install and Configure NSX-T (any version of NSX-T).

The scripts are based on Linux Shell and use stadard tools like OVFtool, sshpass, jq and curl.

Scripts are:
* 1-install_nsx.sh
* 2-enable_nsx_cluster.sh
* 3-configure_nsx.sh

#### 1-install_nsx.sh
Creates the following NSX-T components:
* 1 NSX Manager
* 1 NSX Controller
* 1 NSX Edge

#### 2-enable_nsx_cluster.sh
Form NSX-T cluster:
NSX Controller will be registered to NSX Manager
NSX Edge will be registered to NSX Manager

#### 3-configure_nsx.sh
Create following NSX-T objects:
* Creating VLAN transport zone
* Creating OVERLAY transport zone
* Creating uplink profile
* Creating IP address pool
* Configuring Edge transport node
* Creating Edge cluster
* Creating T0 router
* Creating logical switch
* Creating logical port
* Creating router port
* Adding static route
* Creating T1 router
* Creating router port in T0 for DHCP router
* Creating router port in DHCP router and link it to T0 router port
* Creating logical switch to connect to dhcp server
* Creating logical port to connect to dhcp server
* Creating router port to connect to dhcp server
* Configuring router advertisement configuration


## System requirements
To run these scripts, you need:
* 1 VM running Linux (Ubuntu tested here) - the scripts can be running on your MAC laptop as well
* Web server running on the VM (use apache2 for instance)
* OVFTool installed in the VM
* sshpass installed in the VM
* jq installed in the VM

## Lab requirements
NSX-T will be deployed in the lab with the following config:
* 1 MGMT cluster (will host NSX Manager and NSX Controller)
* 1 COMPUTE cluster (will host NSX Edge)


## Procedure
### stage 1: install NSX


Place all NSX-T OVA files in the root directory of your web server.
For apache2, default root directory is /var/www/html/ .

Create a file named 'install_nsx.env':
```
export NSX_MANAGER_OVA_URL=http://localhost/nsx-unified-appliance-2.0.0.0.0.6522097.ova
export NSX_CONTROLLER_OVA_URL=http://localhost/nsx-controller-2.0.0.0.0.6522091.ova
export NSX_EDGE_OVA_URL=http://localhost/nsx-edge-2.0.0.0.0.6522113.ova

export VCENTER_IP=10.40.206.61
export VCENTER_USERNAME="administrator@vsphere.local"
export VCENTER_PASSWORD="VMware1!"

export NSX_HOST_COMMON_DATACENTER=Datacenter
export NSX_HOST_COMPUTE_CLUSTER=COMP-Cluster-1
export NSX_HOST_COMPUTE_DATASTORE=NFS-LAB-DATASTORE
export NSX_HOST_MGMT_CLUSTER=MGMT-Cluster
export NSX_HOST_MGMT_DATASTORE=NFS-LAB-DATASTORE
export NSX_HOST_COMMON_NETWORK0=CNA-VM
export NSX_HOST_COMMON_NETWORK1=NSX-VTEP-PG
export NSX_HOST_COMMON_NETWORK2=CNA-INFRA
export NSX_HOST_COMMON_NETWORK3=CNA-INFRA

export NSX_MANAGER_IP=10.40.207.33
export NSX_CONTROLLER_IP=10.40.207.34
export NSX_EDGE_IP=10.40.207.35
export NSX_COMMON_PASSWORD="VMware1!"
export NSX_COMMON_DOMAIN="nsx.vmware.com"
export NSX_COMMON_NETMASK=255.255.255.0
export NSX_COMMON_GATEWAY=10.40.207.253
export NSX_COMMON_DNS=10.20.20.1
export NSX_COMMON_NTP=10.113.60.176

export NSX_OVERWRITE=false
```

Source it:
```
source install_nsx.env
```

Then run the first script:
```
./1-install_nsx.sh
```


### stage 2: enable NSX cluster

Run the second script:
```
./2-enable_nsx_cluster.sh
```


### stage 3: configure NSX

Create a file named 'configure_nsx.env':
```
export NETWORK_TUNNEL_IP_POOL_CIDR="192.168.150.0/24"
export NETWORK_TUNNEL_IP_POOL_ALLOCATION_START="192.168.150.200"
export NETWORK_TUNNEL_IP_POOL_ALLOCATION_END="192.168.150.250"
export NETWORK_T0_SUBNET_IP_ADDRESS="10.40.206.20"
export NETWORK_T0_SUBNET_PREFIX_LENGTH=25
export NETWORK_T0_GATEWAY="10.40.206.125"
export NETWORK_HOST_UPLINK_PNIC='vmnic1'
```

Source it:
```
source configure_nsx.env
```

Then run the third script:
```
3-configure_nsx.sh
```

#

