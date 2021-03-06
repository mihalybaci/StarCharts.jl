module StarCharts

#using Plots
using TimeZones

import Base.+
import Base.-
import Base.convert
import Base.get
import Dates: datetime2julian


# Exports from chart.jl
export test_stars, make_chart

# Exports from coordinates.jl
export altitude, azimuth, equatorial2horizontal, ecliptic2equatorial, 
       convert, d2s, s2d, maximum_altitude

# Exports from glossary.jl
export glossary

# Exports from time.jl
export local2utc, gmst_p03, lst, lha

# Exports coordinates from types.jl
export Coordinate, DecimalDegree, DecimalHour, DMS, HMS, Radian,
       CelestialBody, Galaxy, Nebula, StarCluster, Star, 
       Planet, DwarfPlanet, Comet, Asteroid

# Exports from utils.jl
export celestial_equator, ecliptic, get

# Include in this order to ensure everything loads properly
include("types.jl")
include("time.jl")
include("coordinates.jl")
include("utils.jl")
include("chart.jl")
include("glossary.jl")

end # module
