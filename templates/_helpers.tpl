{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "mastodon.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "mastodon-web.name" -}}
{{- printf "mastodon-web-%s" .Values.appName | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "postgresql.name" -}}
{{- printf "postgresql-%s" .Values.appName | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "redis.name" -}}
{{- printf "redis-%s" .Values.appName | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "minio.name" -}}
{{- printf "minio-%s" .Values.appName | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "mastodon.fullname" -}}
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

{{- define "mastodon-web.fullname" -}}
{{- printf "mastodon-web-%s-%s" .Release.Name .Values.appName | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "postgresql.fullname" -}}
{{- printf "postgresql-%s-%s" .Release.Name .Values.appName | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "redis.fullname" -}}
{{- printf "%s-%s" .Release.Name "redis" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "minio.fullname" -}}
{{- printf "%s-%s" .Release.Name "minio" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "mastodon.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "mastodon.labels" -}}
helm.sh/chart: {{ include "mastodon.chart" . }}
{{ include "mastodon.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{- define "mongodb.labels" -}}
helm.sh/chart: {{ include "mastodon.chart" . }}
{{ include "mongodb.selectorLabels" . }}
{{- if .Values.image_version }}
app.kubernetes.io/version: {{ .Values.image_version | quote }}
{{- else }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{- define "mastodon-web.labels" -}}
helm.sh/chart: {{ include "mastodon.chart" . }}
{{ include "mastodon-web.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{- define "postgresql.labels" -}}
helm.sh/chart: {{ include "mastodon.chart" . }}
{{ include "postgresql.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{- define "redis.labels" -}}
helm.sh/chart: {{ include "mastodon.chart" . }}
{{ include "redis.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{- define "minio.labels" -}}
helm.sh/chart: {{ include "mastodon.chart" . }}
{{ include "minio.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "mastodon.selectorLabels" -}}
app.kubernetes.io/name: {{ include "mastodon.name" . }}
app.kubernetes.io/component: {{ include "mastodon.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
deploymentconfig: {{ include "mastodon.fullname" . }}
{{- end -}}

{{- define "mastodon-web.selectorLabels" -}}
app.kubernetes.io/name: {{ include "mastodon-web.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{- define "postgresql.hostname" -}}
{{- if .Values.postgresql.enabled -}}
{{- printf "%s-%s" "postgresql" .Values.appName | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s" .Values.postgresql.postgresqlServer -}}
{{- end -}}
{{- end -}}

{{- define "postgresql.selectorLabels" -}}
app.kubernetes.io/name: {{ include "postgresql.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{- define "redis.selectorLabels" -}}
app.kubernetes.io/name: {{ include "redis.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{- define "minio.selectorLabels" -}}
app.kubernetes.io/name: {{ include "minio.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Other
*/}}
{{- define "mastodon-web.s3_endpoint" -}}
{{- printf "http://%s:9000/" (include "minio.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
