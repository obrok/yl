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

arity({declaration, {lower_identifier, _Line, Name}, _Formals, _Body}) -> {Name, 0}.

function_declaration({declaration, {lower_identifier, Line, Name}, Formals, Body}) ->
  {function, Line, Name, 0, [
    {clause, Line, [], [], [curry(Formals, expression_code(Body, Formals), Line)]}
  ]}.

curry([], Code, _Line) -> Code;
curry([First | Rest], Code, Line) ->
  {'fun', Line, {clauses, [
    {clause, Line, [argument(First)], [], [curry(Rest, Code, Line)]}]}}.

argument({lower_identifier, Line, Name}) ->
  {var, Line, Name}.

expression_code({integer, Line, Value}, _Formals) ->
  {integer, Line, Value};
expression_code({{Op, Line}, A, B}, Formals) ->
  {op, Line, Op, expression_code(A, Formals), expression_code(B, Formals)};
expression_code({pair, {_, Line}, Expr1, Expr2}, Formals) ->
  {tuple, Line, [expression_code(Expr1, Formals), expression_code(Expr2, Formals)]};
expression_code({call, Fun, Arg}, Formals) ->
  {call, 0, expression_code(Fun, Formals), [expression_code(Arg, Formals)]};
expression_code({lower_identifier, Line, Value}, Formals) ->
  case is_formal(Value, Formals) of
    true -> {var, Line, Value};
    false -> {call, Line, {atom, Line, Value}, []}
  end.

is_formal(Name, Formals) ->
  lists:any(fun({lower_identifier, _Line, Name2}) -> Name == Name2 end, Formals).
