# Answer to reviewer 2

## Answers to Comments for author

> This paper exactly fits the scope of this symposium, and I think it would be
> interesting to our audiences. As a survey paper, it gives a good background and
> a clear review of union and intersection contracts. Both issues and trade-offs
> are discussed in detail, and the writing is easy to read. However, it would be
> even better if the authors can add some future directions.

I'm not sure about "future directions" for such a litterature review. The
section about concrete trade-offs kinda gives alternatives to full-blown unions
and intersections. For Nickel, there is the dependent types angle, but that
doesn't fit in the paper at all.

## Correction proposal

N/A

## Minor

> In 1.3, I would suggest explaining the meaning of "exp | C" for audiences unfamiliar with schema check, though they can realize that in later sections.

Todo.

>  L160: I am not quite sure what the sentence means. Why might a value have type Str -> Str? Isn't it a function type?

Well, functions are values :) should we use "function" instead, for an audience that is less PLT-oriented?

>  L157: ...and they can be "use" to add... -> can be "used" to add?

Done.
