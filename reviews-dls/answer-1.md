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
like a work-around rather than some righter way to do it. Forgetting the general
debate about currying, the issue is that the semantics doesn't validate the
equation `A -> B /\ A -> C ~= A -> (B \/ C)`, which is validated e.g. by set
theoretic functions and thus could be intuitively expected from the user (could
we find a realizers-based semantics that validate this?).

## Correction proposal

- **Effects**: Add one sentence or two explaining
  why `blame` with plain contracts is a different effect than union and
  intersection contracts at the end of section 2.
