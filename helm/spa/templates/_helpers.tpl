{{/*
Common labels
*/}}
{{- define "spa.labels" -}}
helm.sh/chart: {{ printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
app.kubernetes.io/version: {{ .Chart.AppVersion }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "spa.selectorLabels" -}}
app.kubernetes.io/name: {{ .Values.repoName }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}