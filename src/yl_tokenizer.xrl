Definitions.

D = [0-9]
UpperIdent = [A-Z]
LowerIdent = [a-z_]
Ident = [A-Za-z0-9_]
Keyword = module|where

Rules.

{Keyword} :
  {token, {list_to_atom(TokenChars), TokenLine}}.

{D}+ :
  {token, {integer, TokenLine, list_to_integer(TokenChars)}}.

{UpperIdent}{Ident}* :
  {token, {upper_identifier, TokenLine, list_to_atom(TokenChars)}}.

{LowerIdent}{Ident}* :
  {token, {lower_identifier, TokenLine, list_to_atom(TokenChars)}}.

=|\+|-|\*|/|\(|\)|; :
  {token, {list_to_atom(TokenChars), TokenLine}}.

\s|\n :
  skip_token.

Erlang code.
