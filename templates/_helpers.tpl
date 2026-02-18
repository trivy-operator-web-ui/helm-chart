{{/*
COMMON
*/}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "trivy-operator-web-ui.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
OPERATOR
*/}}

{{/*
Expand the name of the chart.
*/}}
{{- define "trivy-operator-web-ui-operator.name" -}}
{{- printf "%s-operator" .Chart.Name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "trivy-operator-web-ui-operator.labels" -}}
helm.sh/chart: {{ include "trivy-operator-web-ui.chart" . }}
{{ include "trivy-operator-web-ui-operator.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "trivy-operator-web-ui-operator.selectorLabels" -}}
app.kubernetes.io/name: {{ include "trivy-operator-web-ui-operator.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: "operator"
{{- end }}

{{/*
FRONTEND
*/}}

{{/*
Expand the name of the chart.
*/}}
{{- define "trivy-operator-web-ui-frontend.name" -}}
{{- printf "%s-frontend" .Chart.Name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "trivy-operator-web-ui-frontend.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "trivy-operator-web-ui-frontend.labels" -}}
helm.sh/chart: {{ include "trivy-operator-web-ui.chart" . }}
{{ include "trivy-operator-web-ui-frontend.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "trivy-operator-web-ui-frontend.selectorLabels" -}}
app.kubernetes.io/name: {{ include "trivy-operator-web-ui-frontend.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: "frontend"
{{- end }}