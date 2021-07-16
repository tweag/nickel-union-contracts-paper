# Overall

- Merit: Weak accept
- Expertise: Knowledgeable

## Paper summary

This paper studies the problem of implementing contracts for unions and
intersections. This work is motivated by both the need for runtime type
enforcement of union and intersection types in gradual type systems, and by the
desire for users to be able to write their own arbitrary contracts and compose
them using union and intersections, with the configuration language Nickel used
as demonstration.

A core contribution of the paper is an exploration of some of the fundamental
issues that arise with general intersection and union contacts: checking union
and intersection contracts is side-effectful, which violates referential
transparency and complicates common-subexpression elimination; and combining
user-defined contracts with intersection contracts is challenging.

The paper examines the tradeoffs regarding these properties in approaches to
union and intersection contracts of Keil and Thiemann, Williams et al., and the
implementation in Racket. They find that Keil and Thiemann's coinductive
semantics supports user-defined contracts at the cost of additional runtime
checking, but do not support CSE; that Williams et al. provide a simpler
algorithm at the cost of not supporting user-defined contracts, and Racket
achieves a simple solution by only supporting a simpler model of unions and
intersections.

## Comments for author

This paper does a good job exploring the motivations for union and intersection
contracts and some of the issues that make them interesting and difficult. The
discussion of referential transparency and side effects in checking union
contracts will be useful to language implementers and is something that (to my
knowledge) was left implicit in previous work.

The discussion of intersection contracts and the limitations of user-defined
contracts is a little unclear--sharing state between contracts may be impossible
in Nickel's model, but it doesn't convince me that user-defined contracts and
intersections couldn't be combined using a richer set of primitives than just
fail or a runtime that performs more complicated bookkeeping. Granted, Section
4.2 itself only claims that "it is not obvious" how to do so, but Section 4 as a
whole refers to "fundamental incompatibilit[ies]".

The comparison to related work in sections 5 and 6 feels underdone, despite
being a main contribution of the paper. It does do a good job of showing the
challenges of referential transparency in the existing literature. However, it
notes without much discussion that Keil and Thiemann's algorithmic system admits
user-defined contracts, in spite of the fact that they were identified as a
serious challenge in Section 4--what is the reader to take away from this? The
discussion of sound monitoring is difficult to follow without referring
extensively to Williams et al., and doesn't draw as much of a connection with
Section 4 as I'd hoped--it doesn't illuminate why the tradeoff of excluding
user-defined contracts was made and what it gains implementors. Finally, I was
disappointed to see Castagna et al. relegated to a brief summary, without any
evaluation--it seems that at least the challenge of referential transparency
could apply to it, and the article's reference to different goals and
constraints doesn't make much sense to me.

All that said, I don't see the above problems as being unfixable, and I think
this paper would still serve as a valuable resource for language implementors
and those interested in sound approaches to currently unsound gradual type
systems like Typescript. I recommend accepting this paper, and think it will be
a stronger paper if the above points are clarified.

Minor notes:

- As the paper admits, "the literature on higher order contracts with union and intersection... [is] keenly aware [that they're difficult]." This makes the article's title, while fun, ring a little false: it's not a contribution to show that they're hard, actually, but why and how.

- This work discusses two motivations for its work: runtime enforcement of gradual types, and user-defined contracts representing arbitrary computations. The article usually does a good job at contextualizing these different motivations, but is unclear at times; the abstract, for example, implies that this is fundamentally a gradual typing paper.

- Curious in its absence is a discussion of what Nickel currently does for union and intersection contracts--I assume it doesn't support them at all and this paper deals with hypothetical or future expansions to the language, but it wasn't clear.

- Figure 1 is longer and more complicated than necessary; I spent a while deciphering the behavior of the program before realizing the only point was that contracts with blame improve error messages.

- Figure 13's caption is imprecise; the figure doesn't show inlining

- Figure 15's placement in comparison to the text discussing it is challenging, and c is capitalized in the text but lower-case in the figure

Spelling/grammar:

- L900 "Combining these two context" -> "contexts"

- L1017-1018: "Basis of the work [14] and [22] that..." is ungrammatical even if we accept using references as nouns, which I find awkward anyways

- L1018 again: "Explorted"

- L1022 "Castagna et. al" should be "Castagna et al." -- "et" is a word, "al" is an abbreviation
