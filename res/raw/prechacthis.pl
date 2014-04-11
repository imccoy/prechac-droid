flatten(List, FlatList) :-
  flatten(List, [], FlatList0), !,
  FlatList = FlatList0.

flatten(Var, Tl, [Var|Tl]) :-
  var(Var), !.
flatten([], Tl, Tl) :- !.
flatten([Hd|Tl], Tail, List) :- !,
  flatten(Hd, FlatHeadTail, List),
  flatten(Tl, Tail, FlatHeadTail).
flatten(NonList, Tl, [NonList|Tl]).

sum_list(Xs, Sum) :-
  sum_list(Xs, 0, Sum).

sum_list([], Sum, Sum).
sum_list([X|Xs], Sum0, Sum) :-
  Sum1 is Sum0 + X,
  sum_list(Xs, Sum1, Sum).

member(El, [H|T]) :-
    member_(T, El, H).

member_(_, El, El).
member_([H|T], El, _) :-
    member_(T, El, H).


append([], L, L).
append([H|T], L, [H|R]) :-
  append(T, L, R).


select(X, [X|Tail], Tail).
select(Elem, [Head|Tail], [Head|Rest]) :-
  select(Elem, Tail, Rest).
  

permutation(Xs, Ys) :-
  '$skip_list'(Xlen, Xs, XTail),
  '$skip_list'(Ylen, Ys, YTail),
  (   XTail == [], YTail == []    % both proper lists
  ->  Xlen == Ylen
  ;   var(XTail), YTail == []   % partial, proper
  ->  length(Xs, Ylen)
  ;   XTail == [], var(YTail)   % proper, partial
  ->  length(Ys, Xlen)
  ;   var(XTail), var(YTail)    % partial, partial
  ->  length(Xs, Len),
      length(Ys, Len)
  ;   must_be(list, Xs),      % either is not a list
      must_be(list, Ys)
  ),
  perm(Xs, Ys).

perm([], []).
perm(List, [First|Perm]) :-
        select(First, List, Rest),
        perm(Rest, Perm).




%%%  --- list operations ---

changeDimension([], [], []) :- !.
changeDimension([X|XList], [Y|YList], [[X,Y]|XYList]) :-
	changeDimension(XList, YList, XYList).
	

allMembersUnique([]) :- !.
allMembersUnique([Head | Tail]) :-
   var(Head),!,
   allMembersUnique(Tail).
allMembersUnique([Head | Tail]) :-
   nonvar(Head),
   forall(member(X, Tail), (var(X);(nonvar(X),Head\=X))),
   allMembersUnique(Tail).

firstVar0([Var|_List], 0) :-
	var(Var), !.
firstVar0([_NonVar|List], Pos1) :-
	firstVar0(List, Pos),
	Pos1 is Pos + 1.

firstNoGround0([Var|_List], 0) :-
	not(ground(Var)), !.
firstNoGround0([_NonVar|List], Pos1) :-
	firstNoGround0(List, Pos),
	Pos1 is Pos + 1.

justVars([]) :- !.
justVars([Var|Vars]) :-
	var(Var),
	justVars(Vars).


positionsInList(List, Object, Positions) :-
	positionsInList(List, Object, 0, Positions).
positionsInList([], _, _, []) :- !.
positionsInList([Object|Tail], Object, Pos, [Pos|Positions]) :-
	!,
	nextPos(Pos, NextPos),
	positionsInList(Tail, Object, NextPos, Positions).
positionsInList([InnerList|List], Object, Pos, PosList) :-
	is_list(InnerList), !,
	nextPos(Pos, PosInner, inner),
	positionsInList(InnerList, Object, PosInner, InnerPosList),
	nextPos(Pos, NextPos),
	positionsInList(List, Object, NextPos, NextPosList),
	append(InnerPosList, NextPosList, PosList).
positionsInList([_Object|Tail], Object, Pos, Positions) :-	
	nextPos(Pos, NextPos),
	positionsInList(Tail, Object, NextPos, Positions).

nextPos(Pos, NextPos) :-
	number(Pos), !,
	NextPos is Pos + 1.
nextPos(Pos, NextPos) :-
	is_list(Pos),
	length(Pos, Length),
	Length0 is Length - 1,
	nth0(Length0, Pos, Last),
	NextLast is Last + 1,
	changeOnePosition(Pos, Length0, NextLast, NextPos).
nextPos(Pos, NextPos, inner) :- 
	number(Pos), !,
	nextPos([Pos], NextPos, inner).
nextPos(Pos, NextPos, inner) :-
	is_list(Pos), !,
	append(Pos, [0], NextPos).


% !!! Multiplex ToDo
nth0List([], _, []) :- !.
nth0List([Pos|PosList], List, [X|Xs]) :-
	nth0(Pos, List, X),
	nth0List(PosList, List, Xs).

nth0ListOfLists(Pos, List, X) :-
	number(Pos), !,
	nth0(Pos, List, X).
nth0ListOfLists([Pos], List, X) :-
	number(Pos), !,
	nth0(Pos, List, X).
nth0ListOfLists([Pos|Positions], List, X) :-
	nth0(Pos, List, InnerList),
	nth0ListOfLists(Positions, InnerList, X).

changeOnePosition(List, Pos, X, NewList) :-
	number(Pos), !,
	changeOnePosition(List, [Pos], X, NewList).
changeOnePosition(List, [Pos], X, NewList) :-
	number(Pos), !,
	length(List, Length),
	length(NewList, Length),
	PreLength is Pos,
	PostLength is Length - Pos - 1,
	length(PreList, PreLength),
	length(PostList, PostLength),
	append(PreList, _, List),
	append(_, PostList, List),
	append(PreList, _, NewList),
	append(_, PostList, NewList),
	nth0(Pos, NewList, X).
changeOnePosition(List, [Pos|Positions], X, NewList) :-
	length(List, Length),
	length(NewList, Length),
	PreLength is Pos,
	PostLength is Length - Pos - 1,
	length(PreList, PreLength),
	length(PostList, PostLength),
	append(PreList, _, List),
	append(_, PostList, List),
	append(PreList, _, NewList),
	append(_, PostList, NewList),
	nth0(Pos, List, InnerList),
	changeOnePosition(InnerList, Positions, X, NewInnerList),
	nth0(Pos, NewList, NewInnerList).
	


changePositions(List, [], _X, List) :- !.
changePositions(List, [Pos|Positions], X, NewList) :-
	changePositions(List, Positions, X, TmpList),
	changeOnePosition(TmpList, Pos, X, NewList).
	

posList(List, PosList) :- 
	posList(List, [0], PosList), !.
posList([], _Pos, []) :- !.
posList([InnerList|List], Pos, PosList) :-
	is_list(InnerList),!,
	append(Pos, [0], InnerPos),
	posList(InnerList, InnerPos, InnerPosList),
	length(Pos, Length),
	Length0 is Length - 1,
	nth0(Length0, Pos, EndPos),
	NextEndPos is EndPos + 1,
	changeOnePosition(Pos, Length0, NextEndPos, NextPos),	
	posList(List, NextPos, NextPosList),
	append(InnerPosList, NextPosList, PosList).
posList([_X|List], Pos, [Pos|PosList]) :-	
	length(Pos, Length),
	Length0 is Length - 1,
	nth0(Length0, Pos, EndPos),
	NextEndPos is EndPos + 1,
	changeOnePosition(Pos, Length0, NextEndPos, NextPos),	
	posList(List, NextPos, PosList).


%% fillIn(Original, Copy, StartingPosition, ListOfNotChangingPositions)
fillIn([],[], _, _) :- !.
fillIn( [_Orig_Head | Orig_Rest], [_Copy_Head | Copy_Rest], Position, DontChange) :-
   member(Position, DontChange),!,
   NextPosition is Position + 1,
   fillIn(Orig_Rest, Copy_Rest, NextPosition, DontChange).
fillIn( [Orig_Head | Orig_Rest], [Copy_Head | Copy_Rest], Position, DontChange) :-
   nonvar(Orig_Head),!,
   Copy_Head = Orig_Head,
   NextPosition is Position + 1,
   fillIn(Orig_Rest, Copy_Rest, NextPosition, DontChange).
fillIn( [Orig_Head | Orig_Rest], [_ | Copy_Rest], Position, DontChange) :-
   var(Orig_Head),!,
   NextPosition is Position + 1,
   fillIn(Orig_Rest, Copy_Rest, NextPosition, DontChange).

fillIn([],[]) :- !.
fillIn( [_Orig_Head | Orig_Rest], [Copy_Head | Copy_Rest]) :-
   nonvar(Copy_Head),
   fillIn(Orig_Rest, Copy_Rest).
fillIn( [Orig_Head | Orig_Rest], [Copy_Head | Copy_Rest]) :-
   var(Copy_Head),
   Copy_Head = Orig_Head,
   fillIn(Orig_Rest, Copy_Rest).


fillInAndCopy([],[],[]) :- !.
fillInAndCopy( [Orig_Multiplex | Orig_Rest], [FillIn_Multiplex | FillIn_Rest], [Copy_Multiplex | Copy_Rest]) :-
   is_list(Orig_Multiplex),!,
   length(Orig_Multiplex, Length),
   length(FillIn_Multiplex, Length),
   length(Copy_Multiplex, Length),
   fillInAndCopy(Orig_Multiplex, FillIn_Multiplex, Copy_Multiplex),
   fillInAndCopy(Orig_Rest, FillIn_Rest, Copy_Rest).
fillInAndCopy( [Orig_Head | Orig_Rest], [_FillIn_Head | FillIn_Rest], [Copy_Head | Copy_Rest]) :-
   nonvar(Orig_Head),!,
   Copy_Head = Orig_Head,
   fillInAndCopy(Orig_Rest, FillIn_Rest, Copy_Rest).
fillInAndCopy( [Orig_Head | Orig_Rest], [FillIn_Head | FillIn_Rest], [Copy_Head | Copy_Rest]) :-
   var(Orig_Head),!,
   Copy_Head = FillIn_Head,
   fillInAndCopy(Orig_Rest, FillIn_Rest, Copy_Rest).
fillInAndCopy( [Orig_Head | Orig_Rest], [FillIn_Head | FillIn_Rest], [_Copy_Head | Copy_Rest]) :- %%%???
   var(Orig_Head),
   var(FillIn_Head),!,
   fillInAndCopy(Orig_Rest, FillIn_Rest, Copy_Rest).

copyList([], []) :- !.
copyList([Head|List], [HeadCopy|ListCopy]) :-
	var(HeadCopy), !,
	HeadCopy = Head,
	copyList(List, ListCopy).
copyList([_Head|List], [_HeadCopy|ListCopy]) :-
	copyList(List, ListCopy).
	
	
copyList_if_smaller([], _Sup, []) :- !.
copyList_if_smaller([Head|Tail], Sup, [Head|TailCopy]) :-
	Head < Sup, !,
	copyList_if_smaller(Tail, Sup, TailCopy).
copyList_if_smaller([_Head|Tail], Sup, TailCopy) :-
	copyList_if_smaller(Tail, Sup, TailCopy).
	
	
copyList_if_bigger([], _Min, []) :- !.
copyList_if_bigger([Head|Tail], Min, [Head|TailCopy]) :-
	Head >= Min, !,
	copyList_if_bigger(Tail, Min, TailCopy).
copyList_if_bigger([_Head|Tail], Min, TailCopy) :-
	copyList_if_bigger(Tail, Min, TailCopy).
	
	
numberOfX([], _, 0) :- !.
numberOfX([Var|Tail], X, Number) :-
	var(Var), !,
 	numberOfX(Tail, X, Number).
numberOfX([X|Tail], X, Number) :-
	!,
	numberOfX(Tail, X, OldNumber),
	Number is OldNumber + 1.
numberOfX([_Y|Tail], X, Number) :-
	numberOfX(Tail, X, Number).

numberOfVars([], 0) :- !.
numberOfVars([Head|Tail], Number) :-
	var(Head), !,
	numberOfVars(Tail, NumberTail),
	Number is NumberTail + 1.
numberOfVars([Head|Tail], Number) :-
	is_list(Head), !,
	numberOfVars(Head, NumberHead),
	numberOfVars(Tail, NumberTail),
	Number is NumberTail + NumberHead.
numberOfVars([_Head|Tail], Number) :-
	numberOfVars(Tail, Number).


multiply(Var, _Factor, _Product) :-
	var(Var), !.
multiply(Number, Factor, Product) :-
	(number(Number); rational(Number)),
	Product is Number * Factor, !.
multiply([], _Factor, []) :- !.
multiply([HeadIn | TailIn], Factor, [HeadOut | TailOut]) :-
   multiply(HeadIn, Factor, HeadOut),
   multiply(TailIn, Factor, TailOut).

add(Var, _Summand, _Sum) :-
	var(Var), !.
add(Number, Summand, Sum) :-
	(number(Number); rational(Number)),
	Sum is Number + Summand, !.
add([Head|Tail], Summand, [NewHead|NewTail]) :-
	add(Head, Summand, NewHead),
	add(Tail, Summand, NewTail), !.
add([], _, []) :- !.

memberOrEqual(X, List) :-
	is_list(List),!,
	member(X, List).
memberOrEqual(X, X) :- !.

memberOrEqual(X, List, Pos) :-
	is_list(List),!,
	nth0(Pos, List, X).
memberOrEqual(X, X, -1) :- !.
	
rotate(List, Rotated) :-
    append(Left, Right, List),
	length(Right,LengthRight),
	LengthRight > 0,
    append(Right, Left, Rotated).

rotate_right([Head|Tail], Rotated) :-
	append(Tail, [Head], Rotated),!.

rotate_left(List, Rotated) :-
	append(Liat, [Daeh], List),
	append([Daeh], Liat, Rotated),!.


sort_list_of_expr(List, Sorted) :-
	predsort(compare_expr,List,Sorted).


infimum(_,[]).
infimum(Inf, [Head|Tail]) :-
	Inf =< Head,
	infimum(Inf, Tail).
	
min_of_list(Min, List) :-
	member(Min, List),
	infimum(Min, List).

supremum(_,[]).
supremum(Sup, [Head|Tail]) :-
	Sup >= Head,
	supremum(Sup, Tail).

max_of_list(Max, List) :-
	member(Max, List),
	supremum(Max, List).


