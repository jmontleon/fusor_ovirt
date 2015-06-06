#!/bin/sh

source ./envs


ssh ${SSH_USER}@${API_HOST} -C "engine-image-uploader -u ${API_USER} -p ${API_PASS} -N ${VM_TEMPLATE_NAME} -e ${EXPORT_DOMAIN} -m upload ~/${OVA_NAME}"

