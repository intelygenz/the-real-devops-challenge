#!/bin/bash

help() {
    echo "This script allows to execute microk8s and deploy the k8s resources"
    echo
    echo "Usage: $0 [ help | start | stop | enable-addons | install-k8s-resources ]"
    echo "  start                           start microk8s server"
    echo "  help                            help usage"
    echo "  stop                            stop microk8s server"
    echo "  enable-addons                   enable addons microk8s server [dns, dashboards, ingress, storage, rbac]"
    echo "  install-k8s-resources           install the k8s resources for the challenge"
}

check_microk8s() {
    if ! microk8s status; then
        echo "Install microk8s before you execute this script."
        echo "Some helping..."
        echo "Go to this link: https://microk8s.io/docs and select your operating system."
        exit 1
    fi
}

check_helmfile() {
    if ! helmfile version; then
        echo "Install helmfile before installing the resources."
        echo "Some helping..."
        echo "Go to this link: https://github.com/roboll/helmfile/releases and select your operating system."
        exit 1
    fi
}

check_helm() {
    if ! helm version; then
        echo "Install helm before installing the resources."
        echo "Some helping..."
        echo "Go to this link: https://helm.sh/docs/intro/install/ and select your operating system."
        exit 1
    fi
}

start() {
    check_microk8s
    status=$(microk8s status | awk '/is not running/')
    if [ -n "${status}" ]; then
        microk8s start
    else
        echo "Microk8s already started."
        exit 1
    fi
}

stop() {
    check_microk8s
    status=$(microk8s status | awk '/is running/')
    if [ -n "${status}" ]; then
        microk8s stop
    else
        echo "Microk8s already stopped."
        exit 1
    fi
}

enable-addons() {
    check_microk8s
    status=$(microk8s status | awk '/is running/')
    if [ -n "${status}" ]; then
        microk8s enable dns ingress storage dashboard rbac
    else
        echo "Microk8s is stopped."
    fi
}

install-k8s-resources() {
    check_helmfile
    check_helm
    status=$(microk8s status | awk '/is running/')
    if [ -n "${status}" ]; then
        mkdir ~/.kube/
        microk8s config > ~/.kube/config
        chmod 600 ~/.kube/config
    else
        echo "Microk8s is stopped."
        exit 1
    fi
    if ! helm diff version; then
        echo "Installing helm diff plugin..."
        helm plugin install https://github.com/databus23/helm-diff
    fi
    helmfile apply
}



case $1 in
    start)
        start
        ;;
    stop)
        stop
        ;;
    enable-addons)
        enable-addons
        ;;
    install-k8s-resources)
        install-k8s-resources
        ;;
    *)
        help
        ;;
esac

