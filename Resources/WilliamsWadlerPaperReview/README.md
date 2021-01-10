## Known problems in the Wadler paper

Together with these notes, the file `intersection.spec.ts` is a modified version of the file
with the same name on https://github.com/jack-williams/contracts-ts/.

It has tests exemplifying the second and third problems described in this document. In order to
run it, clone the original repository, replace that file and run the tests
(`npm run build && npm run tests`).

### A continuation of an intersection is not the union of the continuations

According to the sound monitoring properties, a continuation negatively validates an intersection, if it validates any of them.

```
K \in [A /\ B]- if K \in [A]- or K \in [B]-
```

However, I think this goes against the desired behaviour, in particular, in section 2.3 the following example is provided as a difficult example of intersection:

```
let f = [] in f 1; f true
# Or the lambda calculus version
(\f. (\xy. y) (f 1) (f true)) []
```

(\x.x)@(N -> N) /\ (B -> B)

Which doesn't comply with the rule given above (notice, however, that the lambda calculus developed in the paper does solve this).

#### Possible solve

I'm not fully aware of something that could solve this, but Keil and Thiemann noticed the same issue.

A first idea would be the following, but I'm pretty sure this doesn't work in the general case (check the next section)

```
We assume a new kind of (elimination-)context (not sure whether the contract application should go here)
EK := Id | EK * []N | EK * []@A

K \in [A /\ B]- if forall EK. K ->* EK implies EK \in [A]- or EK \in [B]-
```

But again, pretty sure it doesn't work.

### Second level negative blame

let f = (\x.x)@(N -> N) /\ (B -> B) in f True

The idea is to have `(\xy.x)@(N -> N -> N) /\ (N -> B -> N)`, both our intuition and the sound monitoring properties tells us this should hold, however let's try it under the following context `(\f.(\xy.x) (f 1) (f true))([] 1)` (notice that this is not a valid continuation according to the sound monitoring properties, but it is according to the intuition and the expected behaviour of the intersection, see the note above). Let's compute it using the label `l`, we omit the subscript under `right/left` since there are no unions:

```
(\f.(\xy.x) (f 1) (f true))((\xy.x)@l*(N -> N -> N) /\ (N -> B -> N) 1)
                            -------^--------------------------------
            
(\f.(\xy.x) (f 1) (f true)) (((\xy.x)@l*left+(N -> N -> N))@l*right+(N -> B -> N) 1)
                            -------------------------------^------------------------

(\f.(\xy.x) (f 1) (f true))   ((\xy.x)@l*left+(N -> N -> N)  1@-l*right-dom0 N )@l*right+cod0 (B -> N)
                                                             -^--------------

(\f.(\xy.x) (f 1) (f true))   ((\xy.x)@l*left+(N -> N -> N) 1)@l*right+cod0(B -> N)
                               -------^-----------------------


(\f.(\xy.x) (f 1) (f true))   (((\xy.x)  1@-l*left-dom0N)@l*left+cod0(N -> N))@l*right+cod0(B -> N)
                                         -^------------

(\f.(\xy.x) (f 1) (f true))   (((\xy.x)  1)@l*left+cod0(N -> N))@l*right+cod0(B -> N)
                                -^--------

(\f.((\xy.x) (f 1)) (f true))   ((\y.1)@l*left+cod0(N -> N))@l*right+cod0(B -> N)
-^-----------------------------------------------------------------------------

# Let's call g = ((\y.1)@l*left+cod0(N -> N))@l*right+cod0(B -> N)

(\xy.x) (((\y.1)@l*left+cod0(N -> N))@l*right+cod0(B -> N) 1) (g true)
        -----------------------------^-----------------------


(\xy.x) (((\y.1)@l*left+cod0(N -> N) 1@-l*right-cod0dom0 B )@l*right+cod0cod0 N) (g true)
                                     -^------------------

TODO go through the algorithm

This raises blame since 1 is not a Bool, following the blame resolution algorithm, we end up with a state where that label got blamed by itself, but it's not further raised, since it's a negative raise on an intersection.

# State: {-l*right-cod0dom0}

(\xy.x) (((\y.1)@l*left+cod0(N -> N) 1)@l*right+cod0cod0N) (g true)
          ------^----------------------

(\xy.x) ((((\y.1) 1@-l*left-cod0dom0N) @l*left+cod0cod0N)@l*right+cod0cod0N) (g true)
                  -^-----------------

(\xy.x) ((((\y.1) 1) @l*left+cod0cod0N)@l*right+cod0cod0N) (g true)
           -^------

(\xy.x) ((1@l*left+cod0cod0N)@l*right+cod0cod0N) (g true)
          -^----------------

(\xy.x) (1@l*right+cod0cod0N) (g true)
        --^------------------

(\xy.x) 1 (g true)
-^-------

(\y.1) (((\y.1)@l*left+cod0(N -> N))@l*right+cod0(B -> N) true)
        ----------------------------^--------------------------

(\y.1) (((\y.1)@l*left+cod0(N -> N) true@-l*right-cod0dom1B )@l*right+cod0cod1N)
                                    ----^------------------

(\y.1) (((\y.1)@l*left+cod0(N -> N) true)@l*right+cod0cod1N)
        -------^------------------------

(\y.1) (((\y.1) true@-l*left-cod0dom1N)@l*left+cod0cod1N)@l*right+cod0cod1N)
                ----^-----------------


Curr state = {-l*right-cod0dom0}

Since true is not N, we call the blame procedure with the label -l*left-cod0dom1, we call assign and we call resolve, since there is not a compatible negative label on the state.

So, we're on

resolve(-l*left-cod0dom1, {-l*right-cod0dom0, -l*left-cod0dom1})

                cod0/dom1/nil     cod0/dom0/nil



We want to check if exists a path P', such that elim(P', cod0>>dom1>>nil), and -l*right-P' is on the state, we notice that the path cod0>>dom0>>nil works, since they start under the same elimination context.

Therefore, we call assign(-l, {-l*right-cod0dom0, -l*left-cod0dom1}), which will blame

```


