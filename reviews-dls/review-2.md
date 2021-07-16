# Overall

- Merit: Accept
- Expertise: Expert

## Paper summary

This paper points out the problems in union and intersection contracts with many
concrete examples. The authors mention the difficulties in implementing union
and intersection contracts and illustrate these situations with many code pieces
and detailed explanations. Issues related to practical implementation, such as
optimization and side effects, are explained as well.

## Comments for author

This paper exactly fits the scope of this symposium, and I think it would be
interesting to our audiences. As a survey paper, it gives a good background and
a clear review of union and intersection contracts. Both issues and trade-offs
are discussed in detail, and the writing is easy to read. However, it would be
even better if the authors can add some future directions.

minor:

- In 1.3, I would suggest explaining the meaning of "exp | C" for audiences unfamiliar with schema check, though they can realize that in later sections.
- L160: I am not quite sure what the sentence means. Why might a value have type Str -> Str? Isn't it a function type?
- L157: ...and they can be "use" to add... -> can be "used" to add?
