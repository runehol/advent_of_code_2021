:- use_module(library(clpfd)).

read_line(_, end_of_file, []) :- !.

read_line(In, Line, [Command|Commands]) :-
	Line \== end_of_file,
	split_string(Line, " ", "", [CmdTxt, ValueTxt]),
	atom_string(Cmd, CmdTxt),
	number_string(Value, ValueTxt),
	Command = (Cmd, Value),
	stream_lines(In, Commands).





stream_lines(In, Numbers) :-
    read_line_to_string(In, Line),
	read_line(In, Line, Numbers).

file_to_commands(File, Numbers) :-
    setup_call_cleanup(open(File, read, In),
        stream_lines(In, Numbers),
        close(In)).

submarine_position([], H, V, Aim, H, V, Aim).

submarine_position([(forward, Amount)|Rest], H, V, Aim, ResH, ResV, ResAim) :-
	H1 #= H + Amount,
	V1 #= V + Aim*Amount,
	submarine_position(Rest, H1, V1, Aim, ResH, ResV, ResAim).

submarine_position([(up, Amount)|Rest], H, V, Aim, ResH, ResV, ResAim) :-
	Aim1 #= Aim - Amount,
	submarine_position(Rest, H, V, Aim1, ResH, ResV, ResAim).

submarine_position([(down, Amount)|Rest], H, V, Aim, ResH, ResV, ResAim) :-
	Aim1 #= Aim + Amount,
	submarine_position(Rest, H, V, Aim1, ResH, ResV, ResAim).

main :-
	file_to_commands("day2_input.txt", Commands),
	submarine_position(Commands, 0, 0, 0, H, V, _),
	Prod #= H*V,
	writeln(Prod).
