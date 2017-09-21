-module(yl_compiler).

-export([compile/1, parse/1]).

compile(InputBinary) ->
  {ok, Parsed} = parse(InputBinary),
  {ok, Mod, Binary} = yl_codegen:generate(Parsed),
  code:load_binary(Mod, 'test.yl', Binary),
  {ok, Mod}.

parse(Binary) ->
  ListContent = binary:bin_to_list(Binary),
  {ok, Tokens, _LastLine} = yl_tokenizer:string(ListContent),
  yl_parser:parse(Tokens).
