Nonterminals grammar module_declaration module_body declaration expression call_list formals.

Terminals upper_identifier lower_identifier integer module where '=' '+' '-' '*' '/' ';' '(' ')' '{' '}' ','.

Rootsymbol grammar.

Endsymbol '$end'.

Left 1 '+'.
Left 1 '-'.
Left 2 '*'.
Left 2 '/'.

grammar -> module_declaration : '$1'.

module_declaration -> module upper_identifier where module_body : {module, '$2', '$4'}.

module_body -> declaration module_body : ['$1' | '$2'].
module_body -> ';' module_body : '$2'.
module_body -> declaration : ['$1'].

declaration -> lower_identifier '=' expression ';' : {declaration, '$1', [], '$3'}.
declaration -> lower_identifier formals '=' expression ';' : {declaration, '$1', '$2', '$4'}.

formals -> lower_identifier formals : ['$1' | '$2'].
formals -> lower_identifier : ['$1'].

expression -> expression '*' expression : {'$2', '$1', '$3'}.
expression -> expression '/' expression : {'$2', '$1', '$3'}.
expression -> expression '+' expression : {'$2', '$1', '$3'}.
expression -> expression '-' expression : {'$2', '$1', '$3'}.
expression -> integer : '$1'.
expression -> lower_identifier : {call, '$1', []}.
expression -> lower_identifier call_list : {call, '$1', '$2'}.
expression -> '(' expression ')' : '$2'.
expression -> '{' expression ',' expression '}' : {pair, '$1', '$2', '$4'}.

call_list -> expression : ['$1'].
call_list -> expression call_list : ['$1' | '$2'].

Erlang code.
