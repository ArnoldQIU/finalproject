NUM_START=$1
NUM_END=$2
for deploy in `seq $NUM_START $NUM_END`
do 
  IPTEMP_1=$(kubectl get svc nodesvc1 | awk 'NR>1 {print $4}')
  IPTEMP=$(kubectl get svc nodesvc$deploy | awk 'NR>1 {print $4}')
  echo "kind: PodPreset
metadata:
  name: 7node-database
spec:
  selector:
    matchLabels:
      app: 7node
  env:
    - name: SERVICE_IP
      value: \"${IPTEMP}\"
    - name: SERVICE_IP1
      value: \"${IPTEMP_1}\" " > podpreset${deploy}.yaml
    kubectl apply -f podpreset${deploy}.yaml --validate=false
    rm podpreset${deploy}.yaml
done