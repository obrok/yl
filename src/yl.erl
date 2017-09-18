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
    erlang:halt(0).

%%====================================================================
%% Internal functions
%%====================================================================
