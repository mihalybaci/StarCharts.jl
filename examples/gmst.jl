
# Tests for GMST calculation
# Eventually move this into test.jl
using Dates

include("../src/types.jl")
include("../src/utils.jl")

import Base.+
import Base.-

regulus = Dict("RA" => HMS(10, 08, 43), "DEC" => HMS(11, 58, 02))

ex1 = Dict("lon" => (0, 0, 0),
           "UTC" => (2006, 03, 10, 18, 30, 0),
           "GMST" => (5, 43, 9.747),
           "lst" => (5, 43, 9.747),
           "lha" => (19, 34, 26.747))

ex2 = Dict("lon" => (0, 0, 0),
           "UTC" => (2010, 08, 15, 0, 0, 0),
           "GMST" => (21, 33, 10.54389),
           "lst" => (21, 33, 10.54389),
           "lha" => (11, 24, 27.54))

ex3 = Dict("lon" => (0, 0, 0),
           "UTC" => (2020, 09, 15, 10, 10, 10),
           "GMST" => (9, 49, 30.757),
           "lst" => (9, 49, 30.757),
           "lha" => (23, 40, 47.757))

ex4 = Dict("lon" => (77, 0, 0),
           "UTC" => (2020, 09, 15, 0, 0, 0),
           "GMST" => (23, 37, 40.522),
           "lst" => (04, 45, 40.522),
           "lha" => (18, 36, 57.522))

ex5 = Dict("lon" => (-77, 0, 0),
           "UTC" => (2020, 10, 01, 12, 0, 0),
           "GMST" => (12, 42, 43.68579),
           "lst" => (7, 34, 43.68579),
           "lha" => (21, 26, 0.685798))


examples = [ex1, ex2, ex3, ex4, ex5]

for ex in examples
    UTC = DateTime(ex["UTC"][1], ex["UTC"][2], ex["UTC"][3], ex["UTC"][4], ex["UTC"][5], ex["UTC"][6])
    lon = DecimalDegree(ex["lon"][1]/1.0 + ex["lon"][2]/60 + ex["lon"][3]/3600)
    lst_deg = lst(UTC, lon, localtime=false)
    lst_hms = convert(HMS, lst_deg)
    println("""LST = $(ex["lst"])""")
    println("""LST = $(lst_hms)""")
 
    lha_hms = lha(lst_hms, regulus["RA"])
    println("""LHA = $(ex["lha"])""")
    println("""LHA = $(lha_hms)""")
    println("")
end