zeros(0, []).
zeros(Length, Zeros) :-
  Length > 0,
  OneShorter is Length - 1,
  zeros(OneShorter, Oneless),
  append([0], Oneless, Zeros).

oneToN(0, []) :- !.
oneToN(Period, OneToN) :-
	PeriodMinus1 is Period - 1,
	oneToN(PeriodMinus1, OldOneToN),
	append(OldOneToN, [Period], OneToN).

	
realSubtract(List, [], List) :- !.	
realSubtract(List, [Head|Delete], Remaining) :-
	removeOnce(List, Head, RemainingForNow),
	realSubtract(RemainingForNow, Delete, Remaining).



%removeOnce([], _, []) :- !.
removeOnce([Head|List], Head, List) :- !.
removeOnce([Head|Tail], Element, [Head|List]) :- 
	removeOnce(Tail, Element, List), !.
	

removeAll([], _Head, []) :- !.
removeAll([Head|List], Head, NewList) :-
    removeAll(List, Head, NewList), !.
removeAll([XHead|List], Head, [XHead|NewList]) :-
    removeAll(List, Head, NewList), !.

listOfNumber(Number, Length, List) :- listOf(Number, Length, List).
listOfNumber(Number, List) :- listOf(Number, List).
	
listOf(X, Length, List) :-
	length(List, Length),
	listOf(X, List).
listOf(_X, []) :- !.
listOf(X, [X|Tail]) :-
	listOf(X, Tail).
	

nth0_gen(Pos, List, X, NewList) :-
	var(List), !,
	length(TmpList, Pos),
	append(TmpList, [X], NewList).
nth0_gen(Pos, List, X, List) :-
	length(List, Length),
	Pos < Length, !,
	nth0(Pos, List, X).
nth0_gen(Pos, List, X, NewList) :-
	length(List, Length),
	Delta is Pos - Length + 1,
	length(AddList, Delta),
	append(List, AddList, NewList),
	nth0(Pos, NewList, X).


%%%  --- number operations ---

compare_expr(=,R1,R2) :- R1 is R2.
compare_expr(>,R1,R2) :- R1 < R2.
compare_expr(<,R1,R2) :- R1 > R2.

even(Int) :-
	0 is Int mod 2.
odd(Int) :- 
	1 is abs(Int) mod 2.

rational_to_number(Number, Number) :-	
	number(Number),!.
rational_to_number(Rational, Number) :-
	rational(Rational),
	Number is float(Rational).
		
substract_var(_Minuend, Subtrahend, _Difference) :-
	var(Subtrahend),!.
substract_var(Minuend, _Subtrahend, _Difference) :-
	var(Minuend),!.
substract_var(Minuend, Subtrahend, Difference) :- 
	Difference is Minuend - Subtrahend.
	
substractUntilNonPositiv(Minuend, _Subtrahend, Minuend) :-
	Minuend =< 0, !.
substractUntilNonPositiv(Minuend, Subtrahend, Difference) :-
	TempDifference is Minuend - Subtrahend,
	substractUntilNonPositiv(TempDifference, Subtrahend, Difference).


betweenRandom(Lower, Upper, X) :-
   n2m_shuffled(Lower, Upper, Shuffled),!,
   member(X, Shuffled).

n2m_shuffled(Lower, Upper, Shuffled) :-
   findall(X, between(Lower, Upper, X), N2M),
   permutationRandom(N2M, Shuffled).

permutationRandom([], []).
permutationRandom([Head | Rest], Shuffled) :-
   permutationRandom(Rest, RestShuffled),
   length(RestShuffled, Length),
   Gaps is Length+1,
   InsertAfter is random(Gaps),
   length(FirstPart, InsertAfter),
   append(FirstPart, SecondPart, RestShuffled),
   append(FirstPart, [Head|SecondPart], Shuffled).

%%% fillPermutation 
%% ?- L = [4, _, 1, _], fillPermutation([1,2,3,4], L).
%% L = [4, 2, 1, 3]
%% L = [4, 3, 1, 2]
%%
%% ?- L = [[4, _], 2, 1, _], fillPermutation([1,1,2,3,4], L).
%% L = [[4,1], 2, 1, 3]
%% L = [[4,3], 2, 1, 1]
%%
fillPermutation(List, Permutation) :-
	flatten(List, FlatList),
	flatten(Permutation, FlatPermutation),
	removeVars(FlatPermutation, DontPermutate),
	realSubtract(FlatList, DontPermutate, DoPermutate),
	permutation(DoPermutate, PermutatedGaps),
	fillInVars(Permutation, PermutatedGaps).
	

fillSetPermutation(Set, Permutation) :-
	is_set(Set),
	removeVars(Permutation, DontPermutate),
	subtract(Set, DontPermutate, DoPermutate),
	permutation(DoPermutate, PermutatedGaps),
	fillInVars(Permutation, PermutatedGaps).
	
removeVars([],[]) :- !.
removeVars([Var|ListWithVars], ListWithoutVars) :-
	var(Var), !,
	removeVars(ListWithVars, ListWithoutVars).
removeVars([NonVar|ListWithVars], [NonVar|ListWithoutVars]) :-
	nonvar(NonVar), !,
	removeVars(ListWithVars, ListWithoutVars).

fillInVars(List, Gaps) :-
	fillInVars(List, Gaps, _), !.



fillInVars([], Gaps, Gaps) :- !.
fillInVars(_, [], []) :- !.
fillInVars([InnerList|ListWithVars], ListOfGaps, RemainingGaps) :-
	is_list(InnerList), !,
	fillInVars(InnerList, ListOfGaps, RemainingGapsFromInnerList),
	fillInVars(ListWithVars, RemainingGapsFromInnerList, RemainingGaps).
fillInVars([NonVar|ListWithVars], ListOfGaps, RemainingGaps) :-
	nonvar(NonVar), !,
	fillInVars(ListWithVars, ListOfGaps, RemainingGaps).
fillInVars([Var|ListWithVars], [Gap|ListOfGaps], RemainingGaps) :-
	var(Var), !,
	Var = Gap,
	fillInVars(ListWithVars, ListOfGaps, RemainingGaps).





%%%%%% ------ replacements ------ %%%%%%


%%% --- findall replacements --- %%%

	
/*** findall_unique_restricted
*
* findall_restricted(X, Goal, Bag, Options)
* Options:
* unique
* time(+Seconds) - max time
* results(+Results) - max number of results
* flag(-Flag) - returns one of {all, some, time}
*
*/	

findall_restricted(X, Goal, Bag, Options) :-
	Session is random(10^10),
	init_findall_restricted(Options, Session),
	post_it_timecheck(X, Goal, Options, Session),
	gather([], Bag, Session).
	

init_findall_restricted([], Session) :- 
	retractall(dataResult(Session, _)),
	(recorded(findall_active, _OtherSession) ->
		true;
		forall(recorded(time_limit_exceeded, _, R), erase(R))
	),
	recorda(findall_active, Session), !.
init_findall_restricted([Option|Options], Session) :-
	init_findall_restricted_option(Option, Session), 
	init_findall_restricted(Options, Session).
init_findall_restricted_option(results(_), Session) :-	
	forall(recorded(findall_result_counter, results(Session, _), Ref), erase(Ref)),
	recorda(findall_result_counter, results(Session, 0)), !.
init_findall_restricted_option(_, _) :- !.

	

post_it_timecheck(X, Goal, Options, Session) :-
	memberchk(time(MaxTime), Options),!,
	catch(
		call_with_time_limit(MaxTime, 
			post_it(X, Goal, Options, Session)
		),
		time_limit_exceeded,
		memberchk(time, Options, [name(flag), optional])
	).
	
post_it_timecheck(X, Goal, Options, Session) :-
	recorded(findall_active, _OtherSession), !,
	catch(
		post_it(X, Goal, Options, Session),
		time_limit_exceeded,
		(
			memberchk(time, Options, [name(flag), optional]),
			recorda(time_limit_exceeded, Session)
		)
	).
post_it_timecheck(X, Goal, Options, Session) :-	
	post_it(X, Goal, Options, Session).


post_it(X, Goal, Options, Session) :- 
	call(Goal),
	not(fail_posting(X, Options, Session)),
	asserta(dataResult(Session, X)),
	stop_posting(Options, Session), !.
post_it(_, _, Options, _Session) :-
	memberchk(all, Options, [name(flag), optional]).


fail_posting(X, Options, Session) :-
	member(Option, Options),
	fail_posting_option(X, Option, Session).
	
fail_posting_option(X, unique, Session) :-
	dataResult(Session, X).
	
stop_posting(Options, Session) :-
	member(Option, Options),
	stop_posting_option(Option, Options, Session), !.
stop_posting(Options, _Session) :-
	recorded(time_limit_exceeded, _S), 
	memberchk(time, Options, [name(flag), optional]), !.
	
stop_posting_option(results(MaxResults), Options, Session) :-
	number(MaxResults),
	recorded(findall_result_counter, results(Session, NumberOfResults), Ref),
	erase(Ref),
	NewNumberOfResults is NumberOfResults + 1,
	recorda(findall_result_counter, results(Session, NewNumberOfResults)),
	NumberOfResults >= MaxResults - 1,
	memberchk(some, Options, [name(flag), optional]).
	
	
gather(B, Bag, Session) :-
	dataResult(Session, X),
	retract(dataResult(Session, X)),
	gather([X|B],Bag, Session),
	!.
gather(S,S, Session) :-
	recorded(findall_active, Session, Rev),
	erase(Rev).




%%% --- member replacements --- %%%

/*** memberchk
* memberchk(X, List, Options)
* Options: 
* name(Name)
* default(Default)
* optional
*/
memberchk(X, List, Options) :-
	select(name(Name), Options, RestOptions),
	Y =.. [Name, X],
	memberchk(Y, List, RestOptions), !.
memberchk(X, List, Options) :-
	not(memberchk(name(_), Options)),
	memberchk(X, List), !.
memberchk(X, _List, Options) :-
	memberchk(default(X), Options), !.
memberchk(_X, _List, Options) :-
	memberchk(optional, Options), !.
	
	

member_restricted(_X, _List, Options) :-
	memberchk(stop_if(Goal), Options),
	call(Goal), !,
	fail.
member_restricted(X, [X|_List], _Options).
member_restricted(X, [_Y|List], Options) :-
	member_restricted(X, List, Options).
	

nth1_restricted(_Pos, _List, _X, Options) :-
	memberchk(stop_if(Goal), Options),
	call(Goal), !,
	fail.
nth1_restricted(1, [X|_List], X, _Options).
nth1_restricted(Pos, [_Y|List], X, Options) :-
	nonvar(Pos),
	Pos1 is Pos - 1,
	nth1_restricted(Pos1, List, X, Options).
nth1_restricted(Pos, [_Y|List], X, Options) :-
	var(Pos),
	nth1_restricted(Pos1, List, X, Options),
	Pos is Pos1 + 1.
	
%%% string operations %%%

remove_whitespace([], []) :- !.
remove_whitespace([White|String], CleanString) :-
	char_type(White, white), !,
	remove_whitespace(String, CleanString).
remove_whitespace([NonWhite|String], [NonWhite|CleanString]) :-
	remove_whitespace(String, CleanString).

%%% sort %%% 

keysort(List, Keys, Sorted) :-
	keys(List, Keys, ListWithKeys),
	keysort(ListWithKeys, SortedWithKeys),
	keys(Sorted, _Keys, SortedWithKeys).

keys([], [], []) :- !.
keys([Head|Tail], [Key|Keys], [Key-Head|TailWithKeys]) :-
	keys(Tail, Keys, TailWithKeys).



%%% convert types %%%
a2Number(A, Number) :-
	a2Number(A, Number, []).
	
a2Number(Number, Number, _Options) :- 
	(number(Number); rational(Number)), !.
a2Number(Atom, Number, Options) :-
	atom(Atom), !,
	name(Atom, List),
	a2Number(List, Number, Options).
a2Number(String, Number, _Options) :-
	is_list(String),
	phrase(dcg_number_neg(Number), String), !.
a2Number(_A, Default, Options) :-
	memberchk(default(Default), Options),
	(number(Default); rational(Default)), !.

a2Atom(Atom, Atom) :-
	atom(Atom), !.
a2Atom(Number, Atom) :-
	number(Number), !,
	atom_number(Atom, Number).
a2Atom(String, Atom) :-
	string(String), !,
	string_to_atom(String, Atom).
a2Atom(List, Atom) :-
	is_list(List), !,
	a2Atom_list(List, ListOfAtoms),
	concat_atom(ListOfAtoms, ',', InnerAtom),
	format(atom(Atom), "[~w]", [InnerAtom]).
a2Atom(X, Atom) :-
	format(atom(Atom), "~w", [X]).
	
a2Atom_list([], []) :- !.
a2Atom_list([A|List], [Atom|ListOfAtoms]) :-
	a2Atom(A, Atom),
	a2Atom_list(List, ListOfAtoms).

a2String(String, String) :-
	string(String), !.
a2String(X, String) :-
	format(string(String), "~w", [X]).
	
	
%% generating integers

integer_gen(Min, Number) :-
	integer_gen(Min, Number, []).

integer_gen(_Min, _Number, Options) :-
	memberchk(stop_if(Goal), Options),
	call(Goal), !,
	fail.
integer_gen(Min, Min, _Options).
integer_gen(Min, Number, Options) :-
	integer_gen(Min, Befor, Options),
	Number is Befor + 1.
	


/* gcd(X,Y,Z) is true if Z is the greatest common divisor of X and Y.      */
gcd(X, X, X) :- 
    X > 0.
gcd(X, Y, G) :- 
    X > Y, 
    plus(Y,X1,X),
    gcd(X1,Y,G).
gcd(X, Y, G):- 
    Y > X,
    plus(X,Y1,Y),
    gcd(X,Y1,G).


lcm(X,Y,LCM) :-
    gcd(X,Y,GCD),
    LCM is abs(X*Y)/GCD.


leastCommonMultipleIsProduct(X, Y) :-
    P is X * Y,
    lcm(X,Y,P).

