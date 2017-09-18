Definitions.

D = [0-9]

Rules.

{D}+ :
  {token, {integer, TokenLine, list_to_integer(TokenChars)}}.

\+|-|\*|/ :
  {token, {list_to_atom(TokenChars), TokenLine}}.

.|\n :
  skip_token.

Erlang code.
