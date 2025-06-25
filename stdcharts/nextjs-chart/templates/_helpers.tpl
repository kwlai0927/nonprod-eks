{{/*
Common labels
*/}}
{{- define "nextjs.labels" -}}
helm.sh/chart: {{ printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | replace "." "-" | trunc 63 | trimSuffix "-" }}
app.kubernetes.io/version: {{ .Chart.AppVersion }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/part-of: {{ .Chart.Annotations.project }}
app.kubernetes.io/name: {{ .Chart.Annotations.repository }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Selector labels for nextjs
*/}}
{{- define "nextjs.selectorLabels" -}}
{{- include "nextjs.labels" . }}
app.kubernetes.io/component: {{ .Chart.Annotations.component }}
{{- end }}
