Definitions.

D = [0-9]
UpperIdent = [A-Z]
LowerIdent = [a-z_]
Ident = [A-Za-z0-9_]
Keyword = module|where|type
StringContent = [^"\\]
EscapedQuote = \\"
EscapedBackslash = \\\\

Rules.

{Keyword} :
  {token, {list_to_atom(TokenChars), TokenLine}}.

{D}+ :
  {token, {integer, TokenLine, list_to_integer(TokenChars)}}.

{UpperIdent}{Ident}* :
  {token, {upper_identifier, TokenLine, list_to_atom(TokenChars)}}.

{LowerIdent}{Ident}* :
  {token, {lower_identifier, TokenLine, list_to_atom(TokenChars)}}.

"({StringContent}|{EscapedQuote}|{EscapedBackslash})*" :
  {token, {string, TokenLine, list_to_binary(unescape(string:slice(TokenChars, 1, length(TokenChars) - 2)))}}.

=|\+|-|\*|/|\(|\)|;|\{|\}|,|\||\: :
  {token, {list_to_atom(TokenChars), TokenLine}}.

\s|\n|\t :
  skip_token.

Erlang code.

unescape(String) ->
  String2 = string:replace(String, "\\\"", "\"", all),
  string:replace(String2, "\\\\", "\\", all).
