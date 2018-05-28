NUM_START=$1
NUM_END=$2
rm node_default/permissioned-nodes.json 2> /dev/null
echo refreshing permissioned-nodes...

for v in `seq $NUM_START $NUM_END`
do
	GENERATE_DIR="mkdir -p /home/node && cd /home/node"
	GENERATE_KEY='#!/bin/bash
	bootnode -genkey nodekey \
	&& bootnode -writeaddress -nodekey nodekey > enode.key \
	&& echo -ne "\n" | constellation-node --generatekeys=tm \
	&& geth account new --password ./passwords.txt --keystore . \
	&& mv UTC* key'
	IPTEMP_1=$(kubectl get svc nodesvc1 | awk 'NR>1 {print $4}')
	IPTEMP=$(kubectl get svc nodesvc$v | awk 'NR>1 {print $4}')
	GENERATE_CONSTELLATION_START='#!/bin/bash
    set -u
    set -e
    DDIR="qdata/c"
    mkdir -p $DDIR
    mkdir -p qdata/logs
    cp "tm.pub" "$DDIR/tm.pub"
    cp "tm.key" "$DDIR/tm.key"
    rm -f "$DDIR/tm.ipc"
    CMD="constellation-node --url=https://'$IPTEMP':9000/ --port=9000 --workdir=$DDIR --socket=tm.ipc --publickeys=tm.pub --privatekeys=tm.key --othernodes=https://'$IPTEMP_1':9000/"
    $CMD >> "qdata/logs/constellation.log" 2>&1 &
    DOWN=true
    while $DOWN; do
        sleep 0.1
        DOWN=false
        if [ ! -S "qdata/c/tm.ipc" ]; then
                DOWN=true
        fi
    done'
	CREATE_CONSTELLATION_START="rm constellation-start.sh && echo '$GENERATE_CONSTELLATION_START' > constellation-start.sh && chmod 755 constellation-start.sh"
	kubectl exec $(kubectl get pods --selector=node=node$v|  awk 'NR>1 {print $1}') -- bash -c \
		"$GENERATE_DIR && \
		 $GENERATE_KEY && \
		 $CREATE_CONSTELLATION_START "
	echo "Generate allkey and constellation-start.sh in node$v ok"
done


NUM=$(kubectl get deploy | awk '{print substr($1,5,4)}')
sh controlscript/generate_permissioned.sh $NUM


sh controlscript/deploy.sh $NUM_START $NUM_END

sh controlscript/create_ui.sh 1