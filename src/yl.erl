-module(yl).

%% API exports
-export([main/1]).

%%====================================================================
%% API functions
%%====================================================================

%% escript Entry point
main(_Args) ->
    {ok, Content} = file:read_file('test.yl'),
    ListContent = binary:bin_to_list(Content),
    {ok, Tokens, _LastLine} = yl_tokenizer:string(ListContent),
    io:format("~p~n", [Tokens]),
    {ok, Parsed} = yl_parser:parse(Tokens),
    io:format("~p~n", [Parsed]),
    {ok, Mod, Binary} = yl_codegen:generate(Parsed),
    io:format("~p~n", [Mod]),
    code:load_binary(Mod, 'test.yl', Binary),
    io:format("~p~n", ['Yl':run()]),
    erlang:halt(0).

%%====================================================================
%% Internal functions
%%====================================================================
