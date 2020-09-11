#=

	This file provides functions for calculations involving
	coordinate systems and conversions.

=#


#=

    Coordinate system transformations

=#


"""
altitude(lat, dec, lha)

Calculate the altitude of a given position in the sky.

Input:

        lat::Coordinate - Latitude of observer
        dec::Coordinate - Declination of object
        lha::Coordinate - Local hour angle of observer+star

Output:

        altitude::DecimalDegree - Altitude of object in decimal degrees
"""
function altitude(lat::Coordinate, dec::Coordinate, lha::Coordinate)
	ϕ = convert(Radian, lat).R
	δ = convert(Radian, dec).R
	ha = convert(Radian, lha).R
	return DecimalDegree(rad2deg(asin(sin(ϕ)*sin(δ) + cos(ϕ)*cos(δ)*cos(ha))))
end


"""
azimuth(alt, dec, lha)

Calculate the azimuth of a given position in the sky.

Input:

        alt::Coordinate - Altitude of object
        dec::Coordinate - Declination of object
        lha::Coordinate - Local hour angle of observer+star

Output:

        altitude::DecimalDegree - Azimuth of object in decimal degrees
"""
function azimuth(altitude::Coordinate, dec::Coordinate, lha::Coordinate)
	alt = convert(Radian, altitude).R
	δ = convert(Radian, dec).R
	ha = convert(Radian, lha).R
	
	return DecimalDegree(rad2deg(asin(sin(ha)*cos(δ)/cos(alt))))
end


"""
maximum_altitude(lat::Coordinate, dec::Coordinate)

Calculate the maximum altitude an object for an observer. 

Input:

    lat::Coordinate - Latitude of observer
    dec::Coordinate - Declination of object

Output:

    altitude::DecimalDegree - maximum altitude reached
"""
function maximum_altitude(lat::Coordinate, dec::Coordinate)
	ϕ = convert(DecimalDegree, lat).D
	δ = convert(DecimalDegree, dec).D
	return DecimalDegree(90 - δ + ϕ )
end


"""
equatorial2horizontal(ra, dec)

Convert equatorial coordinates (RA, DEC) to horizontal coordinates (alt, az)

Input:

    ra::Coordinate - object right ascenion
    dec::Coordinate - object declination
    lat::Coordinate - observer latitude
    lon::Coordinate - observer longitude 
    datetime::DateTime - observer date and time 

Optional:

    localtime::Bool - Specifies if datetime is local, else assumes UTC (default is true)

Output:

    alt::DecimalDegree - object altitude
    az::DecimalDegree - object azimuth
"""
function equatorial2horizontal(α::Coordinate,  δ::Coordinate, ϕ::Coordinate, λ::Coordinate, datetime::DateTime; localtime=true)

    LST = lst(datetime, λ)
    LHA = lha(LST, α)

    alt = altitude(ϕ, δ, LHA)
    az = azimuth(alt, δ, LHA)
    
    return alt, az
end


"""
ecliptic2equatorial(λ, β)

Convert ecliptic coordinates to equatorial coordinates
"""
function ecliptic2equatorial(λ, β)
    return nothing
end


#=

    Coordinate type conversions

=#

# s2d, d2s, s2r, and r2s are helper functions
# to simplify the convert() methods and avoid repetition.
# now and in later functions.


"""
s2d(d, m, s)

Converts a sexigessimal coordinate to decimal degrees
"""
s2d(d, m, s) = (0 ≤ d) ? d + m/60 + s/3600 : d - m/60 - s/3600


"""
d2s(d)

Converts a decimal degree coordinate to sexigessimal
"""
function d2s(dd)
    d = (0 ≤ dd) ? floor(Int, dd) : ceil(Int, dd)
    m = floor(Int, 60*(abs(dd)%1))
    s = round(3600*(abs(dd) - abs(d) - m/60), digits=6)
    return d, m, s
end


"""
sr2(d, m, s)

Converts a sexigessimal coordinate to radians.
"""
s2r(d, m, s) = deg2rad(s2d(d, m, s))


"""
r2s(rad)

Converts a radian coordinate to sexigessimal
"""
r2s(rad) = d2s(rad2deg(rad))


