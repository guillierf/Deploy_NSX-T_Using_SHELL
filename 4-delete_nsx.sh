#!/bin/bash -e

NSX_MANAGER_NAME=${NSX_MANAGER_NAME:=nsx-manager}
NSX_CONTROLLER_NAME=${NSX_CONTROLLER_NAME:=nsx-controller}
NSX_EDGE_NAME=${NSX_EDGE_NAME:=nsx-edge}

function delete_old_vms() {
  echo "Deleting old NSX VMs"
  rm -rf tmp.sh

  cat << EOF > tmp.sh
    vmid=\$(vim-cmd vmsvc/getallvms | grep \$1 | cut -d ' ' -f1)
    vim-cmd vmsvc/power.off \$vmid || true
    vim-cmd vmsvc/unregister \$vmid || true
EOF

  chmod +x tmp.sh


  echo $NSX_MANAGER_NAME
  echo $NSX_CONTROLLER_NAME
  echo $NSX_EDGE_NAME

  eval sshpass -p $ESXI_PASSWORD scp ./tmp.sh $ESXI_USERNAME@$ESXI_1:/tmp/ || true
  eval sshpass -p $ESXI_PASSWORD ssh $ESXI_USERNAME@$ESXI_1 -o StrictHostKeyChecking=no "/tmp/tmp.sh $NSX_MANAGER_NAME"
  eval sshpass -p $ESXI_PASSWORD ssh $ESXI_USERNAME@$ESXI_1 -o StrictHostKeyChecking=no "/tmp/tmp.sh $NSX_CONTROLLER_NAME"
  eval sshpass -p $ESXI_PASSWORD ssh $ESXI_USERNAME@$ESXI_1 -o StrictHostKeyChecking=no "/tmp/tmp.sh $NSX_EDGE_NAME"
  eval sshpass -p $ESXI_PASSWORD ssh $ESXI_USERNAME@$ESXI_1 -o StrictHostKeyChecking=no "rm -rf /tmp/tmp.sh"


  eval sshpass -p $ESXI_PASSWORD scp ./tmp.sh $ESXI_USERNAME@$ESXI_2:/tmp/ || true
  eval sshpass -p $ESXI_PASSWORD ssh $ESXI_USERNAME@$ESXI_2 -o StrictHostKeyChecking=no "/tmp/tmp.sh $NSX_MANAGER_NAME"
  eval sshpass -p $ESXI_PASSWORD ssh $ESXI_USERNAME@$ESXI_2 -o StrictHostKeyChecking=no "/tmp/tmp.sh $NSX_CONTROLLER_NAME"
  eval sshpass -p $ESXI_PASSWORD ssh $ESXI_USERNAME@$ESXI_2 -o StrictHostKeyChecking=no "/tmp/tmp.sh $NSX_EDGE_NAME"
  eval sshpass -p $ESXI_PASSWORD ssh $ESXI_USERNAME@$ESXI_2 -o StrictHostKeyChecking=no "rm -rf /tmp/tmp.sh"



  rm -rf tmp.sh
}


delete_old_vms
