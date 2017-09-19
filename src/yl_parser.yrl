Nonterminals grammar module_declaration module_body declaration expression.

Terminals upper_identifier lower_identifier integer module where '=' '+' '-' '*' '/'.

Rootsymbol grammar.

Endsymbol '$end'.

Left 1 '+'.
Left 1 '-'.
Left 2 '*'.
Left 2 '/'.

grammar -> module_declaration : '$1'.

module_declaration -> module upper_identifier where module_body : {module, '$2', '$4'}.

module_body -> declaration module_body : ['$1' | '$2'].
module_body -> declaration : ['$1'].

declaration -> lower_identifier '=' expression : {declaration, '$1', '$3'}.

expression -> expression '*' expression : {'$2', '$1', '$3'}.
expression -> expression '/' expression : {'$2', '$1', '$3'}.
expression -> expression '+' expression : {'$2', '$1', '$3'}.
expression -> expression '-' expression : {'$2', '$1', '$3'}.
expression -> integer : '$1'.
expression -> lower_identifier : {call, '$1'}.

Erlang code.
