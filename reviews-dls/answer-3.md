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

## Minor

> As the paper admits, "the literature on higher order contracts with union and intersection... [is] keenly aware [that they're difficult]." This makes the article's title, while fun, ring a little false: it's not a contribution to show that they're hard, actually, but why and how.

I don't think we'll change the title right? Or we could go with "Union and
intersection contracts are hard, indeed".

> This work discusses two motivations for its work: runtime enforcement of gradual types, and user-defined contracts representing arbitrary computations. The article usually does a good job at contextualizing these different motivations, but is unclear at times; the abstract, for example, implies that this is fundamentally a gradual typing paper.

No opinion.

> Curious in its absence is a discussion of what Nickel currently does for union and intersection contracts--I assume it doesn't support them at all and this paper deals with hypothetical or future expansions to the language, but it wasn't clear.

Yes. But to be fair the paper is not about Nickel, though, but union and
intersection contracts. Is is worth a modification?

> Figure 1 is longer and more complicated than necessary; I spent a while deciphering the behavior of the program before realizing the only point was that contracts with blame improve error messages.

Don't know if that deserves a change? The title of the figure is "Contracts
improve error messages".

> Figure 13's caption is imprecise; the figure doesn't show inlining

True, it's just CSE. Done: I removed the "inlining" part.

> Figure 15's placement in comparison to the text discussing it is challenging, and c is capitalized in the text but lower-case in the figure

Placement: not sure what to do, this is LaTeX, that is not very customizable.
I moved it up a little bit.
Capitalization: fixed.

> L900 "Combining these two context" -> "contexts"

Done.

> L1017-1018: "Basis of the work [14] and [22] that..." is ungrammatical even if we accept using references as nouns, which I find awkward anyways

Done.

> L1018 again: "Explorted"

Done.

> L1022 "Castagna et. al" should be "Castagna et al." -- "et" is a word, "al" is an abbreviation

Done.
