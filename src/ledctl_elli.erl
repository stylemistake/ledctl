-module(ledctl_elli).
-export([ handle/2, handle_event/3 ]).

-include_lib("elli/include/elli.hrl").
-behaviour(elli_handler).

-define( CORS, {<<"Access-Control-Allow-Origin">>, <<"*">>} ).


handle( Req, Args ) ->
	handle( Req#req.method, elli_request:path(Req), Args ).

handle( 'GET', [<<"led">>, Colour], Args ) ->
	Pid = proplists:get_value( led_pid, Args ),
	Result = case Colour of
		<<"r">> -> ledctl_led:send( Pid, "Rgb" );
		<<"g">> -> ledctl_led:send( Pid, "rGb" );
		<<"b">> -> ledctl_led:send( Pid, "rgB" );
		_ -> no_match
	end,
	{ 200, [ ?CORS ], erlang:atom_to_binary( Result, utf8 ) };

handle( _Method, _Path, _Args ) ->
	{ 404, [ ?CORS ], "not_found" }.

handle_event( _Event, _Data, _Args ) ->
	ok.
