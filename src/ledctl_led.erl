-module(ledctl_led).
-export([ start/0, listener/1, send/2 ]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start() ->
	Serial = serial:start([ {open, "/dev/ttyUSB0"}, {speed, 9600} ]),
	Pid = spawn( ?MODULE, listener, [ Serial ] ),
	Pid.

listener( Serial ) ->
	receive
		{ led, Msg } -> Serial ! { send, Msg };
		_ -> ok
	end,
	listener( Serial ).

send( Pid, Msg ) ->
	Pid ! { led, Msg },
	ok.