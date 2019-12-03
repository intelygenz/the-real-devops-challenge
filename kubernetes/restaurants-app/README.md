# Restaurants APP

Restaurants APP is a app for finding restaurants in a place and gibes the posibility to search for a specific restaurant to see its characteristics.

## TL;DR;

```console
$ helm install restaurants-app
```

## Introduction

This chart bootstraps a Restaurants APP and Mongo DB deployments on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Installing the Chart

To install the chart with the release name `my-release` in `my-namespace`:

```console
$ helm install --name my-release --namespace my-namespace restaurants-app
```

The command deploys Restaurants APP on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

A configuration file `value.yaml` sets the configuration for Restaurants APP and the Mongo DB. The meanings and defaults values of the parameters specific to a component are described in each components configuration values file.

## Image

The `image` parameter allows specifying which image will be pulled for the chart.

### Private registry

If the `image` is a private registry, you need to [specify an image pull secret](https://kubernetes.io/docs/concepts/containers/images/#specifying-imagepullsecrets-on-a-pod).

1. Manually create image pull secret(s) in the namespace. See [this YAML example reference](https://kubernetes.io/docs/concepts/containers/images/#creating-a-secret-with-a-docker-config). Consult your image registry's documentation about getting the appropriate secret.
2. The `image.pullSecrets` configuration value can be passed to helm using the `--set` parameter.

```console
helm install --set image.pullSecrets=SECRET_NAME restaurants-app
```

## Password Generator

This chart generates by default automatically the passwords for the restaurant app user and the root user in mongo db and creats its respective secrets in Kubernetes.

If you want to use existing secrets for the passwords please update:
* existingRootSecret
* existingUserSecret

in the values file.

