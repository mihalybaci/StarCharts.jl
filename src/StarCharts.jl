module StarCharts

using Dates
#using Plots
using TimeZones

import Base.+
import Base.-
import Base.convert


# Exports from chart.jl
export test_stars, make_chart

# Exports from coordinates.jl
export local2utc, gmst, lst, lha

# Exports from coordinates.jl
export equatorial2horizontal, ecliptic2equatorial, convert

# Exports from glossary.jl
export glossary

# Exports coordinates from types.jl
export Coordinate, DecimalDegree, DecimalHour, DMS, HMS, Radian,
       CelestialBody, Galaxy, Nebula, StarCluster, Star, 
       Planet, DwarfPlanet, Comet, Asteroid

# Exports from utils.jl


# Include in this order to ensure everything loads properly
include("types.jl")
include("time.jl")
include("coordinates.jl")
include("utils.jl")
include("chart.jl")
include("glossary.jl")

end # module
