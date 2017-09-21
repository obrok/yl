-module(yl_typechecker).
-export([typecheck/1]).

typecheck(AST) -> {ok, typecheck(AST, starting_environment())}.

typecheck({module, _, Body}, Environment) ->
  lists:foldl(fun(X, Env) -> typecheck(X, Env) end, Environment, Body);
typecheck({declaration, {lower_identifier, _, Name}, _Formals, Body}, Environment) ->
  add(Environment, Name, typecheck(Body, Environment));
typecheck({integer, _, _}, _Environment) ->
  'Integer';
typecheck({pair, _, A, B}, Environment) ->
  {typecheck(A, Environment), typecheck(B, Environment)}.

starting_environment() -> [#{}].

add([CurrentContext | Rest], Name, Type) ->
  [maps:put(Name, Type, CurrentContext) | Rest].
