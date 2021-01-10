(\f. const id (f true) )@l*anyU(N -> N) -> (N -> N) id false

((\f. const id (f true))@l*left+*any)@l*right+*(N -> N) -> N -> N id false

(\f. const id (f true))@l*right+*(N -> N) -> N -> N id false

((\f. const id (f true)) id@-l*right-dom0*(N->N))@l*right+*cod0*(N -> N) false

(const id (id@-l*right-dom0*(N->N) true) )@l*right+*cod0*(N -> N) false

(const id ((\x.x) true@+l*right+dom0dom0*N)@-l*right-dom0cod0*N )@l*right+*cod0*(N -> N) false

{+l*right+dom0dom0}

(const id ((\x.x) true)@-l*right-dom0cod0*N )@l*right+*cod0*(N -> N) false

(const id true@-l*right-dom0cod0*N )@l*right+*cod0*(N -> N) false

// Porque hay uno compatible

(const id true)@l*right+*cod0*(N -> N) false

\x.x@l*right+*cod0*(N -> N) false

(\x.x (false)@-l*right-cod0dom0*N )@l*right+*cod0cod0*N

compat(l*right+cod0dom0, l*right+dom0dom0) -- they are

(false)@l*right+*cod0cod0*N

false
