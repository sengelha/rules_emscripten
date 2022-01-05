# Changelog
{{ range .Versions }}
<a name="{{ replace .Tag.Name "release-" "" 1 }}"></a>
## {{ if .Tag.Previous }}[{{ replace .Tag.Name "release-" "" 1 }}]({{ $.Info.RepositoryURL }}/compare/{{ .Tag.Previous.Name }}...{{ .Tag.Name }}){{ else }}{{ replace .Tag.Name "release-" "" 1 }}{{ end }} ({{ datetime "2006-01-02" .Tag.Date }})
{{ range .CommitGroups -}}
### {{ .Title }}

{{ range .Commits -}}
* {{ if .Scope }}**{{ .Scope }}:** {{ end }}{{ .Subject }}
{{ end }}
{{ end -}}

{{- if .NoteGroups -}}
{{ range .NoteGroups -}}
### {{ .Title }}

{{ range .Notes }}
{{ .Body }}
{{ end }}
{{ end -}}
{{ end -}}
{{ end -}}