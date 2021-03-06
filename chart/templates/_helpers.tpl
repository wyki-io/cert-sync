{{/*
Expand the name of the chart.
*/}}
{{- define "cert-sync.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "cert-sync.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := include "cert-sync.name" . }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "cert-sync.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Define the image, whether it comes from Skaffold or from values
*/}}
{{- define "cert-sync.image" -}}
{{ .Values.skaffoldImage | default (printf "%s:%s" .Values.image.repository (.Values.image.tag | default .Chart.AppVersion)) }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "cert-sync.labels" -}}
helm.sh/chart: {{ include "cert-sync.chart" . }}
{{ include "cert-sync.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "cert-sync.selectorLabels" -}}
app.kubernetes.io/name: {{ include "cert-sync.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "cert-sync.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "cert-sync.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the name of the cluster role to use
*/}}
{{- define "cert-sync.clusterRoleName" -}}
{{- if .Values.clusterRole.create }}
{{- default (include "cert-sync.fullname" .) .Values.clusterRole.name }}
{{- else }}
{{- default "default" .Values.clusterRole.name }}
{{- end }}
{{- end }}

{{/*
Create the name of the cluster role binding to use
*/}}
{{- define "cert-sync.clusterRoleBindingName" -}}
{{- printf "%s-secret-read-binding" (include "cert-sync.fullname" .) }}
{{- end }}

{{/*
Create the name of the cert-sync config map to use
*/}}
{{- define "cert-sync.configMapName" -}}
{{- printf "%s-config" (include "cert-sync.fullname" .) }}
{{- end }}

{{/*
Define the HTTP Proxy
*/}}
{{- define "cert-sync.httpProxy" -}}
{{- .http | default "" }}
{{- end }}

{{/*
Define the HTTPS Proxy
*/}}
{{- define "cert-sync.httpsProxy" -}}
{{- .https | default .http }}
{{- end }}

{{/*
Define the No Proxy
*/}}
{{- define "cert-sync.noProxy" -}}
{{- .no | default "localhost,127.0.0.1,10.0.0.0/8,169.254.169.254,.svc,.local" }}
{{- end }}