siteswap(OutputPattern, NumberOfJugglers, Objects, Length, MaxHeight, PassesMin, PassesMax, ContainString, DontContainString, ClubDoesString, ReactString, SyncString, JustString, ContainMagic) :-
	initConstraintCheck,
	constraint(Pattern, Length, NumberOfJugglers, MaxHeight, ContainString, ClubDoesString, ReactString, SyncString, JustString, ContainMagic),
	%preprocessMultiplexes(Pattern),
	constraint_fillable(Pattern, NumberOfJugglers, Objects, MaxHeight),
	siteswap(NumberOfJugglers, Objects, MaxHeight, PassesMin, PassesMax, Pattern),
	catch(
		preprocessConstraint(DontContainString, negativ, Length, NumberOfJugglers, MaxHeight, DontContain),
		constraint_unclear,
		throw(constraint_unclear('"exclude"'))
	),
	forall(member(DontContainPattern, DontContain), dontContainRotation(Pattern, DontContainPattern)),
	orderMultiplexes(Pattern, PatternM),
	rotateHighestFirst(PatternM, OutputPattern).

initConstraintCheck :- 
	retractall(constraintChecked(_)),
	forall(recorded(constraint_fillable, _, R), erase(R)),!.

constraint(Constraint, Length, _Persons, _Max, [], [], [], [], [], 0) :-
	length(Constraint, Length),!.
constraint(Constraint, Length, _Persons, _Max, "", "", "", "", "", 0) :-
	length(Constraint, Length),!.
constraint(Constraint, Length, _Persons, _Max, '', '', '', '', '', 0) :-
	length(Constraint, Length),!.
constraint(Constraint, Length, Persons, Max, Contain, ClubDoes, React, Sync, Just, ContainMagic) :-
	mergeConstraints(Constraint, Length, Persons, Max, Contain, ClubDoes, React, Sync, Just, ContainMagic),
	not(supConstraintChecked(Constraint)),
	asserta(constraintChecked(Constraint)).
constraint(_Constraint, _Length, _Persons, _Max, _Contain, _ClubDoes, _React, _Sync, _Just, _Magic) :-
	recorda(constraint_fillable, false), fail.
	
supConstraintChecked(Constraint) :-
	constraintChecked(SupConstraint),
	isRotatedSubConstraint(Constraint, SupConstraint).
	
constraint_fillable(Constraint, NumberOfJugglers, Objects, MaxHeight) :- 
	averageNumberOfClubs(Constraint, ClubsInConstraintAV),
	length(Constraint, Period),
	numberOfVars(Constraint, NumberOfVars),
	MaxToAddAV is NumberOfVars * MaxHeight / Period,
	Objects =< (ClubsInConstraintAV + MaxToAddAV) * NumberOfJugglers, !,
	recorda(constraint_fillable, true).
constraint_fillable(_Constraint, _NumberOfJugglers, _Objects, _MaxHeight) :-
	recorda(constraint_fillable, false), fail.
	
test_constraint_not_fillable :-	
	findall(B, (recorded(constraint_fillable, B, R), erase(R)), ListOfBool),
	ListOfBool \= [],
	not(
		memberchk(true, ListOfBool)
	), !.
	
	
mergeConstraints(ConstraintRotated, Length, Persons, Max, ContainString, ClubDoesString, ReactString, SyncString, JustString, ContainMagic) :-
	length(MagicPattern, Length),
	(ContainMagic = 1 ->	
		(
			containsMagicOrbit(MagicPattern, Persons, Max)
		);
		true
	),
	catch(
		preprocessConstraint(ContainString, positiv, Length, Persons, Max, ContainConstraints),
		constraint_unclear,
		throw(constraint_unclear('"contain"'))
	),
	catch(
		preprocessConstraint(ClubDoesString, positiv, Length, Persons, Max, ClubDoesConstraints),
		constraint_unclear,
		throw(constraint_unclear('"club does"'))
	),
	catch(
		preprocessConstraint(ReactString, positiv, Length, Persons, Max, ReactConstraints),
		constraint_unclear,
		throw(constraint_unclear('"react"'))
	),
	catch(
		preprocessConstraint(SyncString, positiv, Length, Persons, Max, SyncConstraints),
		constraint_unclear,
		throw(constraint_unclear('"sync throws"'))
	),
	catch(
		preprocessConstraint(JustString, positiv, Length, Persons, Max, ContainJustConstraints),
		constraint_unclear,
		throw(constraint_unclear('"contains just"'))
	),
	findall(Pattern, (length(Pattern, Length), member(Contain,  ContainConstraints ), contains(Pattern, Contain         )), BagContains),
	(BagContains = [] -> ContainConstraints = []; true),
	findall(Pattern, (length(Pattern, Length), member(ClubDoes, ClubDoesConstraints), clubDoes(Pattern, ClubDoes        )), BagClubDoes),
	(BagClubDoes = [] -> ClubDoesConstraints = []; true),
	findall(Pattern, (length(Pattern, Length), member(React,    ReactConstraints   ), react(Pattern, React              )), BagReact   ),
	(BagReact = [] -> ReactConstraints = []; true),
	findall(Pattern, (length(Pattern, Length), member(Sync,     SyncConstraints    ), sync_throws(Pattern, Sync, Persons)), BagSync    ),
	(BagSync = [] -> SyncConstraints = []; true),
	length(JustPattern, Length),
	(ContainJustConstraints = []; contains_just(JustPattern, ContainJustConstraints)),
	% !!!!!! ?????????????????
	append([MagicPattern, JustPattern], BagContains, BagTmp1),
	append(BagTmp1, BagClubDoes, BagTmp2),
	append(BagTmp2, BagReact, BagTmp3),
	append(BagTmp3, BagSync, BagOfConstraints),
	(BagOfConstraints = [] ->
			length(ConstraintRotated, Length);
			(
				mergeN(BagOfConstraints, Constraint),
				rotateHighestFirst(Constraint, ConstraintRotated)
			)
	).

cleanEqualConstraints(BagOfConstraints, CleanBagOfConstraints) :-
	cleanEqualConstraintsForward(BagOfConstraints, HalfCleanedBag),
	reverse(HalfCleanedBag, HalfCleanedBagInverted),
	cleanEqualConstraintsForward(HalfCleanedBagInverted, CleanBagOfConstraints).

cleanEqualConstraintsForward([], []) :- !.
cleanEqualConstraintsForward([SubConstraint|BagOfConstraints], CleanBagOfConstraints) :-
	member(Constraint, BagOfConstraints),
	isRotatedSubConstraint(SubConstraint, Constraint),!,
	cleanEqualConstraintsForward(BagOfConstraints, CleanBagOfConstraints).
cleanEqualConstraintsForward([Constraint|BagOfConstrains], [Constraint|CleanBagOfConstrains]) :-
	cleanEqualConstraintsForward(BagOfConstrains, CleanBagOfConstrains).
	
isRotatedSubConstraint(SubConstraint, Constraint) :-
	rotate(Constraint, ConstraintRotated),
	isSubConstraint(SubConstraint, ConstraintRotated),!.

isSubConstraint([], []) :- !.
isSubConstraint([SubThrow|SubConstraint], [Throw|Constraint]) :-
	nonvar(SubThrow), nonvar(Throw), !,
	SubThrow = Throw,
	isSubConstraint(SubConstraint, Constraint).
isSubConstraint([_SubThrow|SubConstraint], [Throw|Constraint]) :-
	var(Throw), !,
	isSubConstraint(SubConstraint, Constraint).


%% --- Constraints Passes ---

passesMin(Throws, PassesMin) :-
   number(PassesMin),
   amountOfPasses(Throws, Passes),
   PassesMin =< Passes.
passesMin(Throws, PassesMin) :- 
   var(PassesMin),
   passesMin(Throws, 0).          %if minimum of passes not specified require _one_ pass.

passesMax(Throws, PassesMax) :-
   number(PassesMax),
   amountOfPasses(Throws, Passes),
   Passes =< PassesMax.
passesMax(_Throws, PassesMax) :- 
   var(PassesMax).                %succeed if maximum of passes not specified

amountOfPasses([], 0).
amountOfPasses([FirstThrow|RestThrows], Passes) :-
   amountOfPasses(RestThrows, RestPasses),
   isPass(FirstThrow, ThisThrowIsPass),
   Passes is ThisThrowIsPass + RestPasses.

isPass(Var, 0) :- var(Var), !.
isPass(p(_,Index,_), 1) :- Index > 0, !.
isPass(p(_,Index,_), 0) :- Index = 0, !.
isPass(Multiplex, NumberOfPasses) :- 
	is_list(Multiplex),!,
	amountOfPasses(Multiplex, NumberOfPasses).


%%% --- Constraints Pattern ---

contains(Pattern, Segment) :-
   insertThrows(Pattern, Segment, next).


% Pattern doesn't contain Segment
dontcontain(_, []) :- fail,!.
dontcontain([PatternHead|_Pattern], _) :-
   var(PatternHead),!. % one is var
dontcontain(_, [SegmentHead|_Segment]) :-
   var(SegmentHead),!. % one is var
dontcontain([PatternMultiplex|_Pattern], [SegmentThrow|_Segment]) :-
	is_list(PatternMultiplex), 
	not(is_list(SegmentThrow)),!, % PatternHead is Multiplex the other not
	multiplexDoesntContain(PatternMultiplex, SegmentThrow).
dontcontain([PatternThrow|_Pattern], [SegmentMultipex|_Segment]) :-
	not(is_list(PatternThrow)), 
	is_list(SegmentMultipex),!. % SegHead is Multiplex the other not
dontcontain([PatternMultiplex|_Pattern], [SegmentMultiplex|_Segment]) :-
	is_list(PatternMultiplex),
	is_list(SegmentMultiplex),!,  % both Multiplex
	multiplexDoesntContain(PatternMultiplex, SegmentMultiplex).
dontcontain([PatternHead|_Pattern], [SegmentHead|_Segment]) :-
	not_this_throw(PatternHead, SegmentHead), !. % not same head
dontcontain([_PatternHead|Pattern], [_SegmentHead|Segment]) :-
	dontcontain(Pattern, Segment),!. % not same tail

multiplexDoesntContain([], _) :- !.
multiplexDoesntContain([Head|Multiplex], p(T,I,O)) :-
	not_this_throw(Head, p(T,I,O)),
	multiplexDoesntContain(Multiplex, p(T,I,O)),!.
multiplexDoesntContain(_, []) :- fail,!.
multiplexDoesntContain(Multiplex, [Head|Tail]) :-
	multiplexDoesntContain(Multiplex, Head);
	multiplexDoesntContain(Multiplex, Tail).
	


not_this_throw(p(_Throw, Index, _Origen), p(_SegThrow, SegIndex, _SegOrigen)) :-
	var(SegIndex),
	Index = 0,!.
not_this_throw(p(Throw, Index, Origen), p(SegThrow, SegIndex, SegOrigen)) :-
	nonvar(SegIndex),
	(
		Throw \= SegThrow;
		Index \= SegIndex;
		Origen \= SegOrigen
	),!.
not_this_throw(p(Throw, Index, Origen), p(SegThrow, SegIndex, SegOrigen)) :-
	var(SegIndex),
	(		
			Throw \= SegThrow;
			Origen \= SegOrigen;
			Index \= SegIndex
	),!.


dontContainRotation(Pattern, Segment) :-
	forall(rotate(Pattern, Rotation), dontcontain(Rotation, Segment)).

clubDoes(Pattern, Seg) :-
   insertThrows(Pattern, Seg, landingSite).

react(Pattern, Seg) :-
	insertThrows(Pattern, Seg, landingSite, [delta(-2)]).


insertThrows(Pattern, Seg, Pred) :-
	insertThrows(Pattern, Seg, Pred, 0, []).

insertThrows(Pattern, Seg, Pred, Options) :-
	insertThrows(Pattern, Seg, Pred, 0, Options).

insertThrows(_Pattern, [], _Pred, _Site, _Options) :- !.
insertThrows(Pattern, [Throw | Rest], Pred, Site, Options) :-
	length(Pattern, Period),
	(select(offset(Offset), Options, NextOptions) ->
		(
			OffsetSite is Site + Offset
		);
		(
			NextOptions = Options,
			OffsetSite = Site
		)
	),
	nth0(OffsetSite, Pattern, Throw),
	memberchk(Delta, Options, [name(delta), default(0)]),
	SitePlusDelta is OffsetSite + Delta,
	%Test ob Hoehe OK!?! (react: 1 2 nicht sinnvoll) !!!!!!!!!!!!!!!!!!!!!!!
	NewNextSiteOptions = [throw(Throw), site(SitePlusDelta), period(Period)],
	append(Options, NewNextSiteOptions, NextSiteOptions),
	insertThrows_nextSite(NextSiteList, NextSiteOptions, Pred),
	(is_list(NextSiteList) ->
	   member(NextSite, NextSiteList);
	   NextSite = NextSiteList
	),!,   % doesn't work with [_ _] 1p   not all are found!!!!!!!!!!!!!!!!!!!!!!!!!!!
	insertThrows(Pattern, Rest, Pred, NextSite, NextOptions).

insertThrows_nextSite(NextSite, Options, next) :-
	memberchk(site(Site), Options),
	memberchk(period(Period), Options),
	NextSite is (Site + 1) mod Period, !.
insertThrows_nextSite(NextSite, Options, landingSite) :-
	memberchk(site(Site), Options),
	memberchk(throw(Throw), Options),
	memberchk(period(Period), Options),
	landingSite(Site, Throw, Period, NextSite), !.



sync_throws(Pattern, Seg, NumberOfJugglers) :-
	length(Pattern, Length),
	0 is Length mod NumberOfJugglers,
	sync_throws_fill(Pattern, Seg, 0, NumberOfJugglers).

sync_throws_fill(_Pattern, _Seg, NumberOfJugglers, NumberOfJugglers) :- !.
sync_throws_fill(Pattern, Seg, Juggler, NumberOfJugglers) :-
	length(Pattern, Length),
	Offset is Juggler * (Length / NumberOfJugglers),
	insertThrows(Pattern, Seg, next, [offset(Offset)]),
	NextJuggler is Juggler + 1,
	sync_throws_fill(Pattern, Seg, NextJuggler, NumberOfJugglers).


contains_just([], _ListOfSegs) :- !.
contains_just(Pattern, ListOfSegs) :-
	member(Seg, ListOfSegs),
	append(Seg, RestPattern, Pattern),
	contains_just(RestPattern, ListOfSegs).



