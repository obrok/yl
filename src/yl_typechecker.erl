-module(yl_typechecker).
-export([typecheck/1]).

typecheck(AST) ->
  case typecheck(AST, starting_environment()) of
    {[TopContext | _Rest], Errors} when map_size(Errors) == 0 -> {ok, TopContext};
    {_, Errors} -> {error, Errors}
  end.

typecheck({module, _, Body}, Environment) ->
  lists:foldl(fun(X, Env) -> typecheck(X, Env) end, Environment, Body);
typecheck({declaration, {lower_identifier, _, Name}, _Formals, Body}, Environment) ->
  add(Environment, Name, typecheck(Body, Environment));
typecheck({type_annotation, {lower_identifier, _, Name}, Type}, Environment) ->
  add(Environment, Name, Type);
typecheck({integer, _, _}, _Environment) ->
  'Integer';
typecheck({string, _, _}, _Environment) ->
  'String';
typecheck({lower_identifier, _, Name}, _Environment) ->
  {var, Name};
typecheck({pair, A, B}, Environment) ->
  {pair, typecheck(A, Environment), typecheck(B, Environment)}.

add({[CurrentContext | Rest], Errors}, Name, Type) ->
  case maps:get(Name, CurrentContext, not_found) of
    not_found -> {[maps:put(Name, Type, CurrentContext) | Rest], Errors};
    Type -> {[CurrentContext | Rest], Errors};
    Other -> {[CurrentContext | Rest], maps:put(Name, {conflict, [Other, Type]}, Errors)}
  end.

starting_environment() -> {[#{}], #{}}.
