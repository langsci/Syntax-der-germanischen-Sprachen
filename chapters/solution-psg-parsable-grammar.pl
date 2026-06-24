:- discontiguous np/2.
:- discontiguous n1/2.


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
%a --> [singende].
p --> [aus].
p --> [in].
p --> [vor].
ap --> [kurz].


% phrase structure rules

np --> det, n1.
np --> n1, pp.
%n1 --> n1, pp.
n1 --> ap, n1.
n1 --> n, np.

pp --> ap, p1.
%pp --> np, p1.
pp --> p1.
p1 --> p, np.

%ap --> a1.
%a1 --> np, a.




% test with
pp([vor,der,ankunft,des,zuges],[]).
pp([kurz,vor,der,ankunft],[]).
np([das,kind,aus,dem,allgäu],[]).

np(X,[]),write(X),nl,fail.
