#=

    This file defines the functions needed to make the actual star charts

=#
using CSV
using DataFrames
using Plots
using StarCharts
using TimeZones
import Dates: now

simbad_header = ["#", "Identifier", "Type", "CoordString", "U", "B", "V", "R", "I", "SpType", "Bib", "Note"]
data = DataFrame(CSV.read("data/objects_vmag6.txt", delim="|", skipto=10, header=simbad_header, footerskip=2))


#=

    DATA CLEANUP

=#

# If a direct http connection is made to Simbad, these steps can be programmed into the 
# data downloading steps, so that only clean data is imported to StarCharts.\

# Keep track of data being tossed! This might help spot problems with the code?

# Remove any rows that have missing values
raw_rows = size(data)[1]
dropmissing!(data, :CoordString)
current_rows = size(data)[1]
if current_rows != raw_rows
    @info "dropmissing! removed $(raw_rows - current_rows) rows of data"
end

# Remove objects with no coordinates since they cannot be plotted
filter!(row -> strip(row.CoordString) != "No Coord.", data)

# Replace missing magnitudes with standard value of 99.999
replace!(data.U, "     ~" => "99.999")
replace!(data.B, "     ~" => "99.999")
replace!(data.V, "     ~" => "99.999")
replace!(data.R, "     ~" => "99.999")
replace!(data.I, "     ~" => "99.999")

# With bad data replaced, convert magnitude column type to Float
data.U = (typeof(data.U[1]) == String) ? parse.(Float64, data.U) : data.U
data.B = (typeof(data.B[1]) == String) ? parse.(Float64, data.B) : data.B
data.V = (typeof(data.V[1]) == String) ? parse.(Float64, data.V) : data.V
data.R = (typeof(data.R[1]) == String) ? parse.(Float64, data.R) : data.R
data.I = (typeof(data.I[1]) == String) ? parse.(Float64, data.I) : data.I


#=

    MAKE A CHART 

=#

# Test for Brisbane, Australia at time Dates.now() 

# Make a test plot from Brisbane, AUS 
tz_time = ZonedDateTime(now(), TimeZone("Australia/Brisbane"))

lat, lon = DMS(-27, 28, 04), DMS(153, 01, 41)

# Create columns for position data in number format
# Do not save as Coordinate types to allow for more complex
# dataframe filtering 
data.RA = [(0, 0, 0.0) for i = 1:size(data)[1]]
data.DEC = [(0, 0, 0.0) for i = 1:size(data)[1]]
data.ALT = [0.0 for i = 1:size(data)[1]]
data.AZ = [0.0 for i = 1:size(data)[1]]

# Convert strings to numbers
for i = 1:size(data)[1]
    valstrings = split(data["CoordString"][i], " ")
    data.RA[i] = (parse(Int, valstrings[1]), parse(Int, valstrings[2]), parse(Float64, valstrings[3]))
    data.DEC[i] = (parse(Int, valstrings[4]), parse(Int, valstrings[5]), parse(Float64, valstrings[6]))
    alti, azi = equatorial2horizontal(DMS(data.RA[i]), DMS(data.DEC[i]), lat, lon, tz_time)
    data.ALT[i], data.AZ[i] = alti.D, azi.D
end

# Polar plot goes 0 -> 90 deg from center to edge
# altitude goes 90 -> 0 from center to edge
# Define zenith distance as 90 - altitude
data.ZD = 90 .- data.ALT

visible = data[(0 .< data.ALT .< 90), :]

bright = visible[(visible.V .≤ 6.5), :]

print(bright.ALT)
# Plot bottom border
θ = 0:1:360
r = [90 for i=1:length(θ)]
p = plot(θ, r, title="Test Chart", proj = :polar)

p = scatter!(bright.ALT, bright.AZ, m=:o)

#scatter(stars[1].RA.D, stars[1].DEC.D)
#scatter!(stars[2].RA.D, stars[2].DEC.D)
