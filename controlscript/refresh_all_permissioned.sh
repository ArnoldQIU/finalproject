NUM_START=$1
NUM_END=$2
echo refreshing permissioned-nodes...
## copy passwords	raft-init	raft-start	stop
sh controlscript/copy_default.sh $NUM_START $NUM_END
NUM=$(kubectl get deploy | awk '{print substr($1,5,4)}')
sh controlscript/generate_permissioned.sh $NUM
NUM_START=$1
NUM_END=$2
sh controlscript/deploy.sh $NUM_START $NUM_END
sh node_default/create_ui.sh 1