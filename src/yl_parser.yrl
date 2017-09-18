Nonterminals grammar expression.

Terminals integer '+' '-' '*' '/'.

Rootsymbol grammar.

Endsymbol '$end'.

Left 1 '+'.
Left 1 '-'.
Left 2 '*'.
Left 2 '/'.

grammar -> expression grammar : [ '$1' | '$2' ].
grammar -> expression : [ '$1' ].

expression -> expression '*' expression : {'$2', '$1', '$3'}.
expression -> expression '/' expression : {'$2', '$1', '$3'}.
expression -> expression '+' expression : {'$2', '$1', '$3'}.
expression -> expression '-' expression : {'$2', '$1', '$3'}.
expression -> integer : '$1'.

Erlang code.
