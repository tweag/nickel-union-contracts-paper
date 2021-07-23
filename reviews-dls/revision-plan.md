# Revision plan

## Answer to reviewer 1

### Effects

**review summary**

Reviewer 1 notices that we insist on union and intersection contracts
introducing side-effects, but plain contracts already exhibit side-effects
because of `blame`. In particular, a comment says "even in a pure setting" at
the end of section 2. They further remark that the transformation of Figure 13
is already invalid in general with plain contracts.

**answer**

Let us first say that we agree with the reviewer on the following points:

- Plain contracts without unions or intersections already introduce effects.
- The CSE equivalence is not valid in all generality (equation (1) line 387)
  already just with plain contracts, in a strict evaluation setting (call-by-value).
- It is unfortunate that we mention the let-floating optimization
  of Figure 5 in Section 4 (L630) as an example of an optimization invalidated
  by union and intersection contracts as it is indeed already invalid in a
  strict language with plain contracts.

The end of Subsection 2.2 and the discussion around Figure 13 are a bit
imprecise with respect to this aspect.

Nonetheless, we think the effects introduced by plain contracts and union and
intersection contracts are crucially of very different nature:

- The `blame` of plain contracts (forgetting error messages) is semantically
  equivalent to non-termination (partiality).
- Union and intersection contracts are akin to shared state.

With the following consequences:

- Plain contracts preserve referential transparency, while union and
  intersection contracts do not. It is actually not uncommon to deem a language
  featuring non-termination as pure, like Haskell or the untyped
  lambda-calculus, hence the "even in a pure setting".
- If the base language already features non-termination (this is the case of
  Nickel, which contains the untyped lambda-calculus), adding plain contracts do
  not make it "less pure", as opposed to adding union and insertion contracts.

Concerning the CSE optimization, we would also like to make the following
observation:

- In a lazy setting (call-by-need), the general CSE equivalence (eq 1. L 387) is
  actually valid even with plain contracts or non-termination.
- In a strict setting (call-by-value), it isn't in all generality, because
  the transformation can cause previously unevaluated sub-expressions to be
  evaluated by pulling them out of functions. However, slight restrictions on
  the context `M` suffice to make it safe (typically, do not pull an expression
  out of its scope). This is not the case once one adds union and intersection
  contracts.

**revision plan**

### Custom contracts

**review summary**

Reviewer 1 mentions that we treat user-defined contracts as one block, while
there are in fact different possible variations, so to speak: first-order flat
contracts for example seem restricted enough to avoid the difficulties of
combining them with union and intersection contracts. One level up are contracts
that are still first-order but can trigger other contracts violation, like `\l.
hd(l) > 0`.

**answer**

There are many useful contracts that are first-order, indeed. This is probably
the case for most use cases of Nickel.

In practice, there doesn't appear to be a simple, natural way of enforcing that
user-defined contracts do not apply their argument. In any dynamically typed (or
gradually typed) functional language like Nickel, functions and function
application are first class, and it doesn't seem so easy to forbid their use
without resorting to an ad-hoc operational mechanism to track contracts argument
and error out on application.

Another solution would be to define user-defined contracts not as general
functions, but by using a limited set of combinators. That would nonetheless
greatly limit the expressive power and extensibility of user-defined contracts.
This is a problem for validation purpose, as schemas are diverse and
domain-specific.

**revision plan**

### Currying and intersections

**review summary**

Reviewer 1 argues that the discussion of Figure 16 is missing the currying
aspect: shouldn't the function take a tuple as an argument instead of being
curried? In that case, could one not say that the flaw in the design then, is
that currying has replaced n-ary functions?

**answer**

The programmer could write an n-ary function instead of a curried one to
overcome the issue, but we are not sure it is the right solution to the problem.

Without entering the debate of currying by default (which is the most pervasive
choice among functional languages today and surely very handy combined with
partial application), we think the fundamental issue is that the equivalence
`A -> B /\ A -> C ~= A -> (B \/ C)` is not valid in the co-inductive semantics.

The point of dynamic checking mechanisms like contracts is to check that a term
satisfies an external specification without imposing any restriction on its
structure or intermediate states. It makes it much more flexible than a static
typing approach, which imposes rigid rules on the whole content term.
Set-theoretic functions validate the equivalence `A -> B /\ A -> ~= A -> (B \/
C)`, so one could expect that a semantics for full-fledged union and
intersection contracts would validate the equivalence too, or at least imagine
that there exists a semantics that do so.

**revision plan**

## Answer to reviewer 3

### Combining user-defined contracts with unions and intersections

**review summary**

The discussion of the incompatibility between user-defined contracts and union
and intersection contracts is unclear. Section 4.2 claims it is "not obvious",
while Section 4 talks about "fundamental incompatibilities". The algorithmic
system of Keil and Thiemann presented in Section 5 does combine user-defined
contracts and full-fledged union and intersection contracts.

**answer**

Section 4.2 follows a natural path to fix a naive implementation of union and
intersection contracts, by adding shared state in the picture. We notice that
accommodating for user-defined contracts in this setting is non-obvious. Wadler
et al. followed this path too and decided to drop user-defined contracts
altogether. However it is not fundamentally impossible to do so, even in the
approach of Wadler et al.'.

This trade-off gains Wadler et al. a more uniform and in general simpler
operational semantics than Keil and Thiemann's system, as stated at line 862.
That also means easier to implement. On the other hand, Kiel and Thiemann's
system is the most complete one (supporting both general union and intersection
contracts and user-defined contracts) but also the most complex one. The
algorithmic version of their system, which is the one that can be implemented,
is fairly complex, and present many performance challenges (L852). In
particular, line 849 mentions one dramatic consequence of supporting
user-defined contracts on their system: the evaluation of function contracts
requires the inspection of the whole *context* of an application, that is, the
continuation. This looks like a pretty heavy operation to implement.

**revision plan**

### Castagna et al.

**review summary**

The reviewer is disappointed by the short and superficial treatment of the work
of Castagna et al., in particular with respect to the referential transparency
aspect.

**answer**

There is confusion on our part about the citation of the work of Castagna et al.
[10] (Gradual Typing: a new perspective). We actually intended to rather cite
their previous work on which the latter one build upon: Gradual Types with Union
and Intersection (Castagna and Lanvin).

In Castagna and Lanvin, they introduce a typed functional language which
supports gradual typing with union and intersection types (more generally,
set-theoretic types). They use abstract interpretation to derive their
semantics, and in their own words, "the resulting definitions are quite
technical and barely intuitive but they have the properties we seek for".

Because of the complexity of their semantics, we were not able precisely assess
what their semantics really implement in practice, and especially how it
compares to the co-inductive semantics of Kiel and Thiemann.

Wadler et al. [22] also cites Castagna and Lanvin in rather general terms,
concluding: "The calculus does not consider blame (using cast errors instead)
and their choice of operational semantics prevents the statement of a useful
blame theorem."

We thus contacted one of the author directly. While they were themselves not
sure how the two semantics compare, they think their semantics is likely to be
less expressive than the co-inductive semantics. That is, there may exist terms
that would succeed in the system of Kiel that Thiemann would fail once
translated in the system of Castagna et al.

Concerning [10], the paper originally cited in our submission, it adds
polymorphism compared to Castagna and Lanvin, but at the expense of restrictions
on intersections. In particular, it is not possible to assign intersection types
to a function, as stated in their future work section.

**revision plan**

## Draft notes

- Change the example of "fonction on union -> intersection of functions"
- Change the sentence of "even in a pure setting".