containsMagicOrbit(Pattern, NumberOfJugglers, MaxHeight) :-
	length(Pattern, Length),
	Prechator is (Length * 1.0) / NumberOfJugglers,
	MagicMaxHeight is min(MaxHeight, Prechator),
	possibleThrows(NumberOfJugglers, Length, MagicMaxHeight, [p(0,0,0)|PossibleThrows]),
	searchMagicThrows(PossibleThrows, MagicThrows, Prechator, Length, Length),
	clubDoes(Pattern, MagicThrows).
	
%% 1 = Clubs = SumThrows * Jugglers / Length ==> SumThrows = Prechator
%%
%% Orbit ==> SumOrig = N * Length
%% Orig = Throw + IndexDown * Prechator 
%% ==>
%% N = SumOrig / Length
%%   = Sum(Throw + IndexDown * Prechator) / Length
%%   = (Prechator + Sum(IndexDown * Prechator))/ Length
%%   = (Prechator + Prechator * Sum(IndexDown)) / Length
%%   = (1 + Sum(IndexDown)) / Jugglers
searchMagicThrows(_PossibleThrows, [], 0, 0, _) :- !.
searchMagicThrows(PossibleThrows, MagicThrows, Prechator, Length, OrigLength) :-
	Length =< 0,
	NextLength is OrigLength + Length,
	searchMagicThrows(PossibleThrows, MagicThrows, Prechator, NextLength, OrigLength).
searchMagicThrows(PossibleThrows, [MagicThrow|MagicThrows], Prechator, Length, OrigLength) :-
	member(MagicThrow, PossibleThrows),
	MagicThrow = p(Throw, _Index, Origen),
	Throw > 0,
	Throw =< Prechator,
	%Origen =< Length,
	PrechatorMinus is Prechator - Throw,
	LengthMinus is Length - Origen,
	searchMagicThrows(PossibleThrows, MagicThrows, PrechatorMinus, LengthMinus, OrigLength).
	
	
	
possibleThrows(NumberOfJugglers, Length, MaxHeight, PossibleThrows) :-
	findall(
		Throw,
		possibleThrow(NumberOfJugglers, Length, MaxHeight, Throw),
		PossibleThrows
	).
possibleThrow(_NumberOfJugglers, _Length, MaxHeight, p(Throw, 0, Throw)) :-
	MaxHeightI is truncate(MaxHeight),
	between(0, MaxHeightI, Throw).
possibleThrow(NumberOfJugglers, Length, MaxHeight, p(Throw, Index, Origen)) :-
	Prechator is (Length * 1.0) / NumberOfJugglers,
	IndexMax is NumberOfJugglers - 1,
	between(1, IndexMax, Index),
	MaxHeightSolo is truncate(MaxHeight + (NumberOfJugglers - Index) * Prechator),
	between(1, MaxHeightSolo, Origen),
    Throw is Origen - (NumberOfJugglers - Index) * Prechator,
	Throw >= 1,
	Throw =< MaxHeight.


%% example:
% 6 1 _ _  6 Pattern
% 2 3 _ _  1 LandingSites           landingSites(Pattern, LandingSites)
% 2 3 4 5  1 (Permutation)          permutation(OneToN, LandingSites)
% 1 1 1 1 -4 BasePattern            landingSites2Pattern(LandingSites, BasePattern)
% 


siteswap(Jugglers, Objects, MaxHeight, PassesMin, PassesMax, Pattern) :-
   length(Pattern, Period),
   landingSites1(Pattern, LandingSites),
   possibleLandingSites1(Pattern, PossibleLandingSites), 
   fillPermutation(PossibleLandingSites, LandingSites),
   landingSites2Pattern(LandingSites, BasePattern),
   fillInAndCopy(Pattern, BasePattern, ObjectsPattern),	 % Pattern to calculate the Objects of the Constraints 
   objects(ObjectsPattern, Jugglers, ObjectsFromConstraints),
   MissingObjects is Objects - ObjectsFromConstraints,
   Prechator is (Period * 1.0) / Jugglers,
   (nonvar(PassesMax) -> 
    	(
			amountOfPasses(Pattern, PassesBevor),
			PassesToAddMax is PassesMax - PassesBevor
		); 
		PassesToAddMax = PassesMax
	),
   addObjects(BasePattern, MissingObjects, Jugglers, PassesToAddMax, 0, MaxHeight, Prechator, Pattern),	
   (passesMin(Pattern, PassesMin); Jugglers=1),
   passesMax(Pattern, PassesMax).
   %checkMultiplexes(Pattern).

addObjects([], 0, _Jugglers, _PassesMax, _MinHeight, _MaxHeight, _Prechator, []) :- !.
addObjects([_BaseHead|BaseRest], MissingObjects, Jugglers, PassesMax, MinHeight, MaxHeight, Prechator, [Throw|PatternRest]) :-
   ground(Throw),!,
   addObjects(BaseRest, MissingObjects, Jugglers, PassesMax, MinHeight, MaxHeight, Prechator, PatternRest).
addObjects([BaseHead|BaseRest], MissingObjects, Jugglers, PassesMax, MinHeight, MaxHeight, Prechator, [p(Throw, Index, Original)|PatternRest]) :-
   var(Throw),
   betweenRandom(0, MissingObjects, ObjectsToAdd),
   Index is ObjectsToAdd mod Jugglers,
   ((nonvar(PassesMax), PassesMax = 0) -> Index = 0; true),
   ((Index > 0, nonvar(PassesMax)) -> NextPassesMax is PassesMax - 1; NextPassesMax = PassesMax),
   Throw is BaseHead + ObjectsToAdd * Prechator,
   (
      (Throw = 0, Index = 0);
      Throw >= 1
   ),
%   (var(MaxHeight);
%      (
%         numberOfVars(PatternRest, NumberOfVars),
%         CalculatedMinHeight is 
%      )
%   ),
   (
      var(MinHeight);
      (number(MinHeight), Throw >= MinHeight)
   ),
   (
      var(MaxHeight);
      (number(MaxHeight), Throw =< MaxHeight)
   ),
   (Index = 0 ->
      Original = Throw;
      Original is Throw + (Jugglers - Index) * Prechator
   ),
   NewMissingObjects is MissingObjects - ObjectsToAdd,
   addObjects(BaseRest, NewMissingObjects, Jugglers, NextPassesMax, MinHeight, MaxHeight, Prechator, PatternRest).
addObjects([BaseMultiplex|BaseRest], MissingObjects, Jugglers, PassesMax, MinHeight, MaxHeight, Prechator, [Multiplex|PatternRest]) :-
   is_list(Multiplex),
   amountOfPasses(Multiplex, MultiplexPassesBevor),
   between(0, MissingObjects, ObjectsForMultiplex),
   ObjectsForRest is MissingObjects - ObjectsForMultiplex,
   MinHeightForMultiplex is max(MinHeight, 1),
   addObjects(BaseMultiplex, ObjectsForMultiplex, Jugglers, PassesMax, MinHeightForMultiplex, MaxHeight, Prechator, Multiplex),
   (
      is_set(Multiplex);
      listOf(p(2,0,2), Multiplex)
   ),
   amountOfPasses(Multiplex, MultiplexPasses),
   (nonvar(PassesMax) ->
      (
         NextPassesMax is PassesMax - (MultiplexPasses - MultiplexPassesBevor),
         NextPassesMax >= 0
      );
      (
         NextPassesMax = PassesMax
      )
   ),
   addObjects(BaseRest, ObjectsForRest, Jugglers, NextPassesMax, MinHeight, MaxHeight, Prechator, PatternRest).


%objectsToAdd(ObjectsToAdd, MissingObjects, MinHeight, MaxHeight, NumberOfVars, NumberOfJugglers, Base, Prechator) :-
%	between(0, MissingObjects, ObjectsToAdd),
	


landingSites2Pattern(LandingSites, BasePattern) :-
   length(LandingSites, Period),
   length(BasePattern, Period),
   possibleLandingSites1(LandingSites, PossibleLandingSites),
   landingSites2Pattern(LandingSites, PossibleLandingSites, _, Period, BasePattern).


landingSites2Pattern([], Rest, Rest, _Period, []) :- !.
landingSites2Pattern([Multiplex|LandingSites], PossibleLandingSites, RemainingLandingSites, Period, [MultiplexBase|BasePattern]) :-
	is_list(Multiplex),!,
	landingSites2Pattern(Multiplex, PossibleLandingSites, RemainingLandingSitesForNow, Period, MultiplexBase),
	landingSites2Pattern(LandingSites, RemainingLandingSitesForNow, RemainingLandingSites, Period, BasePattern).
landingSites2Pattern([Site|LandingSites], [Pos|PossibleLandingSites], RemainingLandingSites, Period, [BaseThrow|BasePattern]) :-
	TmpThrow is Site - Pos,
	substractUntilNonPositiv(TmpThrow, Period, BaseThrow),
	landingSites2Pattern(LandingSites, PossibleLandingSites, RemainingLandingSites, Period, BasePattern).
	

	
prechacThis(Pattern, Pos, UpDown, NumberOfJugglers, NewPattern) :-
	number(Pos), !,
	prechacThis(Pattern, [Pos], UpDown, NumberOfJugglers, NewPattern).
prechacThis(Pattern, Pos, UpDown, NumberOfJugglers, NewPattern) :-
	is_list(Pos),
	length(Pattern, Period),
	nth0ListOfLists(Pos, Pattern, Throw),
	prechacThisThrow(Throw, UpDown, NumberOfJugglers, Period, NewThrow),
	(NewThrow = false ->
		NewPattern = false;
		changeOnePosition(Pattern, Pos, NewThrow, NewPattern)
	).
	
prechacThisThrow(p(Throw, Index, _Origen), up, NumberOfJugglers, Period, p(NewThrow, NewIndex, NewOrigen)) :-
	Prechator is (Period*1.0) / NumberOfJugglers,
	NewThrow is Throw + Prechator,
	NewIndex is (Index + 1) mod NumberOfJugglers,
	(NewIndex = 0 ->
		NewOrigen = NewThrow;
		NewOrigen is NewThrow + (NumberOfJugglers - NewIndex) * Prechator
	).
prechacThisThrow(p(Throw, Index, _Origen), down, NumberOfJugglers, Period, p(NewThrow, NewIndex, NewOrigen)) :-
	Prechator is (Period * 1.0) / NumberOfJugglers,
	NewThrow is Throw - Prechator,
	(Index = 0 ->
		NewIndex is NumberOfJugglers - 1;
		NewIndex is Index - 1
	),
	(NewThrow >= 1; (NewThrow = 0, NewIndex = 0)), !,
	(NewIndex = 0 ->
		NewOrigen = NewThrow;
		NewOrigen is NewThrow + (NumberOfJugglers - NewIndex) * Prechator
	).
prechacThisThrow(_Throw, down, _NumberOfJugglers, _Period, false) :- !.



swapThrows(Pattern, PosA, PosB, NewPattern) :-
	posList(Pattern, PosList),
	nth0(PosA, PosList, Pos1),
	nth0(PosB, PosList, Pos2),
	distanceOfThrows(Pos1, Pos2, Diff),
	Diff >= 0, !,
	length(Pattern, Length),
	length(NewPattern, Length),
	nth0ListOfLists(Pos1, Pattern, p(Throw1, Index1, Origen1)),
	nth0ListOfLists(Pos2, Pattern, p(Throw2, Index2, Origen2)),
	NewThrow1 is Throw2 + Diff,
	NewIndex1 is Index2,
	(NewIndex1 = 0 -> 
		(NewThrow1 >= 0);
		(NewThrow1 >= 1)
	),
	NewOrigen1 is Origen2 + Diff,
	NewThrow2 is Throw1 - Diff,
	NewIndex2 is Index1,
	(NewIndex2 = 0 -> 
		(NewThrow2 >= 0);
		(NewThrow2 >= 1)
	),
	NewOrigen2 is Origen1 - Diff,
	changeOnePosition(Pattern, Pos1, p(NewThrow1, NewIndex1, NewOrigen1), TmpPattern),
	changeOnePosition(TmpPattern, Pos2, p(NewThrow2, NewIndex2, NewOrigen2), NewPattern).
swapThrows(Pattern, Pos2, Pos1, NewPattern) :-
	swapThrows(Pattern, Pos1, Pos2, NewPattern).

	
distanceOfThrows(Pos1, Pos2, Diff) :-
	number(Pos1),
	number(Pos2), !,
	Diff is Pos2 - Pos1.
distanceOfThrows([Pos1|_], Pos2, Diff) :-
	!, distanceOfThrows(Pos1, Pos2, Diff).
distanceOfThrows(Pos1, [Pos2|_], Diff) :-
	!, distanceOfThrows(Pos1, Pos2, Diff).


addKey(Pattern, Heights-Pattern) :-
	listOfHeights(Pattern, Heights).

removeKey(_Key-Pattern, Pattern).

lengthK(_Key-Pattern, Length) :-
	length(Pattern, Length), !.
lengthK(Pattern, Length) :-
	is_list(Pattern),!,
	length(Pattern, Length).


averageNumberOfClubs(Pattern, Clubs) :- 
	length(Pattern, Period),
	flatten(Pattern, PatternFlat),
	listOfThrows0(PatternFlat, Throws),
	sum_list(Throws, SumThrows),
	Clubs is (SumThrows * 1.0) / Period.
	
listOfThrows([], []) :- !.
listOfThrows([p(Throw,_Index,_Origen)|Pattern], [Throw|Throws]) :-
	listOfThrows(Pattern, Throws).

listOfThrows0([], []) :- !.
listOfThrows0([Var|Pattern], [0|Throws]) :-
	var(Var), !,
	listOfThrows0(Pattern, Throws).
listOfThrows0([p(Throw,_Index,_Origen)|Pattern], [Throw|Throws]) :-
	listOfThrows0(Pattern, Throws).


throw2list(Multiplex, Multiplex) :-
	is_list(Multiplex),!.
throw2list(Throw, [Throw]) :- !.


pattern2Lists([], []) :- !.
pattern2Lists([Throw|Pattern], [List|PatternOfLists]) :-
	throw2list(Throw, List),
	pattern2Lists(Pattern, PatternOfLists).

originalNumberOfClubs(Pattern, Clubs) :-
    length(Pattern, Period),
    flatten(Pattern, PatternFlat),
    listOfOrigen(PatternFlat, Orig),
    sum_list(Orig, SumOrig),
    Clubs is (SumOrig * 1.0) / Period.

