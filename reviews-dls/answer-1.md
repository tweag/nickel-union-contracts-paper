# Answer to reviewer 1

## Answers to Comments for author

> there seems to be some confusion about side-effects. In particular, the paper
> make a big deal of the effect that's hiding inside a union contract while
> (seemingly) ignoring the effect of signaling a contract violation itself. From
> what I understand, these two are not different from the perspective of
> optimizations.

Indeed, `blame` is already a side-effect. However, it is of different nature
than the one introduced by unions and intersections (if we forget the error
messages and just consider `blame` as a basic failure mechanism): semantically,
`blame` is equivalent to having `bottom` in the semantics, that is the same as
non-termination. While non-termination is arguably an effect, it is much more
well-behaved that unions/intersections (that are rather like shared state):
crucially, it doesn't invalidate referential transparency. Adding `blame` to any
language with general recursion thus doesn't make it "less pure". For example,
Haskell is deemed as pure, even if it has non-termination.

> For example, the comment "even in a pure setting" at the end of 2 makes little
> sense to me because contracts raise errors which is generally considered to be
> impure. That is, regular old contracts (no ands or ors) would also be
> problematic for moving computations around.

The reviewer does have a point that in call-by-value, `blame` (or
non-termination) only is sufficient to invalidate general CSE/let-floating:

```
(\xy. 0) (\x. bottom) (\x. bottom) !~= let z = bottom in (\xy.0) (\x. z) (\x. z)
```

It can cause the evaluation of subterms that were previously hidden inside an
non-applied abstraction. Still, CSE can be done more largely (just don't float
expressions out of functions e.g.) than with unions and intersections. Turning
CSEd expressions to lazy values may also do the trick.

What's more, in Nickel's call-by-need setting, plain general CSE and inlinling
are still valid even with `blame`, because these transformations preserve what
terms get evaluated or not.

> I think that lumping in "user defined contracts" and contracts like the one
> in figure 15 is confusing almost to the point of being inaccurate. There are
> many many useful simple contracts that interrogate only first-order
> properties of values, e.g. limiting integers to specific ranges or functions
> to having certain arities or lists to having certain lengths. These contracts
> do not need to invoke "unknown" code the way that a predicate \f. f 0 == 0
> would. In between contracts that query simple properties and contracts like
> \f. f 0 == 0 are contracts like \l. hd(l) > 0 that might be applied to empty
> lists (that is, contracts that themselves might have contract violations in
> them). All three of these seem different and lumping them together is not an
> act of clarification.

While I agree that given our use-case we could consider only first-oder custom
contracts at first, I don't agree about list contracts. Custom contracts on
lists and records sound like a natural and useful thing to do and do potentially
trigger other contracts violation, so problem is still there.

Another question is how easily can we impose such a restriction in practice
(only first-order contracts / exclude custom contracts on lists or record
contracts e.g.) without making the system either much more complicated or much
more restrictive. It doesn't look obvious at first sight.

> Also worth noting is that Dimoulas's work deals extensively with these kinds
> of contracts and there is no mention of it in this paper. His POPL 2011 and
> ESOP 2012 papers are relevant to such contracts.

TODO: read.

**POPL 11:** https://www2.ccs.neu.edu/racket/pubs/popl11-dfff.pdf

*Teo*
I read the POPL 11, and I think I understand what he aims at, but it's not
really applicable for unions/inter. In particular, the Dimoulas paper
states different strategies for treating dependent function contracts,
by changing how the argument that is passed to the codomain contract is wrapped
with the domain contract: either not wrapped at all, wrapped the same
as the argument that is passed to the original function, or wrapped with a
change of labels, where now the context is the contract, and not the original
context.

I think it has little applicatio value to U/I, since in our case we have
to wrap a single value, with two contracts.
In Dimoulas notation, an Inter contract could look something like:
mon[k,l,j](A /\ B, v) := mon[k,l,j](A, mon\[k,\*,j\](B))
Where the asterisk could be, according to reviewer 1, j, so
if the context of mon\[k,\*,j\](B), the contract gets blamed, but
values may flow in from the outer context, and the we'd want to blame 
l.

**ESOP 12:** https://www2.ccs.neu.edu/racket/pubs/esop12-dthf.pdf

