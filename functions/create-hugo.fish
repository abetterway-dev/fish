# add to hugo.toml
# add main.css in assets/css/main.css
# add "@import "tailwindcss";\n@source "hugo_stats.json"\n
# in layouts/_partials/css.html
# ##
# {{ with resources.Get "css/main.css" }}
  # {{ $opts := dict "minify" (not hugo.IsDevelopment) }}
  # {{ with . | css.TailwindCSS $opts }}
  #   {{ if hugo.IsDevelopment }}
  #     <link rel="stylesheet" href="{{ .RelPermalink }}">
  #   {{ else }}
  #     {{ with . | fingerprint }}
  #       <link rel="stylesheet" href="{{ .RelPermalink }}" integrity="{{ .Data.Integrity }}" crossorigin="anonymous">
  #     {{ end }}
  #   {{ end }}
  # {{ end }}
# {{ end }}
# ##
# When setting up /layouts/baseof.html
# ###
# {{ with (templates.Defer (dict "key" "global")) }}
#   {{ partial "css.html" . }}
# {{ end }}
###
# baseof.html
# <!doctype html>
# <html lang="{{ site.Language.LanguageCode }}" dir="ltr">
#     <head>
#         <meta charset="utf-8" />
#         <meta name="viewport" content="width=device-width, initial-scale=1" />
#         <title>
#             {{- if .IsHome -}} {{ site.Title }} {{- else -}} {{ with .Title }}{{
#             . }} | {{ end }}{{ site.Title }} {{- end -}}
#         </title>
#         {{ block "head" . }}
#         <meta
#             name="description"
#             content="{{ with .Description }}{{ . }}{{ else }}{{ .Summary }}{{ end }}"
#         />
#         <link rel="canonical" href="{{ .Permalink }}" />
#         {{ end }} {{ with (templates.Defer (dict "key" "global")) }} {{ partial
#         "css.html" . }} {{ end }}
#         <link
#             rel="stylesheet"
#             href="{{ $css.RelPermalink }}"
#             integrity="{{ $css.Data.Integrity }}"
#         />
#     </head>

#     <body>
#         <main>{{ block "main" . }} {{ end }}</main>

#         {{ $js := resources.Get "js/main.js" | resources.Minify |
#         resources.Fingerprint }}
#         <script
#             src="{{ $js.RelPermalink }}"
#             integrity="{{ $js.Data.Integrity }}"
#             defer
#         ></script>
#         {{ partialCached "analytics.html" . }} {{ block "scripts" . }}{{ end }}
#     </body>
# </html>