listOfOrigen([], []) :- !.
listOfOrigen([Var|Pattern], [0|Rest]) :-
	var(Var), !,
	listOfOrigen(Pattern, Rest).
listOfOrigen([p(_Throw,_Index,Origen)|Pattern], [Origen|Rest]) :-
	listOfOrigen(Pattern, Rest).


%%% List of Point in Time

is_lpt(LPT, NumberOfJugglers) :-
	LPT = [LPTA, LPTB],
	length(LPTA, NumberOfJugglers),
	length(LPTB, NumberOfJugglers).
	
fill_lpt(LPT, X, NumberOfJugglers) :-
	is_lpt(LPT, NumberOfJugglers),
	LPT = [LPTA, LPTB],	
	listOf(X, LPTA),
	listOf(X, LPTB).

lpt_nth0(LPT, X, Juggler, a) :-
	LPT = [LPTA, _LPTB],
	nth0(Juggler, LPTA, X).
lpt_nth0(LPT, X, Juggler, b) :-
	LPT = [_LPTA, LPTB],
	nth0(Juggler, LPTB, X).
	
lpt_copy(LPT, LPTCopy) :-
	LPT = [LPTA, LPTB],
	LPTCopy = [LPTAC, LPTBC],
	copyList(LPTA, LPTAC),
	copyList(LPTB, LPTBC).

lpt_add(LPTOld, X, Juggler, Hand, NumberOfJugglers, LPTNew) :- 
	lpt_nth0(LPTOld, XOld, Juggler, Hand),
	XNew is XOld + X,
	is_lpt(LPTNew, NumberOfJugglers),
	lpt_nth0(LPTNew, XNew, Juggler, Hand),
	lpt_copy(LPTOld, LPTNew).

lpt_append(LPTOld, X, Juggler, Hand, NumberOfJugglers, LPTNew) :- 
	lpt_nth0(LPTOld, XOld, Juggler, Hand),
	is_list(XOld),
	append(XOld, [X], XNew),
	is_lpt(LPTNew, NumberOfJugglers),
	lpt_nth0(LPTNew, XNew, Juggler, Hand),
	lpt_copy(LPTOld, LPTNew).

	
%%% --- landing sites ---

possibleLandingSites(Pattern, PossibleLandingSites) :-
	possibleLandingSites(Pattern, PossibleLandingSites, 0).
possibleLandingSites([], [], _Period) :- !.
possibleLandingSites([Multiplex|Pattern], PossibleLandingSites, Position) :-
	is_list(Multiplex), !,
	length(Multiplex, Length),
	listOfNumber(Position, Length, ListOfPosition),
	NextPosition is Position + 1,
	possibleLandingSites(Pattern, RestLandingSites, NextPosition),
	append(ListOfPosition, RestLandingSites, PossibleLandingSites).
possibleLandingSites([_Throw|Pattern], [Position|PossibleLandingSites], Position) :-
	NextPosition is Position + 1,
	possibleLandingSites(Pattern, PossibleLandingSites, NextPosition).
	
	
possibleLandingSites1(Pattern, LandingSites) :-
	possibleLandingSites1(Pattern, LandingSites, 1).
possibleLandingSites1(Pattern, LandingSites1, Position1) :- 
	Position is Position1 - 1,
	possibleLandingSites(Pattern, LandingSites, Position),
	add(LandingSites, 1, LandingSites1).


landingSite(Site, Throw, Length, LandingSite) :-
    landingSite(Site, Throw, Length, LandingSite, mod).

landingSite(_, Throw, _, _, _) :-
	var(Throw), !,
	fail.
landingSite(Site, Throw, Length, LandingSite, mod) :- %self
   number(Throw),!,
   LandingSite is (Site + Throw) mod Length.
landingSite(Site, Throw, _Length, LandingSite, real) :- %self
   number(Throw),!,
   LandingSite is (Site + Throw).
landingSite(Site, p(_,_,Origen), Length, LandingSite, Type) :- %pass
	landingSite(Site, Origen, Length, LandingSite, Type).
landingSite(Site, Multiplex, Length, LandingSite, Type) :- %multiplex
	is_list(Multiplex), !,
	landingSiteMultiplex(Site, Multiplex, Length, LandingSite, Type).

landingSiteMultiplex(_, [], _, [], _Type) :- !.
landingSiteMultiplex(Site, [Head|Multiplex], Period, [_Landing|LandingSites], Type) :-
	var(Head), !,
	landingSiteMultiplex(Site, Multiplex, Period, LandingSites, Type).
landingSiteMultiplex(Site, [Head|Multiplex], Period, [Landing|LandingSites], Type) :-
	landingSite(Site, Head, Period, Landing, Type),
	landingSiteMultiplex(Site, Multiplex, Period, LandingSites, Type).

landingSite1(Site, Throw, Length, LandingSite) :-
    landingSite1(Site, Throw, Length, LandingSite, mod).

landingSite1(Site1, Throw, Length, LandingSite1, Type) :-
	Site0 is Site1 - 1,
	landingSite(Site0, Throw, Length, LandingSite0, Type),
	LandingSite1 is LandingSite0 + 1.	
	

landingSites(Pattern, LandingSites) :-
    landingSites(Pattern, LandingSites, mod).

landingSites(Pattern, LandingSites, Type) :-
	length(Pattern, Period),
	landingSites(Pattern, Period, LandingSites, Type).
	
landingSites([], _, [], _Type) :- !.
landingSites([Throw|Pattern], Period, [_Site|LandingSites], Type) :-
	var(Throw),!,
	landingSites(Pattern, Period, LandingSites, Type).
landingSites([Throw|Pattern], Period, [Site|LandingSites], Type) :-
	length(Pattern, Length),
	Position is Period - Length - 1,
	landingSite(Position, Throw, Period, Site, Type),
	landingSites(Pattern, Period, LandingSites, Type).
	

landingSites1(Pattern, LandingSites) :- 
    landingSites1(Pattern, LandingSites, mod).
	
landingSites1(Pattern, LandingSites, Type) :-
	length(Pattern, Period),
	landingSites1(Pattern, Period, LandingSites, Type).
landingSites1(Pattern, Period, LandingSites1, Type) :- 
	landingSites(Pattern, Period, LandingSites, Type),
	add(LandingSites, 1, LandingSites1).


uniqueLandingSites(Pattern) :-
	landingSites1(Pattern, Sites),
	allMembersUnique(Sites).



%%% --- heigts ---
	
height(Var, _) :- var(Var),!.
height( [],  0) :- !.
height( Throw, Throw) :- number(Throw),!.
height( Throw, Height) :- rational_to_number(Throw,Height),!.
height(p(Throw,_,_), Height) :- height(Throw,Height),!.
height(p(Throw, _), Height) :- height(Throw,Height), !.
height(List,Height) :-
	is_list(List),!,
	maxHeight(List,Height).
	

maxHeight(Pattern, MaxHeight) :-
	is_list(Pattern),!,
	addKey(Pattern, KeyPattern),
	maxHeight(KeyPattern, MaxHeight).

maxHeight([]-_, 0) :- !.
maxHeight([HeadHeight|ListOfHeights]-Pattern, MaxHeight) :-
	maxHeight(ListOfHeights-Pattern, MaxHeight),
	MaxHeight >= HeadHeight,!.
maxHeight([MaxHeight|ListOfHeights]-Pattern, MaxHeight) :-
	maxHeight(ListOfHeights-Pattern, RestHeight),
	MaxHeight > RestHeight,!.


allHeightsSmaller(Pattern, Max) :-
	is_list(Pattern),!,
	addKey(Pattern, KeyPattern),
	allHeightsSmaller(KeyPattern, Max).

allHeightsSmaller([]-_Pattern, _Max) :- !.
allHeightsSmaller([Height| RestHeights]-Pattern, Max) :- 
   Height =< Max,!,
   allHeightsSmaller(RestHeights-Pattern, Max).


allHeightsHeigher(Pattern, Min) :-
	is_list(Pattern),!,
	addKey(Pattern, KeyPattern),
	allHeightsHeigher(KeyPattern, Min).
	
allHeightsHeigher([]-_Pattern, _Min) :- !.
allHeightsHeigher([Height| RestHeights]-Pattern, Min) :- 
   Height >= Min,
   allHeightsHeigher(RestHeights-Pattern, Min).


allHeightsHeigherOr0(_Key-Pattern, Min) :-
	allHeightsHeigherOr0(Pattern, Min).

allHeightsHeigherOr0([], _Min) :- !.
allHeightsHeigherOr0([Throw|Pattern], Min) :- 
   Throw = 0,!,
   allHeightsHeigherOr0(Pattern, Min).
allHeightsHeigherOr0([Throw|Pattern], Min) :- 
   height(Throw, Height),
   Height >= Min,!,
   allHeightsHeigherOr0(Pattern, Min).


listOfHeights([],[]) :- !.
listOfHeights([Throw|Siteswap], [Height|List]) :-
	height(Throw, Height),
	listOfHeights(Siteswap, List).


compare_heights(Order,P1,P2) :-
	is_list(P1),
	is_list(P2),
	listOfHeights(P1,H1),
	listOfHeights(P2,H2),
	compare_swaps(Order,H1,H2),!.

compare_heights(Order,K1-_P1,K2-_P2) :-
	compare_swaps(Order,K1,K2).

is_biggest([Pattern], Pattern) :- !.
is_biggest([Pattern|ListOfPatterns], Biggest) :-
	is_biggest(ListOfPatterns, Biggest),
	compare_swaps(Order, Biggest, Pattern),
	Order \= <, !.
is_biggest([Biggest|ListOfPatterns], Biggest) :-
	is_biggest(ListOfPatterns, Pattern),
	compare_swaps(Order, Biggest, Pattern),
	Order = >, !.

is_bigger_than_list([], _Siteswap) :- !.
is_bigger_than_list([Head|Tail], Siteswap) :-
	compare(Order,Siteswap,Head),
	Order \= <,
	is_bigger_than_list(Tail, Siteswap).


is_smallest([Pattern], Pattern) :- !.
is_smallest([Pattern|ListOfPatterns], Smallest) :-
	is_smallest(ListOfPatterns, Smallest),
	compare_swaps(Order, Smallest, Pattern),
	Order \= >, !.
is_smallest([Smallest|ListOfPatterns], Smallest) :-
	is_smallest(ListOfPatterns, Pattern),
	compare_swaps(Order, Smallest, Pattern),
	Order = <, !.

is_smaller_than_list([], _Siteswap).
is_smaller_than_list([Head|Tail], Siteswap) :-
	compare_swaps(Order,Siteswap,Head),
	Order \= >,
	is_smaller_than_list(Tail, Siteswap).

cleanEquals([],[]) :- !.
cleanEquals([Head|Tail], CleanBag) :-
	containsEqual(Tail, Head),!,
	cleanEquals(Tail,CleanBag).
cleanEquals([Head|Tail], [Head|CleanBag]) :-
	cleanEquals(Tail, CleanBag).

containsEqual([Head|_Tail],Siteswap) :-
	areEqual(Siteswap,Head),!.
containsEqual([_Head|Tail],Siteswap) :-
	containsEqual(Tail,Siteswap).

areEqual(P1, P2) :-
	permutateMultiplexes(P1, PTemp),
	rotate(PTemp,PRot),
	isTheSame(PRot, P2).

isTheSame([], []) :- !.
isTheSame([T1|P1], [T2|P2]) :-
   nonvar(T1),
   nonvar(T2),!,
   T1 = T2,
   isTheSame(P1, P2).
isTheSame([T1|P1], [T2|P2]) :-
   var(T1),
   var(T2),!,
   isTheSame(P1, P2).


rotateAll([],[]) :- !.
rotateAll([Head|Tail],[HeadRotated|TailRotated]) :-
	rotateHighestFirst(Head,HeadRotated),
	rotateAll(Tail,TailRotated).

rotateHighestFirst(Siteswap, Rotated) :-
	findall(R,rotate(Siteswap,R), ListOfRotations),
	is_biggest(ListOfRotations, Rotated).

%compareSiteswap(Delta, p(Throw1, Index1, _Origen1), p(Throw2, Index2, _Origen2)) :-
%	compare(Delta, [Throw1, Index1], [Throw2, Index2]), !.
%compareSiteswap(Delta, Siteswap1, Siteswap2) :-
%	amountOfPasses(Siteswap1, Passes1),
%	amountOfPasses(Siteswap2, Passes2),
	

compare_swaps(Order, P1, P2) :-
	siteswapKey(P1, Key1),
	siteswapKey(P2, Key2),
	compare(Order, Key1, Key2).


cleanListOfSiteswaps(List,CleanList) :-
   cleanEquals(List, Swaps),
   rotateAll(Swaps,SwapsRotated),
   sortListOfSiteswaps(SwapsRotated, CleanList).

sortListOfSiteswaps(Swaps, SwapsSorted) :-
   addKeys(Swaps,SwapsWithKeys),
   keysort(SwapsWithKeys,SwapsSortedWithKeys),
   removeKeys(SwapsSortedWithKeys,SwapsSorted).


siteswapKey(Swap, Key) :-
	%amountOfPasses(Swap,Number),
	rat2float(Swap, SwapFloat),
	pattern2Lists(SwapFloat, SwapLists),
	Key = SwapLists.

addKeys([],[]) :- !.
addKeys([Head|Swaps],[Key-Head|SwapsWithKeys]) :-
	siteswapKey(Head, KeyTmp),
	amountOfPasses(Head,Number),
	Key = [Number|KeyTmp],
	addKeys(Swaps,SwapsWithKeys).

removeKeys([],[]) :- !.
removeKeys([_Key-Head|SwapsWithKeys],[Head|Swaps]) :-
	removeKeys(SwapsWithKeys,Swaps).



rat2float([],[]) :- !.	
rat2float([Var|PRat], [Var|PFloat]) :-
	var(Var),!,
	rat2float(PRat, PFloat).
rat2float([p(Var,Index,Origen)|PRat], [p(Var,Index,Origen)|PFloat]) :-
	var(Var),!,
	rat2float(PRat, PFloat).
rat2float([p(Rational,Index,Origen)|PRat], [p(Float,Index,Origen)|PFloat]) :-
	(number(Rational); rational(Rational)),!,
	Float is float(Rational),
	rat2float(PRat, PFloat).
