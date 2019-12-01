{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "mongodb.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "mongodb.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "mongodb.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "mongodb.labels" -}}
app.kubernetes.io/name: {{ include "mongodb.name" . }}
helm.sh/chart: {{ include "mongodb.chart" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
{{- end -}}

{{/*
Get the root password secret.
*/}}
{{- define "mongodb.secretRootName" -}}
{{- if .Values.existingRootSecret }}
    {{- printf "%s" .Values.existingRootSecret -}}
{{- else -}}
    {{- $name := default "root" -}}
    {{- printf "%s-%s" (include "mongodb.fullname" .) $name -}}
{{- end -}}
{{- end -}}

{{/*
Return true if a root secret object should be created
*/}}
{{- define "mongodb.createRootSecret" -}}
{{- if .Values.existingRootSecret }}
    {{- false -}}
{{- else -}}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Return root MongoDB password
*/}}
{{- define "mongodb.rootPassword" -}}
{{- if .Values.mongoRootPassword -}}
    {{- .Values.mongoRootPassword -}}
{{- else -}}
    {{- randAlphaNum 10 -}}
{{- end -}}
{{- end -}}


{{/*
Get the password secret.
*/}}
{{- define "mongodb.secretUserName" -}}
{{- if .Values.existingUserSecret }}
    {{- printf "%s" .Values.existingUserSecret -}}
{{- else -}}
    {{- $name := default "app" -}}
    {{- printf "%s-%s" (include "mongodb.fullname" .) $name -}}
{{- end -}}
{{- end -}}

{{/*
Return true if a secret object should be created
*/}}
{{- define "mongodb.createUserSecret" -}}
{{- if .Values.existingUserSecret }}
    {{- false -}}
{{- else -}}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Return MongoDB password
*/}}
{{- define "mongodb.userPassword" -}}
{{- if .Values.mongoUserPassword -}}
    {{- .Values.mongoUserPassword -}}
{{- else -}}
    {{- randAlphaNum 10 -}}
{{- end -}}
{{- end -}}


{{/*
Get the config configmap.
*/}}
{{- define "mongodb.configmapName" -}}
{{- if .Values.existingConfigmap }}
    {{- printf "%s" .Values.existingConfigmap -}}
{{- else -}}
    {{- $name := default "configmap" -}}
    {{- printf "%s-%s" (include "mongodb.fullname" .) $name -}}
{{- end -}}
{{- end -}}

{{/*
Return true if a configmap should be created
*/}}
{{- define "mongodb.createConfigmap" -}}
{{- if .Values.existingConfigmap }}
{{- else -}}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Get the root secret path.
*/}}
{{- define "mongodb.secretRootPath" -}}
{{- if .Values.existingRootSecret }}
    {{- printf "%s/%s" .Values.mongoRootPasswordFilePath .Values.existingRootKey -}}
{{- else -}}
    {{- $name := default "mongo-password" -}}
    {{- printf "%s/%s" .Values.mongoRootPasswordFilePath $name -}}
{{- end -}}
{{- end -}}

{{/*
Get the user secret path.
*/}}
{{- define "mongodb.secretUserPath" -}}
{{- if .Values.existingUserSecret }}
    {{- printf "%s/%s" .Values.mongoUserPasswordFilePath .Values.existingUserKey -}}
{{- else -}}
    {{- $name := default "app-password" -}}
    {{- printf "%s/%s" .Values.mongoUserPasswordFilePath $name -}}
{{- end -}}
{{- end -}}
