NUM_START=$1
NUM_END=$2
rm node_default/permissioned-nodes.json 2> /dev/null
echo refreshing permissioned-nodes...
## copy passwords	raft-init	raft-start	stop
sh controlscript/copy_default.sh $NUM_START $NUM_END
NUM=$(kubectl get deploy | awk '{print substr($1,5,4)}')
sh controlscript/generate_permissioned.sh $NUM
sh controlscript/deploy.sh $NUM_START $NUM_END
sh controlscript/create_ui.sh 1