# Answer to reviewer 3

## Comments for author

> The discussion of intersection contracts and the limitations of user-defined
> contracts is a little unclear--sharing state between contracts may be impossible
> in Nickel's model, but it doesn't convince me that user-defined contracts and
> intersections couldn't be combined using a richer set of primitives than just
> fail or a runtime that performs more complicated bookkeeping. Granted, Section
> 4.2 itself only claims that "it is not obvious" how to do so, but Section 4 as a
> whole refers to "fundamental incompatibilit[ies]".

It is probably a point to clarify. User-defined contracts and
unions/intersections are not fundamentally incompatible, they just appear
non-trivial to combine.

It is already stated somehow in the current form of the paper (in 5.2, we say
K&T's implementation of the co-inductive semantics is a tour de force, but the
semantics is not uniform etc.). I think the problem is the beginning of Section
4 that indeed states: "However appealing union and intersection contracts may
be, they happen to be fundamentally incompatible with the desirable language
features from Section 2", which is indeed false concerning user-defined
contracts, that are introduced in 2.1.

> The comparison to related work in sections 5 and 6 feels underdone, despite
> being a main contribution of the paper. It does do a good job of showing the
> challenges of referential transparency in the existing literature. However, it
> notes without much discussion that Keil and Thiemann's algorithmic system admits
> user-defined contracts, in spite of the fact that they were identified as a
> serious challenge in Section 4--what is the reader to take away from this?

Same point. The answer is Keil and Thiemann's (deterministic) operational
semantics is complex and probably inefficient as defined in exchange of
accomodating for custom contracts, but this is not a very precise statement.

> The discussion of sound monitoring is difficult to follow without referring
> extensively to Williams et al., and doesn't draw as much of a connection with
> Section 4 as I'd hoped--it doesn't illuminate why the tradeoff of excluding
> user-defined contracts was made and what it gains implementors.

Still the same point.

> Finally, I was disappointed to see Castagna et al. relegated to a brief summary, without any
> evaluation--it seems that at least the challenge of referential transparency
> could apply to it, and the article's reference to different goals and
> constraints doesn't make much sense to me.

Busted :) Our hand-wavy conclusion on this was that the actual semantics of
their union and intersection contracts is not obvious at all, so we're not even
sure how to compare. Amusingly, Wadler et al. also said something suspiciously
generic on this paper, which sounds like they couldn't extract enough of it to
make a precise claim either:

"Gradual Typing with Intersection and Union. Castagna and Lanvin [2017] extend the gradually
typed lambda calculus with intersection and union types. Their system uses a set-theoretic inter-
pretation of intersection and union, and employs abstract interpretation in the style of Garcia et al.
[2016] to give a semantics to gradual types. Dynamic checks are added through type-directed cast
insertion, like most sound gradual type systems. They show that clever use of intersection types
that combine the gradual type (?) can be used to reduce the number of type casts a user is required
to write by hand. The calculus does not consider blame (using cast errors instead) and their choice
of operational semantics prevents the statement of a useful blame theorem."

## Correction proposal

- **Custom contracts**: Amend the sentence "[..], they
    [union/intersection contracts] happen to be fundamentally incompatible with
    the desirable language features from Section 2" in Section 4. In section 5,
    hammer down the fact that Keil&Thiemann's system supports custom contracts
    but is really complex and non-uniform.
- **Castagna et al.**: Not sure what we can add. Maybe state more openly that
    we don't really know what semantics they implement, and that it is not clear
    at all?
