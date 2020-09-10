#=

    This file provides utilities needed to create star charts
    such as date and time conversions, coordinate conversions, etc.

=#

const DUT1 = -0.2  # seconds, from IERS Bulletin A
const SECONDS_PER_DAY = 86400.0  # seconds per day
const J2000 = 2451545.0  # Start of the J2000 Epoch in Julian days
const JCEN = 36525.0  # One Julian century

#=

    Time system conversions

=#

"""
local2utc(date::DateTime)

Convert local date-time to UTC. 
"""
function local2utc(date::DateTime)
	zoned = ZonedDateTime(date, localzone())  # Zoned local time
	utz = astimezone(zoned, TimeZone("UTC"))  # Zoned UTC time
	# Convert to unzoned, "regular" datetime for Dates compatibility
	utc = DateTime(year(utz), month(utz), day(utz),
				   hour(utz), minute(utz), second(utz), millisecond(utz))
	return utc
end


"""
TAI(UTC) 

Convert UTC to TAI, where TAI = UTC + 37 seconds, from IERS Bulletin A
"""
TAI(UTC) = UTC + 37.0/SECONDS_PER_DAY


"""
TT(TAI)

Convert TAI to TT, where TT = TAI + 32.184, from IERS Bulletin A
"""
TT(TAI) = TAI + 32.184/SECONDS_PER_DAY


"""
UT1(UTC, DUT1)

Calculate the UT1 time, where UT1 = UTC + DUT1 (from IERS Bulletin A)
"""
UT1(UTC, DUT1) = UTC + DUT1  


"""
gmst_p03(UT1, tᵤ, t)

Calculate the Greenwhich Mean Sidereal Time. This function uses equation 43 from 
Capitaine, Wallace, & Chapront, 2003, A&A, 412, 567-586. The paper is included here
as ../bib/Capitaine2003c.pdf

Inputs:

    UT1 - the UT1 time given in units of decimal hours.
    tᵤ  - the UT1 time given in units of Julian centuries after J2000
    t   - the terrestrial time (TT) given in units of Julian centuries after J2000

Output:

    gmst - the Greenwhich Mean Sidereal Time in units of seconds.
"""
gmst_p03(UT1, tᵤ, t) = UT1 + 24110.5493771 + 8640184.79447825*tᵤ + 307.4771013*(t-tᵤ) + 
                       0.092772110*t^2 - 0.0000002926*t^3 - 0.00000199708*t^4 - 0.000000002454*t^5


"""
lst(datetime, λ; localtime=true)::DecimalHour

Calculate the local sidereal time for a given date and time.

Inputs:

    datetime::DateTime - the datetime given as a DateTime type

Optional:

    localtime::Bool  - set to false to use UTC datetime

Output:

    lst::DecimalHour - the Local Sidereal Time in units of decimal hours
"""
function lst(datetime::DateTime, λ::Coordinate; localtime::Bool=true)
    utc = localtime ? local2utc(datetime) : datetime
    ut1 = UT1(hour(utc)*3600 + minute(utc)*60 + second(utc), DUT1)  # Convert to seconds
    utc_jd = datetime2julian(utc)
    ut1_jd = UT1(utc_jd, DUT1/SECONDS_PER_DAY)
    tᵤ = (ut1_jd - J2000)/JCEN
    t = (TT(TAI(utc_jd)) - TT(TAI(J2000)))/JCEN
    gmst = gmst_p03(ut1, tᵤ, t)
    
    #=
    The GMST is returned as the total number of seconds since J2000, so additional conversions 
    are needed to return the LST. 
      1. Convert the GMST from seconds to hours
      2. Take the modulus to remove the number of whole days since J2000
      3. Add the longitude in decimal hours by converting the type
      4. Keep the value 0 < LST < 24,
    to be converted to hours, then have the modulus returned remove values of whole days.    
    =#
    lst_i = (gmst/3600)%24 + convert(DecimalHour, λ).H
    if lst_i < 0
        lst_f = lst_i + 24.0
    elseif lst_i ≥ 24
        lst_f = lst_i - 24.0
    else
        lst_f = lst_i
    end

    return DecimalHour(lst_f)
end

"""
lha(LST, α)

Calculate the hour angle for RA at the LST.

Inputs:

    lst::T - Local sidereal time where {T <: Coordinate}
    α::Coordinate   - Right ascension

Output:

    lha::T - the local hour angle, output is type T of lst input
"""
lha(LST::Coordinate, α::Coordinate) = LST - convert(typeof(LST), α)

#=

    Coordinate system transformations

=#


"""
equatorial2horizontal(ra, dec)

Convert equatorial coordinates (RA, DEC) to horizontal coordinates (alt, az)
"""
function equatorial2horizontal(ra, dec)

    alt, az = ra, dec
    return alt, az
end


"""
ecliptic2equatorial(λ, β)

Convert ecliptic coordinates to equatorial coordinates
"""
function ecliptic2equatorial(λ, β)
    pass
end

#=

    Coordinate type conversions

=#

"""
s2d(d, m, s)

Helper function. Converts a sexigessimal coordinate to decimal degrees
"""
s2d(d, m, s) = (0 ≤ d) ? d + m/60 + s/3600 : d - m/60 - s/3600

"""
d2s(d)

Helper function. Converts a decimal degree coordinate to sexigessimal
"""
function d2s(dd)
    d = (0 ≤ dd) ? floor(Int, dd) : ceil(Int, dd)
    m = floor(Int, 60*(abs(dd)%1))
    s = round(3600*(abs(dd) - abs(d) - m/60), digits=6)
    return d, m, s
end

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

convert(::Type{HMS}, coord::DecimalHour) = HMS(d2s(coord.H)...)
convert(::Type{HMS}, coord::DecimalDegree) = HMS(d2s(coord.D/15)...)
convert(::Type{HMS}, coord::DMS) = HMS(d2s(s2d(coord.D, coord.M, coord.S)/15))

convert(::Type{DecimalDegree}, coord::DecimalHour) = DecimalDegree(coord.H*15)
convert(::Type{DecimalDegree}, coord::DMS) = DecimalDegree(s2d(coord.D, coord.M, coord.S))
convert(::Type{DecimalDegree}, coord::HMS) = DecimalDegree(s2d(coord.H, coord.M, coord.S)*15)


convert(::Type{DecimalHour}, coord::DecimalDegree) = DecimalHour(coord.D/15)
convert(::Type{DecimalHour}, coord::HMS) = DecimalHour(s2d(coord.H, coord.M, coord.S))
convert(::Type{DecimalHour}, coord::DMS) = DecimalHour(s2d(coord.D, coord.M, coord.S)/15)


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

#=

    Miscellaneous

=#

"""
celestial_equator()

A function that just returns coordinates 
for the celestial equator (all RA, dec=0)
"""
celestial_equator() = collect(0:1:360), zeros(361)