rat2float([ListOfRational|PRat], [ListOfFloat|PFloat]) :-
	is_list(ListOfRational),
	rat2float(ListOfRational, ListOfFloat),
	rat2float(PRat, PFloat).


%succeeds if there is a pattern Merged that unifies P1 and a rotation of P2
merge2(P1, P2, Merged) :-
  rotate(P2, Merged),
  Merged = P1,
  uniqueLandingSites(Merged).


%mergeN(List, Pattern).
%succeeds if all Patterns in List can be unified with Pattern
mergeN([Pattern], Pattern).
mergeN([FirstPattern | Rest], Merged) :-
  mergeN(Rest, RestMerged),
  merge2(RestMerged, FirstPattern, Merged).


% objects([[4,2],2,1]) = 9/3 = 3
objects(Pattern, Objects) :-
   objects(Pattern, 1, Objects).

objects(Pattern, Jugglers, Objects) :-
   sumThrows(Pattern, SumThrows),
   length(Pattern, Period),
   Objects is round(Jugglers * SumThrows * 1.0 / Period).


sumThrows([], 0) :- !.
sumThrows(Throw,Throw) :- number(Throw),!.
sumThrows(Throw, SumThrow) :- rational_to_number(Throw, SumThrow),!.
sumThrows(p(Throw,_,_), SumThrow) :- sumThrows(Throw, SumThrow),!.
sumThrows([Var|RestPattern], Sum) :-
   var(Var),!,
   sumThrows(RestPattern, Sum).
sumThrows([Throw|RestPattern], Sum) :-
   sumThrows(RestPattern, OldSum),
   sumThrows(Throw, SumThrow),
   Sum is OldSum + SumThrow.


sumHeights([], 0) :- !.
sumHeights([Var|RestPattern], Sum) :-
   var(Var),!,
   sumHeights(RestPattern, Sum).
sumHeights([Throw|RestPattern], Sum) :-
   sumHeights(RestPattern, OldSum),
   height(Throw, Height),
   Sum is OldSum + Height.

%%% orbits %%%

orbits(Pattern, Orbits) :-
	length(Pattern, Length),
	length(Orbits, Length),
	setOrbit(Pattern, Orbits, 0, 0, 0, juststarted), !.
	

setOrbit(Pattern, Orbits, FirstPos, OrbitNo, FirstPos, notjuststarted) :-
	(ground(Orbits), !);
	(
		NextOrbitNo is OrbitNo + 1,
		firstNoGround0(Orbits, NextPos),
		setOrbit(Pattern, Orbits, NextPos, NextOrbitNo, NextPos, juststarted)
	).
setOrbit(Pattern, Orbits, Pos, OrbitNo, FirstPos, _) :-
	nth0(Pos, Pattern, Throw),
	not(is_list(Throw)),!,
	nth0(Pos, Orbits, OrbitNoOrig),
	var(OrbitNoOrig),
	OrbitNoOrig = OrbitNo,
	length(Pattern, Length),
	landingSite(Pos, Throw, Length, LandingPos),
	setOrbit(Pattern, Orbits, LandingPos, OrbitNo, FirstPos, notjuststarted).
setOrbit(Pattern, Orbits, Pos, OrbitNo, FirstPos, _) :-
	nth0(Pos, Pattern, Multiplex),
	is_list(Multiplex),  % Multiplex
	nth0(Pos, Orbits, OrbitNoOrig),
	not(ground(OrbitNoOrig)),
	length(Multiplex, MultiplexLength),
	length(OrbitNoOrig, MultiplexLength),
	not((
		member(OrbitNoNonVar, OrbitNoOrig),
		nonvar(OrbitNoNonVar),
		OrbitNoNonVar = OrbitNo
	)),
	nth0(MPos, Multiplex, Throw),
	nth0(MPos, OrbitNoOrig, OrbitNo),
	length(Pattern, Length),
	landingSite(Pos, Throw, Length, LandingPos),
	setOrbit(Pattern, Orbits, LandingPos, OrbitNo, FirstPos, notjuststarted).


	
	


clubsInOrbits(Pattern, OrbitPattern, Clubs) :-
	flatten(OrbitPattern, OrbitsFlat),
	list_to_set(OrbitsFlat, OrbitsSet),
	sort(OrbitsSet, Orbits),
	clubsInOrbit(Pattern, OrbitPattern, Orbits, Clubs).

clubsInOrbit(_, _, [], []) :- !.
clubsInOrbit(Pattern, OrbitPattern, [Orbit|OrbitList], [Clubs| ClubsList]) :-
	clubsInOrbit(Pattern, OrbitPattern, Orbit, Clubs),!,
	clubsInOrbit(Pattern, OrbitPattern, OrbitList, ClubsList).
	
clubsInOrbit(Pattern, OrbitPattern, Orbit, Clubs) :-
	number(Orbit),!,
	justThisOrbit(Pattern, OrbitPattern, Orbit, JustThisOrbit, calc),
	averageNumberOfClubs(JustThisOrbit, Clubs).
	

justThisOrbit([], [], _, [], _) :- !.
justThisOrbit([Multiplex|Pattern], [Orbits|OrbitPattern], Orbit, [NewMultiplex|JustThisOrbit], Type) :-
	is_list(Multiplex), !,
	justThisOrbit(Multiplex, Orbits, Orbit, NewMultiplexTmp, Type),
	(justSpaces(NewMultiplexTmp) ->
		NewMultiplex = '&nbsp;';
		NewMultiplex = NewMultiplexTmp
	),
	justThisOrbit(Pattern, OrbitPattern, Orbit, JustThisOrbit, Type).
justThisOrbit([Throw|Pattern], [Orbit|OrbitPattern], Orbit, [Throw|JustThisOrbit], Type) :-
	!,
	justThisOrbit(Pattern, OrbitPattern, Orbit, JustThisOrbit, Type).
justThisOrbit([_Thorw|Pattern], [_OtherOrbit|OrbitPattern], Orbit, [p(0,0,0)|JustThisOrbit], calc) :-
	justThisOrbit(Pattern, OrbitPattern, Orbit, JustThisOrbit, calc).
justThisOrbit([_Thorw|Pattern], [_OtherOrbit|OrbitPattern], Orbit, ['&nbsp;'|JustThisOrbit], print) :-
	justThisOrbit(Pattern, OrbitPattern, Orbit, JustThisOrbit, print).

justSpaces([]) :- !.
justSpaces([Space|List]) :-
	(
		Space = "&nbsp;";
		Space = " ";
		Space = '&nbsp;';
		Space = ' '
	),
	justSpaces(List).

% !!! Multiplex ToDo
zeroOrbits(Pattern, Orbits) :-
	orbits(Pattern, OrbitPattern),
	positionsInList(Pattern, p(0,0,0), ZerroPositions),
	nth0List(ZerroPositions, OrbitPattern, Orbits).
	

magicOrbits(Pattern, NumberOfJugglers, MagicOrbits) :-
	magicOrbits(Pattern, NumberOfJugglers, _OrbitPattern, MagicOrbits), !.
magicOrbits(Pattern, NumberOfJugglers, OrbitPattern, MagicOrbits) :-
	orbits(Pattern, OrbitPattern),
	clubsInOrbits(Pattern, OrbitPattern, Clubs),
	MagicClubPerPerson is 1.0 / NumberOfJugglers,
	positionsInList(Clubs, MagicClubPerPerson, MagicOrbits).
	

magicPositions(Pattern, NumberOfJugglers, MagicPositions) :-
	magicOrbits(Pattern, NumberOfJugglers, OrbitPattern, MagicOrbits),
	orbitPositions(MagicOrbits, OrbitPattern, MagicPositions).


orbitPositions(Orbits, OrbitPattern, Positions) :-
	is_list(Orbits), !,
	findall(
		Position,
		(
			member(Orbit, Orbits), 
			orbitPositions(Orbit, OrbitPattern, PositionsTmp),
			member(Position, PositionsTmp)
		),
		Positions
	).
orbitPositions(Orbit, OrbitPattern, Positions) :-
	number(Orbit), !,
	positionsInList(OrbitPattern, Orbit, Positions).
	
killOrbit(Pattern, Orbit, NewPattern) :-
	orbits(Pattern, OrbitPattern),
	orbitPositions(Orbit, OrbitPattern, Positions),
	changePositions(Pattern, Positions, p(0,0,0), NewPattern).

orbitOrder(Pattern, SiteswapPosition, OrbitPositions) :-
	length(Pattern, Length),
	FirstPos is SiteswapPosition mod Length,!,
	orbitOrder(Pattern, Length, FirstPos, OrbitPositions, FirstPos, juststarted).
orbitOrder(_Pattern, Length, SiteswapPosition, [], FirstPos, notjuststarted) :-
	FirstPos is SiteswapPosition mod Length, !.
orbitOrder(Pattern, Length, SiteswapPosition, [Pos|OrbitPositions], FirstPos, _) :-
	Pos is SiteswapPosition mod Length,
	nth0(Pos, Pattern, Throw),
	not(is_list(Throw)),!,
	landingSite(Pos, Throw, Length, LandingPos),
	orbitOrder(Pattern, Length, LandingPos, OrbitPositions, FirstPos, notjuststarted).
orbitOrderx(Pattern, Length, SiteswapPosition, [[Pos,MPos]|OrbitPositions], FirstPos, _) :-
	Pos is SiteswapPosition mod Length,
	nth0(Pos, Pattern, Multiplex),
	is_list(Multiplex),  % Multiplex
	nth0(MPos, Multiplex, Throw),
	landingSite(Pos, Throw, Length, LandingPos),
	orbitOrder(Pattern, Length, LandingPos, OrbitPositions, FirstPos, notjuststarted).
	
throw_was(Pattern, SiteswapPosition, ThrowPosition) :-
	orbitOrder(Pattern, SiteswapPosition, OrbitPositions),
	append(_, [ThrowPosition], OrbitPositions).
	
throw_reacts_to(Pattern, SiteswapPosition, ThrowPosition) :-
	ReactPosition is SiteswapPosition + 2,
	throw_was(Pattern, ReactPosition, ThrowPosition).



multiplex(OldPattern, NewPattern) :-
	length(OldPattern, Length),
	Length >= 3,

	between(1,Length,FirstIndex),
	nth1(FirstIndex, OldPattern, OldFirstThrow),
	number(OldFirstThrow),
	OldFirstThrow > 2,
	
	SecondIndex is ((FirstIndex + 1) mod Length) + 1,
	nth1(SecondIndex, OldPattern, OldSecondThrow),
	number(OldSecondThrow), % unnecessary
	OldSecondThrow > 0,
	
	FirstMultiplexThrow is OldFirstThrow - 2,
	SecondMultiplexThrow is OldSecondThrow,
	Multiplex = [FirstMultiplexThrow,SecondMultiplexThrow],
	% Multiplex is m(OldSecondThrow, SecondMultiplexThrow),

	nth1(FirstIndex, NewPattern, 2),
	nth1(SecondIndex, NewPattern, Multiplex),

	fillIn(OldPattern, NewPattern).

multiplex(Pattern, Pattern, 0).
multiplex(OldPattern, NewPattern, NumberOfMultiplexes) :-
	NumberOfMultiplexes > 0,
	multiplex(OldPattern, TempNewPattern),
	RemainingNumberOfMultiplexes is NumberOfMultiplexes - 1,
	multiplex(TempNewPattern, NewPattern, RemainingNumberOfMultiplexes).



permutateMultiplexes([],[]) :- !.
permutateMultiplexes([Head|Tail],[NewHead|NewTail]) :-
	is_list(Head),!,
	permutateMultiplexes(Tail,NewTail),
	permutation(Head,NewHead).
permutateMultiplexes([Head|Tail],[Head|NewTail]) :- 
	permutateMultiplexes(Tail,NewTail).


orderMultiplexes([],[]) :- !.
orderMultiplexes([Multiplex|Pattern], [MultiplexOrderedDesc|NewPattern]) :-
	is_list(Multiplex), !,
	msort(Multiplex, MultiplexOrdered),
	reverse(MultiplexOrdered, MultiplexOrderedDesc),	
	orderMultiplexes(Pattern, NewPattern).
orderMultiplexes([Throw|Pattern], [Throw|NewPattern]) :-
	orderMultiplexes(Pattern, NewPattern).
	
checkMultiplexes([]) :- !.
checkMultiplexes([Multiplex|Pattern]) :-
	is_list(Multiplex), !,
	(is_set(Multiplex); listOf(p(2,0,2), Multiplex)),
	dontcontain(Multiplex, [p(0,0,0)]),
	checkMultiplexes(Pattern).
checkMultiplexes([_Throw|Pattern]) :-
	checkMultiplexes(Pattern).
	
	
noMultiplex([]) :- !.
noMultiplex([p(_,_,_)|Pattern]) :-
	noMultiplex(Pattern).
	

preprocessConstraint(ConstraintString, Period, NumberOfJugglers, MaxHeight, Constraint) :-
	preprocessConstraint(ConstraintString, positiv, Period, NumberOfJugglers, MaxHeight, Constraint).


preprocessConstraint(ConstraintString, ConstraintType, Period, NumberOfJugglers, MaxHeight, Constraint) :-
	string2Constraint(ConstraintString, ConstraintBagShort),
	member(ConstraintShort, ConstraintBagShort),
	convertShortPasses(ConstraintShort, ConstraintType, Period, NumberOfJugglers, MaxHeight, Constraint).


string2Constraint(ConstraintString, Constraint) :-
	(
		dcg_constraint(Constraint, ConstraintString, []);
		throw(constraint_unclear)
	),!.

preprocessMultiplexes(Pattern) :-
	preprocessMultiplexes(Pattern, Pattern, 0).

preprocessMultiplexes([], _OrigPattern, _Position) :- !.
preprocessMultiplexes([Multiplex|Tail], OrigPattern, Position) :-
	is_list(Multiplex), !,
	length(Multiplex, Length),
	set2s(Length, Length, OrigPattern, Position),
	NewPosition is Position + 1,
	preprocessMultiplexes(Tail, OrigPattern, NewPosition).
preprocessMultiplexes([_Head|Tail], OrigPattern, Position) :-
	NewPosition is Position + 1,
	preprocessMultiplexes(Tail, OrigPattern, NewPosition).
	
