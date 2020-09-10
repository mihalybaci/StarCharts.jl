#=

    This file defines all the types needed for this module.

=#


#=

   Coordinate types

=#

abstract type Coordinate end

"""
Hours, minutes, seconds
"""
struct HMS <: Coordinate
    H::Int
    M::Int
    S::Real
end

"""
Degrees, minutes, seconds
"""
struct DMS <: Coordinate
    D::Int
    M::Int
    S::Real
end

"""
Decimal Degrees
"""
struct DecimalDegree <: Coordinate
    D::Real
end

"""
Decimal Hours
"""
struct DecimalHour <: Coordinate
    H::Real
end


#=

    Celestial object types

=#

abstract type CelestialBody end


#=

Additional fields/information for addition to types
-----------
primary name
other names
time of meridian transit
maximum altitude at current location
next period of visibility

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
