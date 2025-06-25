{{/*
srv.name
*/}}
{{- define "srv.name" -}}
{{- .Chart.Annotations.repository }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "srv.labels" -}}
helm.sh/chart: {{ printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | replace "." "-" | trunc 63 | trimSuffix "-" }}
app.kubernetes.io/version: {{ .Chart.AppVersion }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/part-of: {{ .Chart.Annotations.project }}
app.kubernetes.io/name: {{ .Chart.Annotations.repository }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Selector labels for srv
*/}}
{{- define "srv.selectorLabels" -}}
{{- include "srv.labels" . }}
app.kubernetes.io/component: {{ .Chart.Annotations.component }}
{{- end }}