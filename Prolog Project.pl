

main:-
build_kb,
play.

build_kb:-
write('Welcome to Pro-Wordle!
----------------------
Please enter a word and its category on separate lines:'),nl,
read(W),
((W = done,write('Done building the words database...'));
(read(C),
(C = done , write('Done building the words database...');
assert(word(W,C)), build_kbhelper))).

build_kbhelper:-
write('Please enter a word and its category on separate lines:'),nl,
read(W),
((W = done,write('Done building the words database...'));
(read(C),
(C = done , write('Done building the words database...');
assert(word(W,C)), build_kbhelper))).

play:- 
write('The available categories are: '),
categories(L),
write(L),nl,
write('Choose a category: '),nl,
read(C),
(\+is_category(C),write('This category does not exist. '),play;
is_category(C),playLength(C)).

playLength(C):-
write('Choose a length:'),nl,read(Length),
(\+available_length(Length),write('There are no words of this length. ')
,nl,playLength(C);
available_length(Length),Guesses is Length+1,
write('Game started. You have '),
write(Guesses),
write(' guesses.'),nl,
startPlaying(Guesses,Length,C)).

startPlaying(1,L,C):-
pick_word(CorrectWord,L,C),
write('Enter a word composed of '),
write(L),
write(' letters: '),nl,
read(W),
(W==CorrectWord,write('You Won!');write('You lost!'),nl).

startPlaying(G,L,C):-
pick_word(CorrectWord,L,C),
write('Enter a word composed of '),
write(L),
write(' letters: '),nl,
read(W),
atom_length(W,X),
(W==CorrectWord,write('You Won!'),nl
;
X\==L,write('Word is not composed of '),write(L),
write(' letters. Try again.'),nl,write('Remaining Guesses are '),write(G),nl,nl,
startPlaying(G,L,C)
;
string_chars(W,W2),
string_chars(CorrectWord,CorrectWord2),
correct_letters(W2,CorrectWord2,CorrectLetters),
correct_positions(W2,CorrectWord2,CorrectLettersInPosition),
write('Correct letters are: '),write(CorrectLetters),nl,
write('Correct letters in correct positions are: '),
write(CorrectLettersInPosition),nl,
G1 is G-1,
write('Remaining Guesses are '),
write(G1),nl,nl,
startPlaying(G1,L,C)
).


is_category(C):- % Succesful
word(_,C);
false.

is_word(W):- %Succesful
word(W,_);
false.

available_length(L):- % Succesful
word(W,_),
atom_length(W,X),
X==L.				

pick_word_helper(W,L):- % Succesful
is_word(W),
atom_length(W,X),
X==L.

pick_word(W,L,C):- % Succesful
word(W,C),
pick_word_helper(W,L).


categories(L):-  %Succesful
findall(C,word(_,C),L1),
remove_duplicates(L1,L).

correct_letters(L1,L2,CL):- %Succesful
intersection(L1,L2,CL).

correct_positions([H1|T1],[H2|T2],PL):- %Succesful
correct_positions(T1,T2,PL1),
intersection([H1],[H2],H3),
append(H3,PL1,PL).

correct_positions([],_,[]).
correct_positions(_,[],[]).

remove_duplicates([], []).

remove_duplicates([H|T],R) :-
    member(H,T), !,
    remove_duplicates(T,R).

remove_duplicates([H|T], [H|R]) :-
    remove_duplicates(T,R).