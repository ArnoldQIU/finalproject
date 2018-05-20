NUM_START=$1
NUM_END=$2
for deploy in `seq $NUM_START $NUM_END`
do 
	echo "apiVersion: apps/v1
kind: Deployment
metadata:
  name: node${deploy}
  labels:
    app: 7node
    node: node${deploy}
spec:
  nodeSelector:
    node: node${deploy}
  replicas: 1
  selector:
    matchLabels:
      app: 7node
  template:
    metadata:
      labels:
        app: 7node
        node: node${deploy}
    spec:
      initContainers:
      - name: restart
        image: markpengisme/7node:node 
        command: ['cp']
        args: ['/home/controlscript/restart.sh /home']
      containers:
      - name: 7node
        image: markpengisme/7node:node
        imagePullPolicy: Always
        command: ['/bin/sh']
        args: ['-c', 'while true; do echo hello; sleep 10;done']
        ports:
        - name: raftport
          containerPort: 50400
        - name: rpcport
          containerPort: 22000
        - name: ipc
          containerPort: 21000
        - name: geth
          containerPort: 9000
        volumeMounts: 
        - mountPath: /home/backup 
          name: 7node-map
        - mountPath: /home/controlscript
          name: script-map

      volumes:
        - name: 7node-map
          configMap:
            name: 7node-map
        - name: script-map
          configMap:
            name: script-map" > deploy${deploy}.yaml
	kubectl apply -f deploy${deploy}.yaml
	rm deploy${deploy}.yaml
done
