-module(yl_compiler).

-export([compile/1]).

compile(InputBinary) ->
  ListContent = binary:bin_to_list(InputBinary),
  {ok, Tokens, _LastLine} = yl_tokenizer:string(ListContent),
  {ok, Parsed} = yl_parser:parse(Tokens),
  {ok, Mod, Binary} = yl_codegen:generate(Parsed),
  code:load_binary(Mod, 'test.yl', Binary),
  {ok, Mod}.
