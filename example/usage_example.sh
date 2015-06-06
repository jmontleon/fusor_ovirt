#!/bin/sh
source ./envs

${BIN}/ovirt_import_template.py --debug --api_host ${API_HOST} --api_pass ${API_PASS} --vm_template_name ${VM_TEMPLATE_NAME} --cluster_name ${CLUSTER_NAME} --export_domain_name ${EXPORT_DOMAIN} --storage_domain_name ${STORAGE_DOMAIN}
if [ "$?" -ne "0" ]; then
  exit
fi

OUTPUT=`${BIN}/ovirt_create_vm_from_template.py --debug --api_host ${API_HOST} --api_pass ${API_PASS} --vm_template_name ${VM_TEMPLATE_NAME} --cluster_name ${CLUSTER_NAME} --vm_name ${VM_NAME}`
if [ "$?" -ne "0" ]; then
  exit
fi
# Get the last line of output from previous command to find the VM ID
VM_ID=`echo ${OUTPUT} | tail -n1`
echo "Will use VM ID: ${VM_ID}"

${BIN}/ovirt_add_disk_to_vm.py --debug --api_host ${API_HOST} --api_pass ${API_PASS} --size_gb ${SIZE_GB} --storage_domain ${STORAGE_DOMAIN} --vm_id ${VM_ID}
if [ "$?" -ne "0" ]; then
  exit
fi

${BIN}/ovirt_start_vm.py  --debug --api_host ${API_HOST} --api_pass ${API_PASS}  --vm_id ${VM_ID}
if [ "$?" -ne "0" ]; then
  exit
fi

${BIN}/ovirt_get_ip_of_vm.py  --debug --api_host ${API_HOST} --api_pass ${API_PASS}  --vm_id ${VM_ID}
if [ "$?" -ne "0" ]; then
  exit
fi

${BIN}/ovirt_get_datacenter_status.py --debug --api_host ${API_HOST} --api_pass ${API_PASS} --data_center ${DATA_CENTER}
if [ "$?" -ne "0" ]; then
  exit
fi

${BIN}/ovirt_get_datacenter_status.py --debug --api_host ${API_HOST} --api_pass ${API_PASS} --data_center ${DATA_CENTER}
if [ "$?" -ne "0" ]; then
  exit
fi

