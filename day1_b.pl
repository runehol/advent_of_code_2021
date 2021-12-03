:- use_module(library(clpfd)).


file_to_numbers(File, Numbers) :-
    setup_call_cleanup(open(File, read, In),
        stream_lines(In, Numbers),
        close(In)).

read_line(_, end_of_file, []) :- !.

read_line(In, Line, [Num|Numbers]) :-
	Line \== end_of_file,
	number_string(Num, Line),
	stream_lines(In, Numbers).



stream_lines(In, Numbers) :-
    read_line_to_string(In, Line),
	read_line(In, Line, Numbers).

count_up_numbers(Prev, [Num|Numbers], Count, Res) :-
	Num #> Prev,
	Count1 #= Count + 1,
	count_up_numbers(Num, Numbers, Count1, Res).

count_up_numbers(Prev, [Num|Numbers], Count, Res) :-
	Num #=< Prev,
	count_up_numbers(Num, Numbers, Count, Res).

count_up_numbers(_, [], Count, Count).



sliding_sum3_helper(_, _, [], []).
sliding_sum3_helper(N0, N1, [N2|Numbers], [Sum|Sums]) :-
	Sum #= N0 + N1 + N2,
	sliding_sum3_helper(N1, N2, Numbers, Sums).

sliding_sum3([N0, N1|Numbers], Sums) :-
	sliding_sum3_helper(N0, N1, Numbers, Sums).

main :-
	file_to_numbers("day1_input.txt", Numbers),
	sliding_sum3(Numbers, Sums),
	Sums = [N|Rest],
	count_up_numbers(N, Rest, 0, Count),
	writeln(Count).
