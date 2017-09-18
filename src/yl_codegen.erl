-module(yl_codegen).
-export([generate/1]).

generate(Parsed) ->
  compile:forms([
    {attribute, 0, module, 'Yl'},
    {attribute, 0, export, [{run, 0}]},
    {function, 0, run, 0, [
      {clause, 0, [], [], lists:map(fun(X) -> code(X) end, Parsed)}
    ]}
  ]).

code({integer, Line, Value}) ->
  {integer, Line, Value};
code({{Op, Line}, A, B}) ->
  {op, Line, Op, code(A), code(B)}.
