-module(yl_codegen).
-export([generate/1]).

generate(Parsed) ->
  compile:forms(code(Parsed)).

code({module, {upper_identifier, Line, Name}, Body}) ->
  Arities = lists:map(fun arity/1, Body),
  Declarations = lists:map(fun function_declaration/1, Body),
  [
    {attribute, Line, module, Name},
    {attribute, Line, export, Arities}
    | Declarations
  ].

arity({declaration, {lower_identifier, _Line, Name}, _Body}) -> {Name, 0}.

function_declaration({declaration, {lower_identifier, Line, Name}, Body}) ->
  {function, Line, Name, 0, [
    {clause, Line, [], [], [expression_code(Body)]}
  ]}.

expression_code({integer, Line, Value}) ->
  {integer, Line, Value};
expression_code({{Op, Line}, A, B}) ->
  {op, Line, Op, expression_code(A), expression_code(B)};
expression_code({call, {lower_identifier, Line, Value}}) ->
  {call, Line, {atom, Line, Value}, []}.
