#=

    This file provides utilities needed that do not fit neatly
    into other files.

=#



"""
celestial_equator()

A function that produces a plot-ready celestial equator (all RA, dec=0)
"""
celestial_equator() = collect(0:1:360), zeros(361)

"""
ecliptic()

A fucntion that produces a plot-ready ecliptic
"""
ecliptic() = nothing

"""
get(x::T) where {T <: Coorindate}

Convenience function that returns the value(s) of a Coorindate type as a 
float (DecimalDegrees, DecimalHours, Radian) or as a tuple (DMS, HMS).

This is really only more convenient for DMS/HMS as coord.D, coord.H, and
coord.R are probably simpler for the other Coordinate types.
"""
get(x::DecimalDegree) = x.D
get(x::DecimalHour) = x.H
get(x::Radian) = x.R
get(x::DMS) = (x.D, x.M, x.S)
get(x::HMS) = (x.H, x.M, x.S)


# Define the addition of numbers to coordinates and of the same type
# It may be faster to avoid the exra conversions, but this way is simpler to implement.
+(a::DecimalDegree, b::DecimalDegree) = DecimalDegree(a.D + b.D)
+(a::DecimalHour, b::DecimalHour) = DecimalHour(a.H + b.H)
+(a::Radian, b::Radian) = Radian(a.R + b.R)
+(a::DMS, b::DMS) = convert(DMS, convert(DecimalDegree, a) + convert(DecimalDegree, b))
+(a::HMS, b::HMS) = convert(HMS, convert(DecimalHour, a) + convert(DecimalHour, b))

+(a::DecimalDegree, b::Real) = DecimalDegree(a.D + b)
+(a::Real, b::DecimalDegree) = DecimalDegree(a + b.D)
+(a::DecimalHour, b::Real) = DecimalHour(a.H + b)
+(a::Real, b::DecimalHour) = DecimalHour(a + b.H)
+(a::Radian, b::Real) = Radian(a.R + b)
+(a::Real, b::Radian) = Radian(a + b.R)
+(a::DMS, b::Real) = convert(DMS, DecimalDegree(convert(DecimalDegree, a).D + b))
+(a::Real, b::DMS) = convert(DMS, DecimalDegree(a + convert(DecimalDegree, b).D))
+(a::HMS, b::Real) = convert(HMS, DecimalHour(convert(DecimalHour, a).H + b))
+(a::Real, b::HMS) = convert(HMS, DecimalHour(a + convert(DecimalHour, b).H))



# Define the subtraction of numbers to coordinates and of the same type
-(a::DecimalDegree, b::DecimalDegree) = DecimalDegree(a.D - b.D)
-(a::DecimalHour, b::DecimalHour) = DecimalHour(a.H - b.H)
-(a::Radian, b::Radian) = Radian(a.R - b.R)
-(a::DMS, b::DMS) = convert(DMS, convert(DecimalDegree, a) - convert(DecimalDegree, b))
-(a::HMS, b::HMS) = convert(HMS, convert(DecimalHour, a) - convert(DecimalHour, b))
-(a::DecimalDegree, b::Real) = DecimalDegree(a.D - b)
-(a::Real, b::DecimalDegree) = DecimalDegree(a - b.D)
-(a::DecimalHour, b::Real) = DecimalHour(a.H - b)
-(a::Real, b::DecimalHour) = DecimalHour(a - b.H)
-(a::Radian, b::Real) = Radian(a.R - b)
-(a::Real, b::Radian) = Radian(a - b.R)
-(a::DMS, b::Real) = convert(DMS, DecimalDegree(convert(DecimalDegree, a).D - b))
-(a::Real, b::DMS) = convert(DMS, DecimalDegree(a - convert(DecimalDegree, b).D))
-(a::HMS, b::Real) = convert(HMS, DecimalHour(convert(DecimalHour, a).H - b))
-(a::Real, b::HMS) = convert(HMS, DecimalHour(a - convert(DecimalHour, b).H))

