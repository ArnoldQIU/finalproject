NUM_START=$1
NUM_END=$2
for deploy in `seq $NUM_START $NUM_END`
do 
  IPTEMP_1=$(kubectl get svc nodesvc1 | awk 'NR>1 {print $4}')
  IPTEMP=$(kubectl get svc nodesvc$deploy | awk 'NR>1 {print $4}')
  echo "apiVersion: apps/v1
kind: PodPreset
metadata:
  name: 7node-database
spec:
  selector:
    matchLabels:
      app: 7node
  env:
    - name: SERVICE_IP
      value: ${IPTEMP}
    - name: SERVICE_IP1
      value: ${IPTEMP_1}
  envFrom:
    - configMapRef:
        name: controlscript
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
        repository: \"https://github.com/ArnoldQIU/restart.git\"
    - name: tmp-dir
      emptyDir: {}
    - name: node-default
      configMap:
        name: node-default
    - name: controlscript
      configMap:
        name: controlscript" > PodPreset${deploy}.yaml
    kubectl apply -f PodPreset${deploy}.yaml
    rm PodPreset${deploy}.yaml
done