set2s(1, _, _, _) :- !.
set2s(Distance, MultiplexLength, OrigPattern, Position) :-
	length(OrigPattern, Period),
	PositionOf2 is Period - 1 - ((Period - 1 - Position + (Distance - 1) * 2) mod Period),
	calcThe2(Distance, MultiplexLength, The2),
	nth0(PositionOf2, OrigPattern, The2),
	%(
	%	nth0(PositionOf2, OrigPattern, p(2,0,2));
	%	(
	%		nth0(PositionOf2, OrigPattern, Multiplex),
	%		member(p(2,0,2), Multiplex)    %% what happens in second round (2 has to be member twice) !!!
	%	),!
	%),
	NewDistance is Distance - 1,
	set2s(NewDistance, MultiplexLength, OrigPattern, Position).
	
calcThe2(MultiplexLength, MultiplexLength, p(2,0,2)) :- !.
calcThe2(Distance, MultiplexLength, The2) :-
	Length is MultiplexLength - Distance + 1,
	listOf(p(2,0,2), Length, The2).
	
% --- preprocess numbers --- %

preprocess_number(Constraint, Number) :-
	preprocess_number(Constraint, Number, []).

preprocess_number([], Number, Options) :-
	select(default(Default), Options, NewOptions),!,
	preprocess_number(Default, Number, NewOptions).
preprocess_number(Var, Var, Options) :-
	var(Var), !,
	memberchk(dontknow, Options, [name(to_come), optional]).
preprocess_number(Number, Number, Options) :-
	number(Number), !,
	memberchk(0, Options, [name(to_come), optional]).
preprocess_number(Number, Number, Options) :-
	rational(Number), !,
	memberchk(0, Options, [name(to_come), optional]).
preprocess_number(Constraint, Number, Options) :-
	is_list(Constraint), !,
	string2Numbers(Constraint, NumberConstraint),
	preprocess_number_options(NumberConstraint, NumberConstraintWorkedOn, Options),
	member_NC(Number, NumberConstraintWorkedOn, Options).
preprocess_number(Atom, Number, Options) :-
	atom(Atom),!,
	name(Atom, String),
	preprocess_number(String, Number, Options).

string2Numbers(ConstraintString, Constraint) :-
	(
		dcg_number_constraint(Constraint, ConstraintString, []);
		throw(constraint_unclear)
	),!.

preprocess_number_options(Constraint, Constraint, []) :- !.
preprocess_number_options(Constraint, NewConstraint, [Option|Options]) :-
	preprocess_number_option(Constraint, ConstraintTmp, Option),
	preprocess_number_options(ConstraintTmp, NewConstraint, Options).

preprocess_number_option(Constraint, NewConstraint, max(Max)) :-
	numlist(1, Max, List),
	MaxConstraint = [list(List)],
	dcgh_merge_number_constraints_and(Constraint, MaxConstraint, NewConstraint), !.
preprocess_number_option(Constraint, Constraint, _) :- !.	

member_NC(_Number, _NumberConstraint, Options) :-
	memberchk(stop_if(Goal), Options),
	call(Goal), !,
	fail.
member_NC(Number, NumberConstraint, Options) :-
	memberchk(infinity(_Min), NumberConstraint), !,
	member_NC_infinity(Number, NumberConstraint, Options),
	memberchk(infinity, Options, [name(to_come), optional]).
member_NC(Number, NumberConstraint, Options) :-
	not(memberchk(infinity(_Min), NumberConstraint)),
	memberchk(list(List), NumberConstraint),
	length(List, Length),
	sort(List, ListSorted),
	member_NC_list(Number, ListSorted, Length, Options).
	
member_NC_list(Number, List, Length, Options) :-
	nth1_restricted(Pos, List, Number, Options),
	ToCome is Length - Pos,
	memberchk(ToCome, Options, [name(to_come), optional]).

member_NC_infinity(Number, NumberConstraint, Options) :-
	memberchk(list(List), NumberConstraint),
	sort(List, ListSorted),
	member_restricted(Number, ListSorted, Options).
member_NC_infinity(Number, NumberConstraint, Options) :-
	memberchk(infinity(Min), NumberConstraint),
	integer_gen(Min, Number, Options).

%%% --- short passes ---

float_to_shortpass(Throw, ShortPass) :-
	(number(Throw);rational(Throw)),!,
	ShortPass is round(Throw * 10)/10.
float_to_shortpass(p(Throw,Index,Original), p(ShortPass,Index,Original)) :-
	float_to_shortpass(Throw, ShortPass).

float_to_shortpass([],[]).
float_to_shortpass([Throw|Rest],[ShortPass|RestShort]) :-
	float_to_shortpass(Throw,ShortPass),
	float_to_shortpass(Rest, RestShort).

shortpass_to_pass(ShortPass,_,_,_,ShortPass) :- var(ShortPass),!.
shortpass_to_pass(Self, _, _, _, p(Self, 0, Self)) :- integer(Self).
shortpass_to_pass(p(Self, Zero, _), _, _, _, p(Self, Zero, Self)) :- 
	nonvar(Zero),
	Zero = 0,
	integer(Self).
shortpass_to_pass(p(ShortThrow), Length, Jugglers, MaxHeight, p(Throw, Index, Origen)) :-
	shortpass_to_pass(p(ShortThrow, _, _), Length, Jugglers, MaxHeight, p(Throw, Index, Origen)),
	Index > 0.
shortpass_to_pass(p(ShortThrow, Index), Length, Jugglers, MaxHeight, p(Throw, Index, Origen)) :-
	integer(Index),
	shortpass_to_pass(p(ShortThrow, Index, _), Length, Jugglers, MaxHeight, p(Throw, Index, Origen)).
shortpass_to_pass(p(ShortThrow, Index, Origen), Length, Jugglers, MaxHeight, p(Throw, Index, Origen)) :-
	(number(ShortThrow); rational(ShortThrow)),
	Prechator is Length * 1.0 / Jugglers,
	IndexMax is Jugglers - 1,
	MaxHeightSolo is MaxHeight + Length,
	float_to_shortpass(ShortThrow, ShortThrowShortend),
	between(1, IndexMax, Index),
	between(1, MaxHeightSolo, Origen),
    Throw is Origen - (Jugglers - Index) * Prechator,
	float_to_shortpass(Throw, ShortThrowShortend). 
shortpass_to_pass(p(Var), Length, Jugglers, MaxHeight, p(Throw, Index, Origen)) :-
	var(Var),
	shortpass_to_pass(p(Var, Index), Length, Jugglers, MaxHeight, p(Throw, Index, Origen)), 
    Index > 0.
shortpass_to_pass(p(Var, Zero), _, _, MaxHeight, p(Self, Zero, Self)) :-
	var(Var),
	Zero = 0,
	between(0, MaxHeight, Self).
shortpass_to_pass(p(Var, Index), Length, Jugglers, MaxHeight, p(Throw, Index, Origen)) :-
	var(Var),
	Prechator is Length * 1.0 / Jugglers,
	IndexMax is Jugglers - 1,
	MaxHeightSolo is MaxHeight + Length,
	between(1, IndexMax, Index),
	between(0, MaxHeightSolo, Origen),
    Throw is Origen - (Jugglers - Index) * Prechator,
	Throw >= 1,
	Throw =< MaxHeight.


shortpass_to_pass_dont(ShortPass,_,_,_,ShortPass) :- var(ShortPass), !.
shortpass_to_pass_dont(Self, _, _, _, p(Self, 0, Self)) :- integer(Self), !.
shortpass_to_pass_dont(p(Self, Zero, Self), _, _, _, p(Self, Zero, Self)) :- 
	nonvar(Zero),
	Zero = 0,
	integer(Self),!.
shortpass_to_pass_dont(p(ShortThrow), Length, Jugglers, MaxHeight, p(Throw, Index, Origen)) :-
	shortpass_to_pass_dont(p(ShortThrow, _, _), Length, Jugglers, MaxHeight, p(Throw, Index, Origen)).
shortpass_to_pass_dont(p(ShortThrow, Index), Length, Jugglers, MaxHeight, p(Throw, Index, Origen)) :-
	shortpass_to_pass_dont(p(ShortThrow, Index, _), Length, Jugglers, MaxHeight, p(Throw, Index, Origen)).
shortpass_to_pass_dont(p(ShortThrow, Index, Origen), Length, Jugglers, MaxHeight, p(Throw, NewIndex, NewOrigen)) :-
	number(ShortThrow),
	Prechator is Length * 1.0 / Jugglers,
	IndexMax is Jugglers - 1,
	MaxHeightSolo is MaxHeight + Length,
	float_to_shortpass(ShortThrow, ShortThrowShortend),
	(nonvar(Index) -> NewIndex = Index; true),
	(nonvar(Origen) -> NewOrigen = Origen; true),
	between(1, IndexMax, Index),
	between(1, MaxHeightSolo, Origen),
    Throw is Origen - (Jugglers - Index) * Prechator,
	float_to_shortpass(Throw, ShortThrowShortend), !.

	
convertShortPasses(ShortPass,Length,Persons,Max,Pass) :-
	convertShortPasses(ShortPass,positiv,Length,Persons,Max,Pass).
convertShortPassesDont(ShortPass,Length,Persons,Max,Pass) :-
	convertShortPasses(ShortPass,negativ,Length,Persons,Max,Pass).

convertShortPasses(Var,positiv,_,_,_,Var) :- var(Var), !.
convertShortPasses([],_,_,_,_,[]) :- !.
convertShortPasses([HeadShort|TailShort],ConstraintType,Length,Persons,Max,[Head|Tail]) :-
	convertShortPasses(HeadShort,ConstraintType,Length,Persons,Max,Head),
	convertShortPasses(TailShort,ConstraintType,Length,Persons,Max,Tail).
convertShortPasses(ShortPass,positiv,Length,Persons,Max,Pass) :-
	not(is_list(ShortPass)),
	shortpass_to_pass(ShortPass,Length,Persons,Max,Pass).
convertShortPasses(ShortPass,negativ,Length,Persons,Max,Pass) :-
	not(is_list(ShortPass)),!,
	(
		shortpass_to_pass_dont(ShortPass,Length,Persons,Max,Pass);
		Pass is -1 %% unconvertable
	),!.



%%% Siteswap Constraints Grammar rules %%%

% Bedingung -> Pattern [and Pattern]*
% Bedingung -> Pattern [or  Pattern]*
% Pattern   -> [Wurf | (Bedingung) ]+
% Wurf -> ...

% (4 4 and 1 (1p or 2p)) or 4 4 1
% ==> [[[4,4],[1,p(1)]],[[4,4],[1,p(2)]],[[4 4 1]]]

% [] --> [[[p(1)]]]
% [[[p(1)]]] --> [[[p(1)]],[[p(2)]]]
% [[[p(1)]],[[p(2)]]] --> [[[1,p(1)]],[[1,p(2)]]]
% [[[1,p(1)]],[[1,p(2)]]] --> [[[4,4],[1,p(1)]],[[4,4],[1,p(2)]]]
% [[[4,4],[1,p(1)]],[[4,4],[1,p(2)]]] --> [[[4,4],[1,p(1)]],[[4,4],[1,p(2)]],[[4 4 1]]]


% (1 and 2) (3 or 4): [] --> [[[3]],[[4]]] --> [[[1,3],[2,3]],[[1,4],[2,4]]]


%%% DCG Grammar %%%

dcg_constraint([[]]) -->
	dcg_whitespaces.
dcg_constraint(Constraint) -->
	dcg_pattern(Pattern),
	dcg_and_patterns(Patterns),
	{
		dcgh_merge_constraints(Pattern, Patterns, Constraint, and)
	}.
dcg_constraint(Constraint) -->
	dcg_pattern(Pattern),
	dcg_or_patterns(Patterns),
	{
		dcgh_merge_constraints(Pattern, Patterns, Constraint, or)
	}.

dcg_pattern(Constraint) -->
	dcg_whitespaces,
	dcg_throw_or_constraint(Throw),
	dcg_whitespaces,
	dcg_throws_or_constraints(Pattern),
	dcg_whitespaces,
	{
		dcgh_merge_constraints(Throw, Pattern, Constraint, concat)
	}.
	
dcg_and_patterns(NewConstraint) -->
	dcg_and,
	dcg_pattern(Pattern),
	dcg_and_patterns(Patterns),
	{
		dcgh_merge_constraints(Pattern, Patterns, NewConstraint, and)
	}.
dcg_and_patterns([]) -->
	[].
	
dcg_or_patterns(NewConstraint) -->
	dcg_or,
	dcg_pattern(Pattern),
	dcg_or_patterns(Patterns),
	{
		dcgh_merge_constraints(Pattern, Patterns, NewConstraint, or)
	}.
dcg_or_patterns([]) -->
	[].

dcg_throw_or_constraint([[[Throw]]]) -->
	dcg_throw(Throw).
dcg_throw_or_constraint(Multiplex) -->
	dcg_multiplex(Multiplex).
dcg_throw_or_constraint(Constraint) -->
	dcg_left_parenthesis,
	dcg_constraint(Constraint),
	dcg_right_parenthesis.
	
dcg_throws_or_constraints(NewConstraint) -->
	dcg_whitespace,
	dcg_whitespaces,
	dcg_throw_or_constraint(Constraint),
	dcg_throws_or_constraints(Constraints),
	{
		dcgh_merge_constraints(Constraint, Constraints, NewConstraint, concat)
	}.
dcg_throws_or_constraints([]) -->
	[].
	
dcg_multiplex(Multiplex) -->
	dcg_left_bracket,
	dcg_constraint(Constraint),
	dcg_right_bracket,
	{
		dcgh_constraint_to_multiplex(Constraint, Multiplex)
	}.


dcg_throw(T) -->
	dcg_self(T).
dcg_throw(T) -->
	dcg_pass(T).
	
dcg_self(p(_S,0)) -->
	dcg_underscore,
	dcg_s.	
dcg_self(p(S,0)) -->
	dcg_integer(S),
	dcg_s.
dcg_self(S) -->
	dcg_integer(S).
dcg_self(_) -->
	dcg_underscore.

dcg_pass(p(T,I,O)) -->	
	dcg_p,
	dcg_left_parenthesis,
	dcg_float(T),
	dcg_comma,
	dcg_integer(I),
	dcg_comma,
	dcg_integer(O),
	dcg_right_parenthesis.
dcg_pass(p(T,I)) -->	
	dcg_p,
	dcg_left_parenthesis,
	dcg_float(T),
	dcg_comma,
	dcg_integer(I),
	dcg_right_parenthesis.
