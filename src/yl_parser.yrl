Nonterminals grammar module_declaration module_body declaration expression formals type_spec call_expression
operator_expression operator.

Terminals upper_identifier lower_identifier integer string module where type '=' '+' '-' '*' '/' ';' '(' ')' '{' '}' ','
'|' ':'.

Rootsymbol grammar.

Endsymbol '$end'.

Left 1 '+'.
Left 1 '-'.
Left 2 '*'.
Left 2 '/'.
Left 3 '|'.
Left 4 ','.

grammar -> module_declaration : '$1'.

module_declaration -> module upper_identifier where module_body : {module, '$2', '$4'}.

module_body -> declaration module_body : ['$1' | '$2'].
module_body -> ';' module_body : '$2'.
module_body -> declaration : ['$1'].

declaration -> lower_identifier '=' operator_expression ';' : {declaration, '$1', [], '$3'}.
declaration -> lower_identifier formals '=' operator_expression ';' : {declaration, '$1', '$2', '$4'}.
declaration -> type upper_identifier '=' type_spec ';' : {type, '$2', '$4'}.
declaration -> lower_identifier ':' type_spec ';' : {type_annotation, '$1', '$3'}.

type_spec -> upper_identifier : element(3, '$1').
type_spec -> type_spec '|' type_spec : {'or', '$1', '$3'}.
type_spec -> '{' type_spec ',' type_spec '}' : {pair, '$2', '$4'}.

formals -> lower_identifier formals : ['$1' | '$2'].
formals -> lower_identifier : ['$1'].

operator_expression -> call_expression : '$1'.
operator_expression -> call_expression operator operator_expression : {'$2', '$1', '$3'}.

operator -> '+' : '$1'.
operator -> '*' : '$1'.
operator -> '/' : '$1'.
operator -> '-' : '$1'.

call_expression -> expression : '$1'.
call_expression -> call_expression expression : {call, '$1', '$2'}.

expression -> integer : '$1'.
expression -> string : '$1'.
expression -> '(' operator_expression ')' : '$2'.
expression -> '{' operator_expression ',' operator_expression '}' : {pair, '$2', '$4'}.
expression -> lower_identifier : '$1'.

Erlang code.
