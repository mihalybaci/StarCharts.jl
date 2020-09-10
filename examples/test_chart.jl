#=

    Test the chart making ability, eventually move tests to test.jl
    and make this just an example of how to build a chart.

=#

#=
include("../src/StarCharts.jl")

function test_stars()
    grid = []
    for dec = -90:15:90
        for ra = 0:30:360
            push!(grid, Star(DecimalDegree(ra), DecimalDegree(dec)))
        end
    end
    return grid
end

function make_chart(star_list)
    altitudes = []
    azimuths = []

    for star in star_list
        push!(altitudes, star.RA.D)
        push!(azimuths, star.DEC.D)
    end

    p = Plots.plot(title="Test Chart", proj = :polar)

    p = Plots.scatter!(altitudes, azimuths, m=:o)

    return p
end


stars = test_stars()
star_chart = make_chart(stars)
plot(star_chart)

scatter(stars[1].RA.D, stars[1].DEC.D)
scatter!(stars[2].RA.D, stars[2].DEC.D)
=#