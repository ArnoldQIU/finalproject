#!/bin/bash
NUM_START=$1
NUM_END=$2
DEPLOY1=$3
DEPLOY2=$4
echo refreshing permissioned-nodes...
## copy passwords	raft-init	raft-start	stop
sh controlscript/copy_default.sh $NUM_START $NUM_END
NUM=$(kubectl get deploy | awk '{print substr($1,5,4)}')
sh controlscript/generate_permissioned.sh $NUM
echo deplolying...
sleep 10
sh controlscript/deploy.sh DEPLOY1 DEPLOY2

cd /node_default && sh node_default/create_ui.sh 1