> I find the discussion of figure 16 a bit too quick. One might say that f
> should really be a function that accepts two arguments, not a curried
> function. If that were to be the case, and if Keil & Thiemann's semantics has
> multi-arity functions, wouldn't the example work the way the programmer might
> wish? That is, the issue here is that the intersection is disambiguated on
> the first application and cannot change on the second one (but that's not
> what's desired)? Could one not say that the flaw in the design then, is that
> currying has replaced n-ary functions? (I do not mean to take a position on
> which is the greater flaw, merely to wonder what the authors think here and
> see if this kind of thinking is either bogus or clarifying.)

I don't think the problem is about currying vs non-currying. Sure, the
programmer could write a n-ary function to overcome this issue, but this sound
like a work-around rather than some right or natural way to do it. Forgetting
the general debate about currying, the issue is that the semantics doesn't
validate the equation `A -> B /\ A -> C ~= A -> (B \/ C)`, which is validated
e.g. by set theoretic functions and thus could be intuitively expected from the
user (could we find a realizers-based semantics that validate this?).

## Correction proposal

- **Effects**: Add one sentence or two explaining
  why `blame` with plain contracts is a different effect than union and
  intersection contracts at the end of section 2.

## Answers to minor corrections

> Frustratingly, the first example where I was hoping to get used to the syntax of Nickel raises more questions than it answers (figures 1a and b):
>
> - there appears to be a line that wraps? That seems bad

I inserted a new line appropriately.

> what is the order of arguments to list.fold? (Why is using a combinator library a good idea here?)

The standard one? I think it's pretty clear from the types and arguments names?

> - is there code missing? I see an "in" on the end of a line that binds hosts and then nothing seems to be in the body of the corresponding let.

It's just the ML syntax. We could put the `in` on a newline for people that are
not familiar with it, but it will get us quite a lot of newlines.

> - is the ellipses surrounded by square brackets intended to mean that the code in figure 1a should be copied into figure 1b? All of it or just some? Why do this anyway, as there is a lot of whitespace in figure 1?

I reproduced the identical code in grey.

> The spacing around citations is inconsistent ("Eiffel programming language[16]" vs "Enter contracts [11]"). I think a non-breaking space is standard.

Fixed this one, but we'll probably have to make a whole pass on citations.

> The example in figure 3 being motivated by performance seems a bit strange since the program has the wrong asymptotic complexity (sublist checking does not need to be quadratic).

Yes...and? This is just a contrived example of inlining, not an example of an
optimal algorithm.

> It also looks like there is some currying going on in the elem function? And again there is a dangling "in"? I don't know what's going on with this. Why is there an "in" for elem but not for subList?

Indeed sublist doesn't have a corresponding in, which is not valid Nickel
syntax, although it is valid in ML. I had this problems in several example: I
just wanted to define an example function at top-level, so `let .. in ..`
doesn't make sense, but we don't have just "let" in nickel.

> I don't understand why the title of 2.2 is "Referential transparency". It seems to be about optimizations.

> The commas in the first sentence of 3 are not in the right places.

Done.

> In figure 8 there seems to be an unmatched close curly brace.

Removed.

> I don't get why appendDate has to append a string. The result contract says just "list"; it isn't the same as the argument so why are the elements of the result contrained at all? I am assuming that lists.cons (but this isn't said and also the arguments to cons are in the opposite order from what I would have expected) does not mutate its arguments. Could that be why?

They are right, the example is bogus as it is. The point is rather than we can
only assume that an element we pull from the list is a string. We have to rework
this part a bit.

> The text in the column below figure 12, suggests that union contracts breaks the "optimization" shown in figure 5. But this is already broken for just regular contracts (or io, or non-termination, or any effect). If there are no calls to the f' in figure 5, then we go from zero calls to g to one call to g via the transformation in figure 5. This is unsound as soon as the input y breaks the contract on g. The example in figure 13 however, does not have this problem as far as I can tell and it illustrates the point well.

The point was made in comments for author and they are right in a CBV setting.

> In 4.2, the text uses hyphens in correctly. When setting off text ala parentheses, you should use em-dashes, not hyphens.

Done.

> In 5.1, please do not treat citations as parts of speech. Instead of "[14] give a coninductively ..." please write something like "Keil and Thiemann [14] give a coninductively ...". There are a number of places along these lines that need to be fixed.

Todo. Require a full pass.

> "is compatible with user-defined contract" => "is compatible with user-defined contracts"

Done.

> I can't figure out what the first sentence of 5.3 is saying. What does "is [22]" mean?

Added a few words.
