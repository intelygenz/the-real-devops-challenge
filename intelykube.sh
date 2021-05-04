#!/bin/bash
set -eo pipefail

function ensure_pwd {
    dir=the-real-devops-challenge
    if [[ $(basename "$PWD") != ${dir} ]]; then
	echo "Make sure your current working directory is: ${dir}"
	exit 1
    fi
}

function ensure_prerequisites {
    if [[ ! -x $(which minikube) ]]; then
	echo 'Ensure that Minikube is installed and accessible in your $PATH.'
	exit 1
    elif [[ ! -x $(which kubectl) ]]; then
	echo 'Ensure that Kubectl is installed and accessible in your $PATH.'
	exit 1
    elif [[ $(minikube status &>/dev/null ; echo $?) == 85 ]]; then
	minikube start
    else
	echo 'Unable to start Minikube! Check your Minikube and Kubectl installation and configuration.'
	exit 1
    fi
    eval $(minikube docker-env)
}

function build_app_docker_image {
    docker image inspect intelygenz.app &>/dev/null || \
	docker build -t intelygenz.app -f docker/app/Dockerfile .
}

function delete_app_docker_image {
    docker image inspect intelygenz.app &>/dev/null && \
	docker image rm -f intelygenz.app
}

function apply_minikube_stack {
    kubectl apply -f minikube/namespace.yaml

    kubectl -n intelygenz get configmap mongo-data &>/dev/null || \
	kubectl --namespace intelygenz create configmap mongo-data --from-file=data/

    kubectl apply -f minikube/
}

function delete_minikube_stack {
    kubectl -n intelygenz get service app &>/dev/null && \
	kubectl delete -f minikube/
}

function get_app_pod_name {
    kubectl -n intelygenz get pod -l tier=app --field-selector=status.phase=Running \
	    --output custom-columns=name:metadata.name --no-headers
}

function get_pid {
    pgrep -f 'intelygenz port-forward'
}

function start_app_port_forward {
    local app_pod_name=''
    echo "Waiting for pod to start..."
    until [[ ${app_pod_name} ]]; do
	app_pod_name=$(get_app_pod_name)
	sleep 1
    done

    echo "Port forwarding ${app_pod_name} | 8080:8080 on localhost in the background."
    echo " |_ Logging to => ${PWD}/port-forward.log"
    echo "Access the API with 'curl http://127.0.0.1:8080/api/v1/restaurant'"
    kubectl -n intelygenz get service app --no-headers &>/dev/null && \
	nohup kubectl -n intelygenz port-forward ${app_pod_name} 8080:8080 &> port-forward.log &

    local pid=''
    until [[ ${pid} ]]; do
	sleep 1
	pid=$(get_pid)
    done
    echo " |_ Port-Forward running as PID: ${pid}"
}

function stop_app_port_forward {
    pid=$(get_pid)
    if [[ ${pid} ]]; then
	echo "Stopping PID: ${pid}"
	kill -TERM ${pid}
    fi
}

main() {
    ensure_pwd

    if [[ $1 == 'up' ]]; then
	ensure_prerequisites
	echo 'Deploying Intelygenz DevOps Challenge to Minikube...'
	build_app_docker_image
	apply_minikube_stack
	start_app_port_forward
    elif [[ $1 == 'down' ]]; then
	echo 'Taking down minikube Intelygenz DevOps Challenge deployment...'
	stop_app_port_forward
	delete_minikube_stack
	delete_app_docker_image
	echo "Done!"
    else
	echo 'Available actions: "up", "down"'
	exit 1
    fi
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
