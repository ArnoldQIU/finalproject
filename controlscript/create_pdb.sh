echo "apiVersion: policy/v1beta1
kind: PodDisruptionBudget
metadata:
  name: 7node-pdb
spec:
  minAvailable: 2
  selector:
    matchLabels:
      app: 7node" > 7node_pdb.yaml

kubectl apply -f 7node_pdb.yaml
rm 7node_pdb.yaml