#=

    This file defines all the types needed for this module.

=#


#=

   Coordinate types

=#

"""
Coordinate

Coordinate is an abstract type used to help dispatch methods on 
typical astronomical coordinate conversions. The following are 
accepted subtypes of Coordinate:

    HMS  -  Hours, minutes, seconds
    DMS  -  Degrees, minutes, seconds
    DecimalDegree  -  Decimal degrees
    DecimalHour  -  Decimal hours
    Radian  -  Radians

See idvidual types for additional information.
"""
abstract type Coordinate end

"""
HMS

HMS specifies hours-minutes-seconds coordinates and has the following fields:

    H::Int - Hours
    M::Int - Minutes
    S::Real - Seconds

Values may be specified with signs (+ or -) or single letter abbreviations
for the direction (N, S, E, W). Examples:

    coord = HMS(h, m, s, k='N')
    a = HMS(1, 1, 1)
    b = HMS(-5, 0, 0.5)
    c = HMS(180, 0, 0, 'W')
"""
struct HMS <: Coordinate
    H::Int
    M::Int
    S::Real
    function HMS(h, m, s, k='N')
        # This way allows for any combination of uppercase, lowercase,
        # character, or string entries
        K = uppercase(string(k)) 
        if K == "N" || K == "E"
            nothing
        elseif K == "S" || K == "W"
            h = -abs(h)  # Just in case this happens -> (-10, 0, 0, 'W')
        else
            @warn "k entry not valid. Choose N, S, E, or W. Defaulting to N/E."
        end
        carry_s = Int(s÷60)
        m += (m ≥ 0) ? carry_s : -carry_s
        carry_m = Int(m÷60)
        h = (h ≥ 0) ? (h + carry_m)%24 : (h - carry_m)%24
        m -= carry_m*60
        s -= carry_s*60
    return new(h, m, s)
    end
end
HMS(hms::Tuple{Int, Int, Real}) = HMS(hms...)
# Accept N, S, E, W keys as well
HMS(hms::Tuple{Int, Int, Real, Union{Char, String}}) =  HMS(hms...)

"""
DMS

DMS specifies degrees-minutes-seconds coordinates and has the following fields:

    H::Int - Hours
    M::Int - Minutes
    S::Real - Seconds 

"""
struct DMS <: Coordinate
    D::Int
    M::Int
    S::Real
    # The following function handles cases where m/s > abs(-60) h>abs(24)
    function DMS(d, m, s, k='E')
        # This way allows for any combination of uppercase, lowercase,
        # character, or string entries
        K = uppercase(string(k)) 
        if K == "N" || K == "E"
            nothing
        elseif K == "S" || K == "W"
            d = -abs(d)  # Just in case this happens -> (-10, 0, 0, 'W')
        else
            @warn "k entry not valid. Choose N, S, E, or W. Defaulting to N/E."
        end
        carry_s = Int(s÷60)
        m += (m ≥ 0) ? carry_s : -carry_s
        carry_m = Int(m÷60)
        d = (d ≥ 0) ? (d + carry_m)%360 : (d - carry_m)%360
        m -= carry_m*60
        s -= carry_s*60
    return new(d, m, s)
    end
end
DMS(dms::Tuple{Int, Int, Real}) = DMS(dms...)
DMS(dms::Tuple{Int, Int, Real, Union{Char, String}}) =  DMS(dms...)

"""
DecimalDegree

DecimalDegree specifies decimal degrees coordinates and has one field:

    D::Real
"""
struct DecimalDegree <: Coordinate
    D::Real
    DecimalDegree(dd) = new(dd%360)
end

"""
DecimalHour

DecimalHour specifies decimal hours coordinates and has one field:

    H::Real
"""
struct DecimalHour <: Coordinate
    H::Real
    DecimalHour(dh) = new(dh%24)
end

"""
Radian

Radian specifies radians coordinates and has one field:

    R::Real
"""
struct Radian <: Coordinate
    R::Real
    Radian(r) = new(r%(2π))
end


#=

    Celestial object types

=#

"""
CelestialBody

CelestialBody is the abstract type for the range of objects allowed to appear
on a StarChart type. Allowed subtypes of CelestialBody are:

    Galaxy
    Nebula

See idvidual subtypes for more information.
"""
abstract type CelestialBody end


#=

Additional fields/information for addition to types
-----------
primary name
other names
RA/DEC
ALT/AZ for a given chart
time of meridian transit
maximum altitude at current location
next period of visibility (object rise to object set)

proper motion/space velocity -> add equations to calculate movement
=#


struct Galaxy <: CelestialBody
    RA::Coordinate
    DEC::Coordinate
end

struct Nebula <: CelestialBody
    RA::Coordinate
    DEC::Coordinate
end

struct StarCluster <: CelestialBody
    RA::Coordinate
    DEC::Coordinate
end

struct Star <: CelestialBody
    RA::Coordinate
    DEC::Coordinate
end

struct Planet <: CelestialBody
    RA::Coordinate
    DEC::Coordinate
end

struct DwarfPlanet <: CelestialBody
    RA::Coordinate
    DEC::Coordinate
end

struct Comet <: CelestialBody
    RA::Coordinate
    DEC::Coordinate
end

struct Asteroid <: CelestialBody
    RA::Coordinate
    DEC::Coordinate
end
