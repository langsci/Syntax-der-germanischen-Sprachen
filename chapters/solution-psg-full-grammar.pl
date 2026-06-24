:- discontiguous np/2.
:- discontiguous n1/2.

% This grammar cannot be parsed with the built-in DCG parser of Prolog.
% Do you have an idea why this is the case?
%
% You can whatch Prolog while it is trying to parse a phrase.
%
% Try: trace,np([das,kind],[]).
% and  trace,np([das,kind,aus,paris],[]).

% Lexicon
det --> [das].
det --> [der].
det --> [des].
det --> [ein].
det --> [eine].
n1 --> [allgäu].
n1 --> [ankunft].
n1 --> [kind].
n1 --> [lied].
n1 --> [zuges].
n  --> [ankunft].
np --> [paris].
a --> [singende].
p --> [aus].
p --> [in].
p --> [vor].
ap --> [kurz].


% phrase structure rules

np --> det, n1.
np --> n1, pp.
n1 --> n1, pp.
n1 --> ap, n1.
n1 --> n, np.

pp --> ap, p1.
pp --> np, p1.
pp --> p1.
p1 --> p, np.

ap --> a1.
a1 --> np, a.




% test with
pp([eine,stunde,vor,der,ankunft,des,zuges],[]).
pp([kurz,nach,der,ankunft,in,paris],[]).
np([das,ein,lied,singende,kind,aus,dem,allgäu],[]).

np(X,[]),write(X),nl,fail.
