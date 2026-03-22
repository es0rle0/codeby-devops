{{- define "codebywp.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "codebywp.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name (include "codebywp.name" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{- define "codebywp.labels" -}}
app.kubernetes.io/name: {{ include "codebywp.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: Helm
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version | replace "+" "_" }}
{{- end -}}

{{- define "codebywp.mysql.fullname" -}}
{{ include "codebywp.fullname" . }}-mysql
{{- end -}}

{{- define "codebywp.wp.fullname" -}}
{{ include "codebywp.fullname" . }}-wordpress
{{- end -}}

{{- define "codebywp.secretName" -}}
{{- if .Values.secrets.existingSecret.enabled -}}
{{- .Values.secrets.existingSecret.name -}}
{{- else -}}
{{- printf "%s-secret" (include "codebywp.fullname" .) -}}
{{- end -}}
{{- end -}}
