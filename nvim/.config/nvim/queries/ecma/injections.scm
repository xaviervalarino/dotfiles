; Highlight HTML/CSS used in template string literals
; matches opening and closing tags
((template_string) @html
  (#match? @html "\\<.*\\>.*\\</.*\\>")
  (#offset! @html 0 1 0 -1))
