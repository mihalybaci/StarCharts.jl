module StarCharts

using Dates
using Plots
using TimeZones

import Base.+
import Base.-
import Base.convert


# Exports from chart.jl
export test_stars, make_chart

# Exports from glossary.jl
export glossary

# Exports coordinates from types.jl
export Coordinate, DecimalDegree, DecimalHour, DMS, HMS,
       CelestialBody, Galaxy, Nebula, StarCluster, Star, 
       Planet, DwarfPlanet, Comet, Asteroid

# Exports from utils.jl
export local2utc, lst, lha, equatorial2horizontal, ecliptic2equatorial, convert


include("chart.jl")
include("glossary.jl")
include("types.jl")
include("utils.jl")

end # module
