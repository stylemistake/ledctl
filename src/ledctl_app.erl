-module(ledctl_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
	Led_pid = ledctl_led:start(),
	elli:start_link([
		{callback, ledctl_elli},
		{callback_args, [
			{led_pid, Led_pid}
		]},
		{port, 8532}
	]),

	io:format("ledctl: server started~n"),
	ledctl_sup:start_link().

stop(_State) ->
	ok.
