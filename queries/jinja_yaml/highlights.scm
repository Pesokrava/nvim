; Jinja delimiters
(block_begin) @punctuation.special
(block_end) @punctuation.special
(variable_begin) @punctuation.special
(variable_end) @punctuation.special

; Jinja tag names — built-in keywords
(_ (block_begin) (tag_name) @keyword)

; Jinja control flow keywords
[
  "for"
  "in"
  "if"
  "else"
  "is"
] @keyword

(jinja_for recursive: _ @keyword)

; Jinja keyword operators
[
  "and"
  "or"
  "not"
  "not in"
  "is not"
] @keyword.operator

; Symbolic operators
[
  "-"
  "!="
  "*"
  "**"
  "/"
  "//"
  "&"
  "%"
  "^"
  "+"
  "<"
  "<<"
  "<="
  "<>"
  "="
  ">"
  ">="
  ">>"
  "|"
  "~"
] @operator

; Function calls
(call
  function: (identifier) @function.call)
(call
  function: (attribute attribute: (identifier) @function.method.call))

; Filter calls (pipe operator)
(filter_call
  name: (filter_name) @function.call)

; Macro definitions
(jinja_macro
  name: (identifier) @function)

; Generic tag names — custom directives
(jinja_tag
  name: (identifier) @keyword.directive)

; Identifiers
(identifier) @variable
(attribute attribute: (identifier) @variable.member)

; Parameters
(default_parameter
  name: (identifier) @variable.parameter)
(parameter (identifier) @variable.parameter)
(keyword_argument
  name: (identifier) @variable.parameter)

; Literals
[
  (none)
  (true)
  (false)
] @constant.builtin

(integer) @number
(float) @number.float

(string) @string
(escape_sequence) @string.escape

; Jinja comments
(comment) @comment

; YAML constructs
(yaml_document_separator) @punctuation.special
(yaml_directive) @keyword.directive
(yaml_comment) @comment
(yaml_key) @property

; Template data (raw text between Jinja tags)
(template_data) @none
