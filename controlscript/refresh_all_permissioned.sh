NUM_START=$1
NUM_END=$2
echo refreshing permissioned-nodes...
## copy passwords	raft-init	raft-start	stop
sh controlscript/copy_default.sh $NUM_START $NUM_END
NUM=$(kubectl get deploy | awk '{print substr($1,5,4)}')
sh controlscript/generate_permissioned.sh $NUM
for v in `seq $NUM_START $NUM_END`
do
	kubectl exec $(kubectl get pods --selector=node=node$v|  awk 'NR>1 {print $1}') -- bash -c "cd home/node && chmod 755 *.sh && ./stop.sh"
done

for v in `seq $NUM_START $NUM_END`
do
	kubectl exec $(kubectl get pods --selector=node=node$v|  awk 'NR>1 {print $1}') -- bash -c "cd home/node && ./raft-init.sh && ./raft-start.sh" &
	echo -e "No.$v node deploy ok\n\n"
done

sh node_default/create_ui.sh 1