dcg_pass(p(F,I)) -->
	dcg_number(F),
	dcg_p,
	dcg_integer(I).
dcg_pass(p(F))  -->
	dcg_number(F),
	dcg_p.
dcg_pass(p(F))  -->
	dcg_number(F),
	dcg_p,
	dcg_underscore.
dcg_pass(p(_))  -->
	dcg_underscore,
	dcg_p.
dcg_pass(p(_))  -->
	dcg_underscore,
	dcg_p,
	dcg_underscore.
dcg_pass(p(_,I))  -->
	dcg_underscore,
	dcg_p,
	dcg_integer(I).
dcg_pass(_) -->
	dcg_underscore.






dcg_number_constraint([]) -->
	dcg_whitespaces.
dcg_number_constraint(NewListOfNumbers) -->
	dcg_whitespaces,
	dcg_numbers(ListOfNumbers),
	dcg_whitespaces,
	dcg_and_numbers(AndListOfNumbers),
	{
		dcgh_merge_number_constraints_and(ListOfNumbers, AndListOfNumbers, NewListOfNumbers)
	}.
dcg_number_constraint(NewListOfNumbers) -->	
	dcg_whitespaces,
	dcg_numbers(ListOfNumbers),
	dcg_whitespaces,
	dcg_or_numbers(OrListOfNumbers),
	{
		dcgh_merge_number_constraints_or(ListOfNumbers, OrListOfNumbers, NewListOfNumbers)
	}.

dcg_and_numbers(NewListOfNumbers) -->
	dcg_and,
	dcg_whitespaces,
	dcg_numbers(ListOfNumbers),
	dcg_whitespaces,
	dcg_and_numbers(AndListOfNumbers),
	{
		dcgh_merge_number_constraints_and(ListOfNumbers, AndListOfNumbers, NewListOfNumbers)
	}.
dcg_and_numbers([infinity(1)]) -->
	[].
	
dcg_or_numbers(NewListOfNumbers) -->
	dcg_or,
	dcg_whitespaces,
	dcg_numbers(ListOfNumbers),
	dcg_whitespaces,
	dcg_or_numbers(OrListOfNumbers),
	{
		dcgh_merge_number_constraints_or(ListOfNumbers, OrListOfNumbers, NewListOfNumbers)
	}.
dcg_or_numbers([]) -->
	[].


dcg_numbers(ListOfNumbers) -->
	dcg_left_parenthesis,
	dcg_number_constraint(ListOfNumbers),
	dcg_right_parenthesis.


dcg_numbers([list([I])]) -->
	dcg_integer(I).
dcg_numbers([list(List)]) -->
	dcg_integer(N),
	dcg_whitespaces,
	dcg_minus,
	dcg_whitespaces,
	dcg_integer(M),
	{
		numlist(N,M,List)
	}.
dcg_numbers([list(List)]) -->
	dcg_lt,
	dcg_whitespaces,
	dcg_integer(I),
	{
		Max is I - 1,
		numlist(1, Max, List)
	}.
dcg_numbers([infinity(Min)]) -->
	dcg_gt,
	dcg_whitespaces,
	dcg_integer(I),
	{
		Min is I + 1
	}.
dcg_numbers([infinity(Min)]) -->	
	dcg_integer(I),
	dcg_whitespaces,
	dcg_lt,
	{
		Min is I + 1
	}.
dcg_numbers([list(List)]) -->
	dcg_integer(I),
	dcg_whitespaces,
	dcg_gt,
	{
		Max is I - 1,
		numlist(1, Max, List)
	}.


dcg_float(I) -->
	dcg_integer(I).
dcg_float(R) -->
	{
		var(R), !
	},
	dcg_integer(I),
	dcg_dot,
	dcg_integer(F),
	{
		number_chars(F, NumberChars),
		length(NumberChars, Length),
		R is I + F / (10^Length)
	}.
dcg_float(R) -->
	{
		nonvar(R),
		I is round(float_integer_part(R)),
		F is float_fractional_part(R),
		F \= 0,
		F10 is round(F * 10)
	},
	dcg_integer(I),
	dcg_dot,
	dcg_integer(F10).
	
	
dcg_rational(Z) -->
	{
		var(Z)
	},
	dcg_integer(N1),
	dcg_slash,
	dcg_integer(N2),
	{
		Z is N1 / N2
	}.
dcg_rational(Z) -->
	{
		var(Z)
	},
	dcg_integer(N1),
	dcg_plus,
	dcg_integer(N2),
	dcg_slash,
	dcg_integer(N3),
	{
		Z is N1 + (N2 / N3)
	}.
dcg_rational(Z) -->
	{
		var(Z)
	},
	dcg_integer(N1),
	dcg_minus,
	dcg_integer(N2),
	dcg_slash,
	dcg_integer(N3),
	{
		Z is N1 - (N2 / N3)
	}.
dcg_rational(I) -->
	dcg_integer(I).

dcg_number(R) -->
	dcg_float(R).
dcg_number(Z) -->
	dcg_rational(Z).

dcg_number_neg(N) -->
	dcg_number(N).
dcg_number_neg(N_neg) -->
	dcg_minus,
	dcg_whitespaces,
	dcg_number(N),
	{
		N_neg is N * (-1)
	}.


dcg_and -->
	"and".
dcg_and -->
	"AND".
dcg_and -->
	",".
	
dcg_or -->
	"or".
dcg_or -->
	"OR".
dcg_or -->
	";".
	
	
dcg_left_parenthesis -->
	"(".
dcg_right_parenthesis -->
	")".

dcg_right_bracket -->
	"]".
dcg_left_bracket -->
	"[".	
	

dcg_underscore -->
	"_".
dcg_underscore -->
	"?".
dcg_underscore -->
	"*".
	
dcg_slash -->
	"/".

dcg_plus -->
	"+".

dcg_minus -->
	"-".
	
dcg_comma -->
	",".
	
dcg_gt -->
	">".
	
dcg_lt -->
	"<".
	

dcg_p -->
	"p".
dcg_p -->
	"P".
dcg_p -->
	"r".
dcg_p -->
	"R".
	

dcg_s -->
	"s".
dcg_s -->
	"S".

dcg_dot -->
	".".
	
dcg_whitespaces -->
	dcg_whitespace,
	dcg_whitespaces.
dcg_whitespaces -->
	[].
	
dcg_whitespace -->
	[W],
	{
		code_type(W, white)
	}.


dcg_integer(I) -->
	{
		var(I)
	},
	dcg_digit(D0),
	dcg_digits(D),
    { 
		number_codes(I, [D0|D])
    }.
dcg_integer(I) -->
    { 
		nonvar(I),
		number_codes(I, [D0|D])
    },
	dcg_digit(D0),
	dcg_digits(D).

dcg_digits([D0|D]) -->
	dcg_digit(D0), !,
	dcg_digits(D).
dcg_digits([]) -->
	[].

dcg_digit(D) -->
	{
		var(D)
	},
	[D],
	{ 
		code_type(D, digit)
	}.
dcg_digit(D) -->	
	{ 
		nonvar(D),
		code_type(D, digit)
	},
	[D].



%%% DCG Helpers %%%


%% Constraints in Normal Form!!!
%% Constraint = [[[a,b,c],[d]],[[g,h],[i,j,k]],[[l,m]]] = (a b c and d) or (g h and i j k) or l m
%% merge_Or( [[[a,b],[c]],[[d]]] , [[[e]],[[f,g],[h]]] ) = [[[a, b], [c]], [[d]], [[e]], [[f, g], [h]]]
%% merge_And( [[[a,b],[c]],[[d]]] , [[[e]],[[f,g],[h]]] ) = [[[a, b], [c], [e]], [[a, b], [c], [f, g], [h]], [[d], [e]], [[d], [f, g], [h]]]
%% merge_Concat( [[[a,b],[c]],[[d]]] , [[[e]],[[f,g],[h]]] ) = [[[a, b, e], [c, e]], [[a, b, f, g], [a, b, h], [c, f, g], [c, h]], [[d, e]], [[d, f, g], [d, h]]]

dcgh_merge_constraints([], C, C, _) :- !.
dcgh_merge_constraints(C, [], C, _) :- !.

dcgh_merge_constraints(ConstraintA, ConstraintB, NewConstraint, or) :- 
	append(ConstraintA, ConstraintB, NewConstraint), !.

dcgh_merge_constraints(ConstraintA, ConstraintB, NewConstraint, and) :-
	findall(
		NewOr,
		(
			member(OrA, ConstraintA),
			member(OrB, ConstraintB),
			append(OrA, OrB, NewOr)
		),
		NewConstraint
	), !.

dcgh_merge_constraints(ConstraintA, ConstraintB, NewConstraint, concat) :-
	findall(
		NewOr,
		(
			member(OrA, ConstraintA),
			member(OrB, ConstraintB),
			findall(
				NewAnd,
				(
					member(AndA, OrA),
					member(AndB, OrB),
					append(AndA, AndB, NewAnd)
				),
				NewOr
			)
		),
		NewConstraint
	), !.


dcgh_constraint_to_multiplex(Constraint, Multiplex) :-
	findall(
		NewOr,
		(
			member(Or, Constraint),
			findall(
				NewAnd,
				(
					member(And, Or),
					flatten(And, FlatAnd),
					NewAnd = [FlatAnd]
				),
				NewOr
			)
		),
		Multiplex
	), !.


%%%% merge Number Constraints %%%%

%%% NumberConstraint = [list([...]), infinity(N)]   "elements from list or greater equal N"

dcgh_merge_number_constraints_or([], C, C) :- !.
dcgh_merge_number_constraints_or(C, [], C) :- !.


dcgh_merge_number_constraints_or(ConstraintA, ConstraintB, NewConstraint) :- 
	dcgh_merge_number_lists_or(ConstraintA, ConstraintB, NewConstraintList),
	dcgh_merge_number_infinity_or(ConstraintA, ConstraintB, NewConstraintInfinity),
	dcgh_merge_number_list_infinity_or(NewConstraintList, NewConstraintInfinity, NewConstraint).
	
dcgh_merge_number_lists_or(ConstraintA, ConstraintB, [list(NewList)]) :-
	memberchk(list(ListA), ConstraintA),
	memberchk(list(ListB), ConstraintB), !,
	union(ListA, ListB, NewList).
dcgh_merge_number_lists_or(ConstraintA, _ConstraintB, [list(ListA)]) :-
	memberchk(list(ListA), ConstraintA), !.
dcgh_merge_number_lists_or(_ConstraintA, ConstraintB, [list(ListB)]) :-
	memberchk(list(ListB), ConstraintB), !.
dcgh_merge_number_lists_or(_ConstraintA, _ConstraintB, []) :- !.

dcgh_merge_number_infinity_or(ConstraintA, ConstraintB, [infinity(NewMin)]) :-
	memberchk(infinity(MinA), ConstraintA),
	memberchk(infinity(MinB), ConstraintB), !,
	NewMin is min(MinA, MinB).
dcgh_merge_number_infinity_or(ConstraintA, _ConstraintB, [infinity(MinA)]) :-
	memberchk(infinity(MinA), ConstraintA), !.
dcgh_merge_number_infinity_or(_ConstraintA, ConstraintB, [infinity(MinB)]) :-
	memberchk(infinity(MinB), ConstraintB), !.
dcgh_merge_number_infinity_or(_ConstraintA, _ConstraintB, []) :- !.

dcgh_merge_number_list_infinity_or([], ConstraintInfinity, ConstraintInfinity) :- !.
dcgh_merge_number_list_infinity_or(ConstraintList, [], ConstraintList) :- !.
dcgh_merge_number_list_infinity_or([list(List)], [infinity(Min)], [list(NewList), infinity(Min)]) :-
	copyList_if_smaller(List, Min, NewList).
	
	
	
dcgh_merge_number_constraints_and([], _C, []) :- !.
dcgh_merge_number_constraints_and(_C, [], []) :- !.
dcgh_merge_number_constraints_and([infinity(1)], C, C) :- !.
dcgh_merge_number_constraints_and(C, [infinity(1)], C) :- !.

dcgh_merge_number_constraints_and(ConstraintA, ConstraintB, NewConstraintClean) :- 
	dcgh_merge_number_intersect_all(ConstraintA, ConstraintB, NewConstraint),
	dcgh_merge_number_clean(NewConstraint, NewConstraintClean).

dcgh_merge_number_intersect_all(ConstraintA, ConstraintB, NewConstraint) :-
	findall(
		Intersection,
		(
			member(PartA, ConstraintA),
			member(PartB, ConstraintB),
			dcgh_merge_number_intersect_parts(PartA, PartB, Intersection)
		),
		NewConstraint
	).
	
dcgh_merge_number_intersect_parts(list(ListA), list(ListB), list(List)) :-
	intersection(ListA, ListB, List).
dcgh_merge_number_intersect_parts(infinity(MinA), infinity(MinB), infinity(Min)) :-
	Min is max(MinA, MinB).
dcgh_merge_number_intersect_parts(infinity(Min), list(ListB), list(List)) :-
	dcgh_merge_number_intersect_parts(list(ListB), infinity(Min), list(List)).
dcgh_merge_number_intersect_parts(list(ListA), infinity(Min), list(List)) :-
	copyList_if_bigger(ListA, Min, List).


dcgh_merge_number_clean(Constraint, [list(NewList), infinity(Min)]) :-
	memberchk(infinity(Min), Constraint),
	memberchk(list(_), Constraint), !,
	dcgh_merge_number_clean_lists(Constraint, NewList).
dcgh_merge_number_clean(Constraint, [list(NewList)]) :-
	memberchk(list(_), Constraint), !,
	dcgh_merge_number_clean_lists(Constraint, NewList).
dcgh_merge_number_clean(Constraint, Constraint) :- !.
	
dcgh_merge_number_clean_lists(Constraint, NewList) :-
	findall(
		List,
		member(list(List), Constraint),
		ListOfLists
	),
	flatten(ListOfLists, ListOfListsFlat),
	list_to_set(ListOfListsFlat, NewList).
	
	


%% http://gollem.science.uva.nl/SWI-Prolog/pldoc/doc_for?object=section%282%2c%20%274.12%27%2c%20%27%2fusr%2flib%2fpl-5.6.51%2fdoc%2fManual%2fDCG.html%27%29

