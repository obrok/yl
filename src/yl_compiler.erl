-module(yl_compiler).

-export([compile/1]).

compile(InputBinary) ->
  ListContent = binary:bin_to_list(InputBinary),
  {ok, Tokens, _LastLine} = yl_tokenizer:string(ListContent),
  io:format("~p~n", [Tokens]),
  {ok, Parsed} = yl_parser:parse(Tokens),
  io:format("~p~n", [Parsed]),
  {ok, Mod, Binary} = yl_codegen:generate(Parsed),
  io:format("~p~n", [Mod]),
  code:load_binary(Mod, 'test.yl', Binary),
  {ok, Mod}.
