; Highlight HTML/CSS used in template string literals
; matches opening and closing tags
(
  (template_string) @html
  (#match? @html "\\<.*\\>.*\\</.*\\>")
)
