#!/bin/sh

source ./envs

scp ${OVA_PATH} ${SSH_USER}@${API_HOST}:~


