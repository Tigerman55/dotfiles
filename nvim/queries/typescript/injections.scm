;; extends

(call_expression
  function: (identifier) @_name
  arguments: (template_string) @injection.content
  (#eq? @_name "sql")
  (#set! injection.language "sql")
  (#set! injection.include-children))