#### Possible solve

I think there is a problem on the `elim` relation, perhaps it should go as deep as possible on the path. I'm not sure what problems this could raise in the rest of the paper to be honest, but I think it would solve this particular issue.


### First positive and then negative doesnt raise

The idea is to check what happens when a function first gets blamed positively (but it's under an union, so it doesnt raise) but is then raised negatively (which, according to our intuition, should blame), let's look at `(\f. const id (f true) )@l*anyU(N -> N) -> (N -> N) id false`:


```
(\f. const id (f true) )@l*anyU(N -> N) -> (N -> N) id false
------------------------------^--------------------

((\f. const id (f true))@l*left+*any)@l*right+*(N -> N) -> N -> N id false
------------------------^-----------

(\f. const id (f true))@l*right+*(N -> N) -> N -> N id false
-----------------------^------------------------------

((\f. const id (f true)) id@-l*right-dom0*(N->N))@l*right+*cod0*(N -> N) false
 -^---------------------------------------------

(const id (id@-l*right-dom0*(N->N) true) )@l*right+*cod0*(N -> N) false
           --^-------------------------

(const id ((\x.x) true@+l*right+dom0dom0*N)@-l*right-dom0cod0*N )@l*right+*cod0*(N -> N) false
                  ----^-------------------

Since true is not a N, we raise blame, we don't resolve blame because it's a positive blame under an union, and the state end up like this:

{+l*right+dom0dom0}

(const id ((\x.x) true)@-l*right-dom0cod0*N )@l*right+*cod0*(N -> N) false
            ^---------

(const id true@-l*right-dom0cod0*N )@l*right+*cod0*(N -> N) false
          ----^-------------------

Since there is in the state a compatible node to l*right+dom0cod0 (l*right+dom0dom0) we don't even assign blame, and the state remains the same

(const id true)@l*right+*cod0*(N -> N) false
--^-----------

\x.x@l*right+*cod0*(N -> N) false
----^----------------------------

(\x.x (false)@-l*right-cod0dom0*N )@l*right+*cod0cod0*N
      -------^-------------------

Again, we have a node on the state compatible to l*right+cod0dom0 (l*right+dom0dom0), so the blame node is not even saved on the state.


(false)@l*right+*cod0cod0*N
-------^-------------------

Again, positive blame under an union where the left branch wasn't blamed

false
```

#### Possible solve

The obvious solve to this would be to make the check of whether two blame nodes are compatible only on one side (that is, if we're blaming positevily, we check that it wasn't blamed negatively, but not the other way). I'm not sure how easy this would be, and there's probably an example that breaks this as well.