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
"""
struct HMS <: Coordinate
    H::Int
    M::Int
    S::Real
end

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
end

"""
DecimalDegree

DecimalDegree specifies decimal degrees coordinates and has one field:

    D::Real
"""
struct DecimalDegree <: Coordinate
    D::Real
end

"""
DecimalHour

DecimalHour specifies decimal hours coordinates and has one field:

    H::Real
"""
struct DecimalHour <: Coordinate
    H::Real
end

"""
Radian

Radian specifies radians coordinates and has one field:

    R::Real
"""
struct Radian <: Coordinate
    R::Real
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
