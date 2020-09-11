#=

	This file provides functions for calculations involving
	time systems and conversions.

=#


const DUT1 = -0.2  # seconds, from IERS Bulletin A
const SECONDS_PER_DAY = 86400.0  # seconds per day
const J2000 = 2451545.0  # Start of the J2000 Epoch in Julian days
const JCEN = 36525.0  # One Julian century

"""
zoned2julian(zdt::ZonedDateTime) -> Float

Take the given `ZonedDateTime` and return the number of Julian calendar days
since the Julian epoch `-4713-11-24T12:00:00` as a Float. This function 
bootstraps off `Dates.datetime2julian`.
"""
zoned2julian(zdt::ZonedDateTime) = datetime2julian(DateTime(year(zdt), month(zdt), day(zdt),
                                                   hour(zdt), minute(zdt), second(zdt), millisecond(zdt)))

"""
julian2zoned(jd::Real) -> ZonedDateTime

Take the given `ZonedDateTime` and return the number of Julian calendar days
since the Julian epoch `-4713-11-24T12:00:00` as a Float. This function 
bootstraps off `Dates.datetime2julian`.
"""
julian2zoned(jd::Real, tz::TimeZone) = ZonedDateTime(julian2datetime(jd), tz)

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

    datetime::ZonedateTime - the datetime given as a ZonedDateTime type

Output:

    lst::DecimalHour - the Local Sidereal Time in units of decimal hours
"""
function lst(datetime::ZonedDateTime, λ::Coordinate)
    utc = astimezone(datetime, TimeZone("UTC")) 
    ut1 = UT1(hour(utc)*3600 + minute(utc)*60 + second(utc), DUT1)  # Convert to seconds
    utc_jd = zoned2julian(utc)
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
