
## Empty interval:

@doc doc"""Empty intervals are represented as intervals of `NaN`s.
The automatic propagation of `NaN`s means that any operation with an empty interval gives back
an empty interval.""" ->

emptyinterval(T::Type) = Interval(convert(T, NaN))
emptyinterval(x::Interval) = Interval(convert(eltype(x), NaN))

∅ = emptyinterval(Float64)
emptyinterval() = ∅

isempty(x::Interval) = isnan(x.lo) || isnan(x.hi)

eps(x::Interval) = max(eps(x.lo), eps(x.hi))

## "Thin" interval (one for which there is "no more precision")
# Note that this is not the standard usage of "thin interval", which is one for
# which the two endpoints are *strictly* equal

isthin(x::Interval) = (m = mid(x); m == x.lo || m == x.hi)

## Widen:
widen{T<:FloatingPoint}(x::Interval{T}) = Interval(prevfloat(x.lo), nextfloat(x.hi))


## Equalities and neg-equalities

==(a::Interval, b::Interval) =
    (isempty(a) || isempty(b)) ? (isempty(a) && isempty(b)) : a.lo == b.lo && a.hi == b.hi
!=(a::Interval, b::Interval) = !(a==b)


## Inclusion/containment functions

in(x::Real, a::Interval) = a.lo <= x <= a.hi

⊊(a::Interval, b::Interval) = b.lo < a.lo && a.hi < b.hi
⊆(a::Interval, b::Interval) = b.lo ≤ a.lo && a.hi ≤ b.hi
⊂ = ⊊  # do we really want this?


## zero and one functions

zero{T}(a::Interval{T}) = Interval(zero(T))
one{T}(a::Interval{T}) = Interval(one(T))


## Addition and subtraction

+{T}(a::Interval{T}, b::Interval{T}) = @round(T, a.lo + b.lo, a.hi + b.hi)
+(a::Interval) = a

-{T}(a::Interval{T}) = @round(T, -a.hi, -a.lo)
-(a::Interval, b::Interval) = a + (-b)  # @round(a.lo - b.hi, a.hi - b.lo)
(((())))

## Multiplication

*{T}(a::Interval{T}, b::Interval{T}) = @round(T,
                                     min( a.lo*b.lo, a.lo*b.hi, a.hi*b.lo, a.hi*b.hi ),
                                     max( a.lo*b.lo, a.lo*b.hi, a.hi*b.lo, a.hi*b.hi )
                                     )

## Division

function inv{T}(a::Interval{T})
    if a.lo < zero(T) < a.hi  # strict inclusion
        return Interval(-convert(T, Inf), convert(T, Inf))  # inf(z) returns inf of type of z
    end

    @round(T, inv(a.hi), inv(a.lo))
end

/(a::Interval, b::Interval) = a * inv(b)
//(a::Interval, b::Interval) = a / b    # to deal with rationals


## Scalar functions on intervals (no directed rounding used)

mid(a::Interval) = (a.lo + a.hi) / 2

diam(a::Interval) = a.hi - a.lo
mag(a::Interval) = max( abs(a.lo), abs(a.hi) )
mig(a::Interval) = ( zero(a.lo) ∈ a ) ? zero(a.lo) : min( abs(a.lo), abs(a.hi) )


## Functions needed for generic linear algebra routines to work

<(a::Interval, b::Interval) = a.hi < b.lo
real(a::Interval) = a
abs(a::Interval) = Interval(mig(a), mag(a))


## Set operations

function intersect{T}(a::Interval{T}, b::Interval{T})

    if isempty(a) || isempty(b)
        return emptyinterval(T)
    end

    if a.hi < b.lo || b.hi < a.lo
        # warn("Intersection is empty")
        return emptyinterval(T)
    end

    #@round(T, max(a.lo, b.lo), min(a.hi, b.hi))
    Interval(max(a.lo, b.lo), min(a.hi, b.hi))

end

# Specific promotion rule for intersect:
intersect{T,S}(a::Interval{T}, b::Interval{S}) = intersect(promote(a,b)...)

hull{T}(a::Interval{T}, b::Interval{T}) = Interval(min(a.lo, b.lo), max(a.hi, b.hi))
union(a::Interval, b::Interval) = hull(a, b)


dist(a::Interval, b::Interval) = max(abs(a.lo-b.lo), abs(a.hi-b.hi))
eps(a::Interval) = max(eps(a.lo), eps(a.hi))
