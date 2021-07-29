# Revision plan

We thank the reviewers for their valuable comments. In addition to the
various small improvement suggested, that we have implemented, find
answers to specific questions below.

## Answer to reviewer 1

### Effects

**review summary**

Reviewer 1 notices that we insist on union and intersection contracts
introducing side-effects, but plain contracts already exhibit side-effects
because of `blame`. In particular, the paper says "even in a pure setting" in a
comment at the end of section 2. They further remark that the transformation of
Figure 13 is already invalid in general with plain contracts.

**answer**

Let us first say that we agree with the reviewer on the following points:

- Plain contracts without unions or intersections already introduce effects.
- The CSE equivalence is not valid in all generality (equation (1) line 387)
  just with plain contracts already, in a strict evaluation setting
  (call-by-value).
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

- We will rework the end of Section 2.2 ("even in a pure setting") to make things clearer.
- We will remove the specific mention to let-floating.

### Custom contracts

**review summary**

Reviewer 1 mentions that we treat user-defined contracts as one block, while
there are in fact different possible variations, so to speak: first-order flat
contracts for example seem restricted enough to avoid the difficulties of
combining them with union and intersection contracts.

In addition, they mention Dimoulas's POLP11 and ESOP12 papers as a relevant source.

**answer**

There are many useful contracts that are first-order, indeed. This is
probably the case for most use cases of Nickel. But it's not obvious
how to have one without having the other. A language may choose to
ignore the problematic contracts, though, we don't have an example of
such an approach except for Racket's, which makes much bigger
sacrifices. Ultimately, user-defined contracts are hard to reason
about formally, which is probably why Williams et al eschew them
completely. So we stand by this point

Regarding Dimoulas's papers, their work presents a solution
for contracts that may, arbitrarily, break other contracts in their
evaluation. Although this looks related to this problem with
intersection and user-defined contracts, it is not clear how to
leverage Dimoulas's techniques for intersection in practice.

It's worth noting, for instance, that Dimoulas's systems behave by getting stuck
in the case an undesired event happens (a contract fails because of external,
semantically unrelated, values flow in). With unions and intersections as
developed by Keil and Thiemann, the expected outcome is rather to not execute a
contract under the wrong context.

**revision plan**

Answering these points in details seem to bring us out of the scope of
the paper. So we propose to not address them in the revised version.

### Currying and intersections

**review summary**

Reviewer 1 argues that the discussion of Figure 16 is missing the currying
aspect: shouldn't the function take a tuple as an argument instead of being
curried? In that case, could one not say that the flaw in the design then, is
that currying has replaced n-ary functions?

**answer**

If the programmer writes n-ary functions uncurried, in Kiel and
Thiemann's system, they will indeed not run into the problem of
Figure 16. This doesn't change our point that the support for
overloading is limited as it doesn't always work for curried
functions.

**revision plan**

We will clarify that uncurrying is a workaround. Beyond this, we
consider a curried vs uncurried discussion doesn't belong to the
paper.

### Others

- `appendDate` example: indeed, the output type of `appendDate` was
  wrong. It has been fixed in the revision proposal.

## Answer to reviewer 3

### Combining user-defined contracts with unions and intersections

**review summary**

The discussion of the incompatibility between user-defined contracts
and the shared-state implementation of intersection is
unclear. Section 4.2 claims it is "not obvious", while Section 4 talks
about "fundamental incompatibilities". The algorithmic system of Keil
and Thiemann presented in Section 5 does combine user-defined
contracts and union and intersection contracts.

**answer**

We agree: this is unfortunate. In this respect, Section 4.2 is right
(in essence, it's the problem that Keil and Thiemann solve). So the
wording at the beginning of Section 4 is inaccurate. While most of the
other properties we discuss are about incompatibilities with the
semantic of contracts, the discussion in 4.2 led us to discuss how
it's difficult to preserve said semantics in a particular
implementation strategy.

**revision plan**

We will tame the "fundamentally incompatible" wording.

### Castagna et al.

**review summary**

The reviewer is disappointed by the short treatment of the work of
Castagna et al., in particular with respect to the referential
transparency aspect.

**answer**

There is a mistake on our part about the citation of the work of Castagna et al.
[10] (Gradual Typing: a new perspective). We actually intended to rather cite
their previous work on which the latter one build upon: Gradual Types with Union
and Intersection (Castagna and Lanvin).

In Castagna and Lanvin, they introduce a typed functional language which
supports gradual typing with union and intersection types (more generally,
set-theoretic types). They use abstract interpretation to derive their
semantics, and in their own words, "the resulting definitions are quite
technical and barely intuitive but they have the properties we seek".

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
translated in the system of Castagna et al. This is why we prefer to
remain prudent on the comparison.

Concerning [10], the paper originally cited in our submission, it adds
polymorphism compared to Castagna and Lanvin, but at the expense of restrictions
on intersections. In particular, it is not possible to assign intersection types
to a function, as stated in their future work section.

**revision plan**

We will expand the discussion on Castagna et al. with some of the
remarks in this answer.
