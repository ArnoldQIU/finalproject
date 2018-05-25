NUM_START=$1
NUM_END=$2
for deploy in `seq $NUM_START $NUM_END`
do 
IPTEMP_1=$(kubectl get svc nodesvc1 | awk 'NR>1 {print $4}')
IPTEMP=$(kubectl get svc nodesvc$deploy | awk 'NR>1 {print $4}')
	echo "apiVersion: apps/v1
kind: Deployment
metadata:
  name: node${deploy}
  labels:
    app: 7node
    node: node${deploy}
spec:
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
        env: 
        - name: SERVICE_IP
          value: \"${IPTEMP}\"
        - name: SERVICE_IP1
          value: \"${IPTEMP_1}\"
        command: ['sh']
        args: ['/home/restart/restart.sh']
        volumeMounts: 
        - mountPath: /home/node_default 
          name: node-default
        - mountPath: /home/controlscript
          name: controlscript
        - mountPath: /home
          name: git-restart
        - mountPath: /home/tmp
          name: tmp-dir
      containers:
      - name: 7node
        image: markpengisme/7node:node
        imagePullPolicy: Always
        env: 
        - name: SERVICE_IP
          value: \"${IPTEMP}\"
        - name: SERVICE_IP1
          value: \"${IPTEMP_1}\"
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
        - mountPath: /home/node_default 
          name: node-default
        - mountPath: /home/controlscript
          name: controlscript
        - mountPath: /home
          name: git-restart
        - mountPath: /home/tmp
          name: tmp-dir


      volumes:
        - name: git-restart
          gitRepo:
            repository: "https://github.com/ArnoldQIU/restart.git"
        - name: tmp-dir
          emptyDir: {}
        - name: node-default
          configMap:
            name: node-default
        - name: controlscript
          configMap:
            name: controlscript" > deploy${deploy}.yaml
	kubectl apply -f deploy${deploy}.yaml
	rm deploy${deploy}.yaml
done
