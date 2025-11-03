# updating_system
sudo apt-get update

sudo journalctl -u docker --no-pager -n 50

sudo systemctl status containerd

sudo apt install --reinstall containerd -y

sudo systemctl enable containerd
sudo systemctl start containerd
sudo systemctl status docker


# Docker installation---------------------------

1. sudo apt-get install docker.io -y
2. docker ps
3. if there is permission denied error 
then command
3.1  sudo usermod -aG docker $USER && newgrp docker
3.2   sudo systemctl start containerd
3.3. sudo systemctl start docker
3.4 then check with command- docker ps
3.5 even it is not working then  use this command " docker update --restart unless-stopped $(docker ps -q)"

# How to install Kind-----------------------------

1. chmod +x  install_kind.sh
2. ./install_kind.sh (this is the file name which is avilable on kind cluster)

# how to install kubectl------------------------------

1. chmod +x  install-kubectl.sh
2. ./install-kubectl.sh


# how to create cluster-----------------------

1. kind create cluster --config=config.yml --name =my-cluster
2. kubectl get nodes

# How to install kubernetes --------------------------------------

1. https://www.linuxbuzz.com/install-k3s-kubernetes-cluster-on-ubuntu/


# How to install Helm --------------------------------------

1. curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
2. chmod +x get_helm.sh
3. ./get_helm.sh

 (rest  part installation following https://www.youtube.com/watch?v=DXZUunEeHqM&t=451s)


# How to create dashboard in local mechine ------------------------------------------------

1. kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml
2. kubectl get pods -n kubernetes-dashboard
3. kubectl port-forward -n kubernetes-dashboard service/kubernetes-dashboard 10443:443
4. after then you will see:  Forwarding from 127.0.0.1:10443 -> 8443
5. browse -   https://localhost:10443
6. kubectl create serviceaccount dashboard-admin -n kubernetes-dashboard
kubectl create clusterrolebinding dashboard-admin \
  --clusterrole=cluster-admin \
  --serviceaccount=kubernetes-dashboard:dashboard-admin

7. kubectl -n kubernetes-dashboard create token dashboard-admin


# how to add helm repo list-------------------------------

1. helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
2. helm  repo add  stable https://charts.helm.sh/stable 
  helm repo add  grafana  https://grafana.github.io/helm-charts 
3. helm repo update

# Install prometheous with different namespace----------------------------------

1. kubectl create ns  monitoring
2. helm install kind-prometheus prometheus-community/kube-prometheus-stack --namespace monitoring --set prometheus.service.nodePort=30000 --set prometheus.service.type=NodePort --set grafana.service.nodePort=31000 --set grafana.service.type=NodePort --set alertmanager.service.nodePort=32000 --set alertmanager.service.type=NodePort --set prometheus-node-exporter.service.nodePort=32001 --set prometheus-node-exporter.service.type=NodePort
or
helm install kind-prometheus prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --create-namespace \
  -f alertmanager-values.yml \
  --set prometheus.service.nodePort=30000 \
  --set prometheus.service.type=NodePort \
  --set grafana.service.nodePort=31000 \
  --set grafana.service.type=NodePort \
  --set alertmanager.service.nodePort=32000 \
  --set alertmanager.service.type=NodePort \
  --set prometheus-node-exporter.service.nodePort=32001 \
  --set prometheus-node-exporter.service.type=NodePort

to check password .: "kubectl --namespace monitoring get secrets monitoring-stack-grafana -o jsonpath="{.data.admin-password}" | base64 -d ; echo"

to create a secret in alter manager 
" kubectl create secret generic alertmanager-gmail-secret \                                            
  --from-file=alertmanager.yml=alertmanager-values.yml \ 
  -n monitoring "

to update the helm " helm upgrade --install kind-prometheus prometheus-community/kube-prometheus-stack -n monitoring -f values.yaml"  

kubectl create secret generic grafana-smtp-secret \
  --from-literal=SMTP_PASSWORD='YOUR_APP_PASSWORD' \
  -n monitoring

to update helm " helm upgrade --install kind-prometheus prometheus-community/kube-prometheus-stack -n monitoring -f values.yaml "

3. kubectl get pods -n monitoring
4. kubectl get svc -n monitoring
5. kubectl port-forward svc/kind-prometheus-kube-prome-prometheus -n monitoring 9090:9090 --address=0.0.0.0 &
6. browse (what shoowing in "forwarding ....")
7. then prometheous page is visiable then chose status--> target

# prometheous queries-------------------------------------------

1. in queries "sum (rate (container_cpu_usage_seconds_total{namespace="default"}[1m])) / sum (machine_cpu_cores) * 100"
2. sum(rate(container_network_receive_bytes_total{namespace="default"}[5m])) by (pod)

# application port-forwarding ---------------------------------------

1. kubectl get svc
2. kubectl port-forward svc/vote 5000:5000 --address=0.0.0.0 &
3. browse the ip address with port which is showing after forwarding
4. open duplicate browsers several times(at least 5 browsers)

# For grafana----------------------------------------

1. kubectl get svc -n monitoring
2. kubectl port-forward svc/kind-prometheus-grafana -n monitoring 3000:80 --address 0.0.0.0 &
3. open a browser with this ip address which are showed with forwarding
4. then grafana page will be visiable . username : admin , password : prom-operator
5. from left slide option , administration should be chosen  then user , then new user-= user demo gmail : shabnaz.......pi-lar.net , rest of all are demo
6.  then go organistions  --> role make viewer --> save and open duplicate  page
7. go to connection from lef side then data source then get "add new dashboard" and then "add visiualization", then  found data source  and click search bar get prometheous
8. in down, found metrics and chose container-cpu-...-total , lebel will be namespace and next one is kube-system
9.top is time.select last five minutes 
