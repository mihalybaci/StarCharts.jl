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