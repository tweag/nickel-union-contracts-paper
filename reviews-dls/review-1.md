# Overall

- Merit: Weak Reject
- Expertise: Expert

# Paper summary

This paper pressents an acounting of union and intersection contracts, using Nickel code to illustate the main points.

## Comments for author

Overall, I very much appreciate the energy and effort, discussion and goals of the paper. I have a number of criticisms of the current paper, however, that make it hard for me to endorse publication in its current form. While I have given the paper a C, the boundary between a B and C is a more accurate description of my current position.

Here are the most major criticisms I have:

- there seems to be some confusion about side-effects. In particular, the paper
  make a big deal of the effect that's hiding inside a union contract while
  (seemingly) ignoring the effect of signaling a contract violation itself. From
  what I understand, these two are not different from the perspective of
  optimizations.

  For example, the comment "even in a pure setting" at the end of 2 makes little
  sense to me because contracts raise errors which is generally considered to be
  impure. That is, regular old contracts (no ands or ors) would also be
  problematic for moving computations around.

- I think that lumping in "user defined contracts" and contracts like the one
   in figure 15 is confusing almost to the point of being inaccurate. There are
   many many useful simple contracts that interrogate only first-order
   properties of values, e.g. limiting integers to specific ranges or functions
   to having certain arities or lists to having certain lengths. These contracts
   do not need to invoke "unknown" code the way that a predicate \f. f 0 == 0
   would. In between contracts that query simple properties and contracts like
   \f. f 0 == 0 are contracts like \l. hd(l) > 0 that might be applied to empty
   lists (that is, contracts that themselves might have contract violations in
   them). All three of these seem different and lumping them together is not an
   act of clarification.

   Also worth noting is that Dimoulas's work deals extensively with these kinds
   of contracts and there is no mention of it in this paper. His POPL 2011 and
   ESOP 2012 papers are relevant to such contracts.

- I find the discussion of figure 16 a bit too quick. One might say that f
  should really be a function that accepts two arguments, not a curried
  function. If that were to be the case, and if Keil & Thiemann's semantics has
  multi-arity functions, wouldn't the example work the way the programmer might
  wish? That is, the issue here is that the intersection is disambiguated on
  the first application and cannot change on the second one (but that's not
  what's desired)? Could one not say that the flaw in the design then, is that
  currying has replaced n-ary functions? (I do not mean to take a position on
  which is the greater flaw, merely to wonder what the authors think here and
  see if this kind of thinking is either bogus or clarifying.)

Beyond the more serious comments above, there were a number of places where I was frustrated when reading, just didn't understand, or think that the paper should change in minor ways, detailed below.

Frustratingly, the first example where I was hoping to get used to the syntax of Nickel raises more questions than it answers (figures 1a and b):

- there appears to be a line that wraps? That seems bad

- what is the order of arguments to list.fold? (Why is using a combinator library a good idea here?)

- is there code missing? I see an "in" on the end of a line that binds hosts and then nothing seems to be in the body of the corresponding let.

- is the ellipses surrounded by square brackets intended to mean that the code in figure 1a should be copied into figure 1b? All of it or just some? Why do this anyway, as there is a lot of whitespace in figure 1?

The spacing around citations is inconsistent ("Eiffel programming language[16]" vs "Enter contracts [11]"). I think a non-breaking space is standard.

The example in figure 3 being motivated by performance seems a bit strange since the program has the wrong asymptotic complexity (sublist checking does not need to be quadratic).

It also looks like there is some currying going on in the elem function? And again there is a dangling "in"? I don't know what's going on with this. Why is there an "in" for elem but not for subList?

I don't understand why the title of 2.2 is "Referential transparency". It seems to be about optimizations.

The commas in the first sentence of 3 are not in the right places.

In figure 8 there seems to be an unmatched close curly brace.

I don't get why appendDate has to append a string. The result contract says just "list"; it isn't the same as the argument so why are the elements of the result contrained at all? I am assuming that lists.cons (but this isn't said and also the arguments to cons are in the opposite order from what I would have expected) does not mutate its arguments. Could that be why?

The text in the column below figure 12, suggests that union contracts breaks the "optimization" shown in figure 5. But this is already broken for just regular contracts (or io, or non-termination, or any effect). If there are no calls to the f' in figure 5, then we go from zero calls to g to one call to g via the transformation in figure 5. This is unsound as soon as the input y breaks the contract on g. The example in figure 13 however, does not have this problem as far as I can tell and it illustrates the point well.

In 4.2, the text uses hyphens in correctly. When setting off text ala parentheses, you should use em-dashes, not hyphens.

In 5.1, please do not treat citations as parts of speech. Instead of "[14] give a coninductively ..." please write something like "Keil and Thiemann [14] give a coninductively ...". There are a number of places along these lines that need to be fixed.

"is compatible with user-defined contract" => "is compatible with user-defined contracts"

I can't figure out what the first sentence of 5.3 is saying. What does "is [22]" mean?
