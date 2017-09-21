-module(yl_codegen).
-export([generate/1]).

generate(Parsed) ->
  compile:forms(code(Parsed)).

code({module, {upper_identifier, Line, Name}, Body}) ->
  Functions = lists:filter(fun is_function_declaration/1, Body),
  Arities = lists:map(fun arity/1, Functions),
  Declarations = lists:map(fun function_declaration/1, Functions),
  [
    {attribute, Line, module, Name},
    {attribute, Line, export, Arities}
    | Declarations
  ].

is_function_declaration({declaration, _, _, _}) -> true;
is_function_declaration(_) -> false.

arity({declaration, {lower_identifier, _Line, Name}, Formals, _Body}) -> {Name, length(Formals)}.

function_declaration({declaration, {lower_identifier, Line, Name}, Formals, Body}) ->
  {function, Line, Name, length(Formals), [
    {clause, Line, lists:map(fun argument/1, Formals), [], [expression_code(Body, Formals)]}
  ]}.

argument({lower_identifier, Line, Name}) ->
  {var, Line, Name}.

expression_code({integer, Line, Value}, _Formals) ->
  {integer, Line, Value};
expression_code({{Op, Line}, A, B}, Formals) ->
  {op, Line, Op, expression_code(A, Formals), expression_code(B, Formals)};
expression_code({pair, {_, Line}, Expr1, Expr2}, Formals) ->
  {tuple, Line, [expression_code(Expr1, Formals), expression_code(Expr2, Formals)]};
expression_code({call, {call, {lower_identifier, Line, Value}, []}, Args}, Formals) ->
  {call, Line, {atom, Line, Value}, lists:map(fun(Arg) -> expression_code(Arg, Formals) end, Args)};
expression_code({call, {lower_identifier, Line, Value}, []}, Formals) ->
  case is_formal(Value, Formals) of
    true -> {var, Line, Value};
    false -> {call, Line, {atom, Line, Value}, []}
  end.

is_formal(Name, Formals) ->
  lists:any(fun({lower_identifier, _Line, Name2}) -> Name == Name2 end, Formals).