"""
convert(T, coordinate)

Converts coordinates useful for astronomical purposes, where the input coordinate
and output type T can be any of the following:

    DecimalDegree - decimal degrees (0 to 360)
    DecimalHour - decimal hours (0 to 24)
    DMS  - degrees, minutes, seconds (sexigessimal, base 60)
    HMS  - hours,   minutes, seconds
"""
convert(::Type{T}, coord::T) where {T<: Coordinate} = coord
# ^^^ If the input type and converted type are the same, then do nothing


convert(::Type{DMS}, coord::DecimalDegree) = DMS(d2s(coord.D)...)
convert(::Type{DMS}, coord::DecimalHour) = DMS(d2s(coord.H*15)...)
convert(::Type{DMS}, coord::HMS) = DMS(d2s(s2d(coord.H, coord.M, coord.S)*15))
convert(::Type{DMS}, coord::Radian) = DMS(rad2deg(coord.R)...)

convert(::Type{HMS}, coord::DecimalHour) = HMS(d2s(coord.H)...)
convert(::Type{HMS}, coord::DecimalDegree) = HMS(d2s(coord.D/15)...)
convert(::Type{HMS}, coord::DMS) = HMS(d2s(s2d(coord.D, coord.M, coord.S)/15))
convert(::Type{HMS}, coord::Radian) = HMS(r2s(coord.R/15)...)

convert(::Type{DecimalDegree}, coord::DecimalHour) = DecimalDegree(coord.H*15)
convert(::Type{DecimalDegree}, coord::DMS) = DecimalDegree(s2d(coord.D, coord.M, coord.S))
convert(::Type{DecimalDegree}, coord::HMS) = DecimalDegree(s2d(coord.H, coord.M, coord.S)*15)
convert(::Type{DecimalDegree}, coord::Radian) = DecimalDegree(rad2deg(coord.R))

convert(::Type{DecimalHour}, coord::DecimalDegree) = DecimalHour(coord.D/15)
convert(::Type{DecimalHour}, coord::HMS) = DecimalHour(s2d(coord.H, coord.M, coord.S))
convert(::Type{DecimalHour}, coord::DMS) = DecimalHour(s2d(coord.D, coord.M, coord.S)/15)
convert(::Type{DecimalHour}, coord::Radian) = DecimalHour(rad2deg(coord.R)/15)

convert(::Type{Radian}, coord::DecimalDegree) = Radian(deg2rad(coord.D))
convert(::Type{Radian}, coord::DecimalHour) = Radian(deg2rad(coord.H*15))
convert(::Type{Radian}, coord::DMS) = Radian(s2r(coord.D, coord.M, coord.S))
convert(::Type{Radian}, coord::HMS) = Radian(s2r(coord.H, coord.M, coord.S)*15)

# Define the addition/subtraction of coordinates of the same type
function +(a::DecimalDegree, b::DecimalDegree)
    c = (a.D + b.D)%360  # -360 < c < 360
    c = (c < 0) ? c + 360 : c  # 0 <= c <360
    return DecimalDegree(c)
end

function +(a::DecimalHour, b::DecimalHour)
    c = (a.H + b.H)%24  # -24 < c < 24
    c = (c < 0) ? c + 24 : c  # 0 <= c <24
    return DecimalHour(c)
end

# It may be faster to avoid the conversions, but this way is simpler to implement.
+(a::DMS, b::DMS) = convert(DMS, convert(DecimalDegree, a) + convert(DecimalDegree, b))
+(a::HMS, b::HMS) = convert(HMS, convert(DecimalHour, a) + convert(DecimalHour, b))

function -(a::DecimalDegree, b::DecimalDegree)
    c = (a.D - b.D)%360  # -360 < c < 360
    c = (c < 0) ? c + 360 : c  # 0 <= c <360
    return DecimalDegree(c)
end

function -(a::DecimalHour, b::DecimalHour)
    c = (a.H - b.H)%24  # -24 < c < 24
    c = (c < 0) ? c + 24 : c  # 0 <= c <24
    return DecimalHour(c)
end

-(a::DMS, b::DMS) = convert(DMS, convert(DecimalDegree, a) - convert(DecimalDegree, b))
-(a::HMS, b::HMS) = convert(HMS, convert(DecimalHour, a) - convert(DecimalHour, b))
