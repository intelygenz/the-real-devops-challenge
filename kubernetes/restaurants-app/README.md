# Restaurants APP

CHANGE

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

The following table lists the configurable parameters of the Restaurants APP chart and their default values.

| Parameter                              | Description                                   | Default |
|----------------------------------------|-----------------------------------------------|---------|
| `replicaCount`                         | Number of CDS Data Adapter replicas to create |         |
| `image.repository`                     | Restaurants APP Image name                    |         |
| `image.tag `                           | Restaurants APP Image tag                     |         |
| `image.pullPolicy`                     | Restaurants APP image pull policy             |         |
| `imagePullSecrets `                    | Specify image pull secrets                    |         |
| `nameOverride`                         |                                               |         |
| `fullnameOverride`                     |                                               |         |
| `service.type`                         |                                               |         |
| `service.port`                         |                                               |         |
| `service.containerPort`                |                                               |         |
| `resources `                           |                                               |         |
| `mongodb.service.type`                 |                                               |         |
| `mongodb.service.targetPort`           |                                               |         |
| `mongodb.service.port`                 |                                               |         |
| `mongodb.mongoUser`                    |                                               |         |
| `mongodb.mongoPassword`                |                                               |         |
| `mongodb.existingSecret`               |                                               |         |
| `mongodb.existingKey`                  |                                               |         |
| `mongodb.mongoDatabase`                |                                               |         |
| `mongodb.persistence.enabled`          |                                               |         |
| `mongodb.persistence.existingClaim`    |                                               |         |
| `mongodb.persistence.mountPath`        |                                               |         |
| `mongodb.persistence.accessModes`      |                                               |         |
| `mongodb.persistence.size`             |                                               |         |
| `mongodb.persistence.annotations`      |                                               |         |
| `mongodb.persistence.storageClassName` |                                               |         |
|                                        |                                               |         |
|                                        |                                               |         |
|                                        |                                               |         |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install --name my-release --namespace my-namespace \
  --set image.tag=0.1,replicaCount=2 \
    restaurants-app
```

## Image

The `image` parameter allows specifying which image will be pulled for the chart.

### Private registry

If the `image` is a private registry, you need to [specify an image pull secret](https://kubernetes.io/docs/concepts/containers/images/#specifying-imagepullsecrets-on-a-pod).

1. Manually create image pull secret(s) in the namespace. See [this YAML example reference](https://kubernetes.io/docs/concepts/containers/images/#creating-a-secret-with-a-docker-config). Consult your image registry's documentation about getting the appropriate secret.
2. The `image.pullSecrets` configuration value can be passed to helm using the `--set` parameter.

```console
helm install --set image.pullSecrets=SECRET_NAME restaurants-app
```

# more info: https://github.com/helm/charts/tree/master/stable/postgresql