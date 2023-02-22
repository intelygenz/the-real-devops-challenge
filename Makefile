local-mongodb:
	ifeq ($(shell docker ps -a -q -f name=local-mongodb))
		#docker run --name local-mongodb -e MONGO_INITDB_ROOT_USERNAME=admin -p 27017:27017 -e MONGO_INITDB_ROOT_PASSWORD=password -d mongo:6.0.4
		echo "eh"
	endif
	
nolocal-mongodb:
	docker stop local-mongodb && docker rm local-mongodb

dev:
	docker-compose up

nodev:
	docker-compose down

build:
	docker-compose build
 
test:
	docker run -v $(shell pwd):/tmp/app -w /tmp/app --rm painless/tox:latest /bin/bash tox

helm-deps:
	helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
	helm repo add stable https://charts.helm.sh/stable
	helm repo add grafana https://grafana.github.io/helm-charts
	helm repo update

deploy:
	kubectl apply -f yaml/app
	
setup-local-names:
	scripts/setup-local-names.sh

ingress:
	kubectl apply -f yaml/nginx-ingress
	echo "Waiting for ingress controller to fully deploy..." 
	kubectl wait --namespace ingress-nginx \
	--for=condition=ready pod \
	--selector=app.kubernetes.io/component=controller \
	--timeout=240s

observability: helm-deps setup-local-names
	kubectl apply -f monitoring/namespace.yaml
	
	helm install kind-prometheus --values monitoring/prometheus-stack-values.yaml \
		prometheus-community/kube-prometheus-stack \
		--namespace monitoring --set prometheus.service.nodePort=30000 \
		--set prometheus.service.type=NodePort \
		--set prometheus.prometheusSpec.podMonitorSelectorNilUsesHelmValues=false \
		--set prometheus.prometheusSpec.serviceMonitorSelectorNilUsesHelmValues=false \
		--set grafana.service.type=ClusterIP --set alertmanager.service.nodePort=32000 \
		--set alertmanager.service.type=NodePort --set prometheus-node-exporter.service.nodePort=32001 \
		--set prometheus-node-exporter.service.type=NodePort 

	helm install loki-distributed grafana/loki-distributed  --namespace monitoring
	
	helm install promtail -f monitoring/promtail.yaml grafana/promtail --set "loki.serviceName=loki-distributed-gateway" --namespace monitoring 
	
	kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
	
	kubectl patch -n kube-system deployment metrics-server --type=json \
  		-p '[{"op":"add","path":"/spec/template/spec/containers/0/args/-","value":"--kubelet-insecure-tls"}]'


bootstrap:
	bash scripts/kind-with-registry.sh
	$(MAKE) observability
	$(MAKE) ingress	
	$(MAKE) deploy
	$(MAKE) setup-local-names
	
	
build-and-push:
	scripts/build-and-push.sh

clean:
	kind delete cluster --name local-cluster

