@info "Beginning tests for StarCharts.jl..."
@info "Loading packages"
using StarCharts
using Test
using TimeZones

@info "Running conversion tests"

# Define a set of 15 floats to test a range of possible position values
test_coords = [0.0, 10.123, 15.87567, 
                    180.0, 270.0009, 359.9999, 
                    360.0017, 380.201, 12345.678, 
                    -5.55464, -30.5959, -180.0, 
                    -310.000001, -360.0, -0.000054321]

# Expected values
# Allowed range of DD/DMS values -360 < θ < 360
# Allowed range of DH/HMS values -24 < θ < 24
# Allowed range of radian values -2π < θ < 2π
dd_coords = [0.0, 10.123, 15.87567, 
                   180.0, 270.0009, 359.9999,
                   0.0017, 20.201, 105.678,
                   -5.55464, -30.5959, -180.0, 
                   -310.000001, 0.0, -0.000054321]

# These calculated values ARE NOT rounded
dh_coords = dd_coords/15
rad_coords = deg2rad.(dd_coords)

# These calculated values ARE rounded to the milliseconds place
# This leads to a change of , e.g., 3e-10 in the value 15.87567
dms_coords = [(0, 0, 0), (10, 7, 22.800000), (15, 52, 32.412), 
              (180, 0, 0), (270, 0, 3.24), (359, 59, 59.64),
              (0, 0, 6.12), (20, 12, 3.6), (105, 40, 40.8), 
              (-5, 33, 16.704), (-30, 35, 45.24), (-180, 0, 0),
              (-310, 0, 0.0036), (0, 0, 0.0), (0, 0, -0.1955556)]

hms_coords = [(0, 0, 0.0), (0, 40, 29.52), (1, 3, 30.1608), 
              (12, 0, 0.0), (18, 0, 0.216), (23, 59, 59.976), 
              (0, 0, 0.408), (1, 20, 48.24), (7, 2, 42.72), 
              (0, -22, 13.1136), (-2, 2, 23.016), (-12, 0, .0), 
              (-20, 40, 0.00024), (0, 0, 0.0), (0, 0, -0.01303704)]

# Create dictionary for testing coordinate types and conversions
testing_coordinates = Dict()  # Must do this or Dict() specializes
testing_coordinates["dd"] = [DecimalDegree(test_coords[i]) for i = 1:length(test_coords)]
testing_coordinates["dh"] = convert.(DecimalHour, testing_coordinates["dd"])
testing_coordinates["dms"] = convert.(DMS, testing_coordinates["dd"])
testing_coordinates["hms"] = convert.(HMS, testing_coordinates["dd"])
testing_coordinates["rad"] = convert.(Radian, testing_coordinates["dd"])

# Create dictionary for the expected values of the cordinates
expected_coordinates = Dict("dd" => [DecimalDegree(dd_coords[i]) for i = 1:length(test_coords)],
                            "dms" => [DMS(dms_coords[i]) for i = 1:length(test_coords)], 
                            "dh" => [DecimalHour(dh_coords[i]) for i = 1:length(test_coords)], 
                            "hms" => [HMS(hms_coords[i]) for i = 1:length(test_coords)], 
                            "rad" => [Radian(rad_coords[i]) for i = 1:length(test_coords)])

# Use ≈ when floating point errors become an issue
@testset "Types" begin
    for i = 1:length(test_coords)
        # Create new variables to save typing
        tdd = testing_coordinates["dd"][i]
        tdms = testing_coordinates["dms"][i]
        tdh = testing_coordinates["dh"][i]
        thms = testing_coordinates["hms"][i]
        trad = testing_coordinates["rad"][i]

        edd = expected_coordinates["dd"][i]
        edms = expected_coordinates["dms"][i]
        edh = expected_coordinates["dh"][i]
        ehms = expected_coordinates["hms"][i]
        erad = expected_coordinates["rad"][i]

        # Ensure that types are constructed properly
        # This also tests that get() works from ../src/utils.jl
        @testset "Constructors: $(dd_coords[i])" begin
            @test get(edd) == dd_coords[i]
            @test get(edms) == dms_coords[i]
            @test get(edh) == dh_coords[i]
            @test get(ehms) == hms_coords[i]
            @test get(erad) == rad_coords[i]
        end

        # Ensure that identity conversions are correct
        # Not using get() since each tuple element needs
        # to be separate to use ≈ for floating point errors
        @testset "Identities: $(dd_coords[i])" begin
            @test convert(DecimalDegree, tdd).D ≈ edd.D 
            @test convert(DecimalHour, tdh).H ≈ edh.H 
            @test convert(Radian, trad).R ≈ erad.R
            @test convert(DMS, tdms).D == edms.D  # Int should be exact
            @test convert(DMS, tdms).M == edms.M  # Int should be exact
            @test convert(DMS, tdms).S ≈ edms.S
            @test convert(HMS, thms).H == ehms.H  # Int should be exact
            @test convert(HMS, thms).M == ehms.M  # Int should be exact
            @test convert(HMS, thms).S ≈ ehms.S
        end
        # Ensure that general conversions are correct
        # Only testing a (hopefully well-chosen) subset
        @testset "General: $(dd_coords[i])" begin
            @test convert(DecimalDegree, thms).D ≈ edd.D #atol=1e-1
            @test convert(DecimalHour, tdms).H ≈ edh.H
            @test convert(Radian, thms).R ≈ erad.R
            @test convert(DMS, trad).D == edms.D  # Int should be exact
            @test convert(DMS, trad).M == edms.M  # Int should be exact
            @test convert(DMS, trad).S ≈ edms.S  # Int should be exact
            @test convert(DMS, thms).D == edms.D  # Int should be exact
            @test convert(DMS, thms).M == edms.M  # Int should be exact
            @test convert(DMS, thms).S ≈ edms.S  # Int should be exact
            @test convert(HMS, tdms).H == ehms.H  # Int should be exact
            @test convert(HMS, tdms).M == ehms.M  # Int should be exact
            @test convert(HMS, tdms).S ≈ ehms.S  # Int should be exact
        end
    end
end

@testset "Coordinate Math" begin
    @testset "Addition" begin
        @test DecimalDegree(10) + 1 == DecimalDegree(11)
        @test 1.5 + DecimalDegree(359.5) == DecimalDegree(1.0)        
        @test DecimalDegree(100) + DecimalDegree(-50) == DecimalDegree(50)
        @test (HMS(12, 12, 30) + 1.5).H == HMS(13, 42, 30).H
        @test (1.5 + HMS(12, 12, 30)).M == HMS(13, 42, 30).M
        @test (HMS(12, 12, 30) + 1.5).S ≈ HMS(13, 42, 30).S
        @test (DMS(357, 0, 0) + 10.5).D == DMS(7, 30, 0).D
        @test (DMS(357, 0, 0) + 10.5).M == DMS(7, 30, 0).M
        @test (10.5 + DMS(357, 0, 0)).S ≈ DMS(7, 30, 0).S
    end

    @testset "Subtraction" begin
        @test DecimalDegree(-10) - 1 == DecimalDegree(-11)
        @test 0.0003 - DecimalDegree(1.002) == DecimalDegree(-1.0017)
        @test DecimalDegree(123.123) - DecimalDegree(123.123) == DecimalDegree(0.0)
        @test (HMS(12, 12, 30) - 1.5).H == HMS(10, 18, 30).H
        @test (1.5 - HMS(12, 12, 30)).M == HMS(-10, 42, 30).M
        @test (HMS(12, 12, 30) - 1.).S ≈ HMS(11, 12, 30).S
        @test (DMS(357, 0, 0.0) - 10.5).D == DMS(346, 30, 0.0).D
        @test (DMS(357, 0, 0.0) - 10.5).M == DMS(346, 30, 0.0).M
        @test (360 - DMS(357, 0, 0.0)).S ≈ DMS(-3, 0, 0.0).S
    end
end

# Variables needed to test time functions
dc = Dict()
dc["lat"] = DMS(38, 54, 17)
dc["lon"] = DMS(-77, 00, 59)  # Position of Washington, DC

pleiades = Dict()
pleiades["RA"] = HMS(03, 47, 24)
pleiades["DEC"] = DMS(24, 07, 0)  #J2000 RA, DEC Pleiades

pleiades["α"], pleiades["δ"] = convert(DecimalDegree, pleiades["RA"]), convert(DecimalDegree, pleiades["DEC"])

dc["ϕ"], dc["λ"] = convert(DecimalDegree, dc["lat"]), convert(DecimalDegree, dc["lon"])

date_est = ZonedDateTime(2020, 09, 23, 05, 30, 0, localzone())

dc["LST"] = lst(date_est, dc["λ"])
pleiades["ha"] = lha(dc["LST"], pleiades["α"])
# Comparisons values calculated from https://jukaukor.mbnet.fi/star_altitude.html
# The site uses different equations for GMST and LST, so the values WILL NOT
# be identical. Accuracy generally less than 1s.
@testset "Time Functions" begin
    @test convert(HMS, dc["LST"]).H == HMS(4, 32, 42.66832).H 
    @test convert(HMS, dc["LST"]).M == HMS(4, 32, 42.66832).M  
    @test convert(HMS, dc["LST"]).S ≈ HMS(4, 32, 42.66832).S atol=0.5
    @test convert(HMS, pleiades["ha"]).H == HMS(0, 45, 18.66832).H
    @test convert(HMS, pleiades["ha"]).M == HMS(0, 45, 18.66832).M
    @test convert(HMS, pleiades["ha"]).S ≈ HMS(0, 45, 18.66832).S atol=0.5
end



pleiades["alt"] = altitude(dc["ϕ"], pleiades["δ"], pleiades["ha"])
pleiades["az"] = azimuth(pleiades["alt"], pleiades["δ"], pleiades["ha"])
pleiades["max_alt"] = maximum_altitude(dc["ϕ"], pleiades["δ"])


@testset "Coordinates" begin
    @test convert(DMS, pleiades["alt"]).D == DMS(72, 22, 17.48842).D
    @test convert(DMS, pleiades["alt"]).M == DMS(72, 22, 17.48842).M
    @test convert(DMS, pleiades["alt"]).S ≈ DMS(72, 22, 17.48842).S atol=0.5
    @test convert(DMS, pleiades["az"]).D == (DMS(216, 17, 51.27137) + 180).D
    @test convert(DMS, pleiades["az"]).M == (DMS(216, 17, 51.27137) + 180).M
    @test convert(DMS, pleiades["az"]).S ≈ (DMS(216, 17, 51.27137) + 180).S atol=0.5
    @test convert(DMS, pleiades["max_alt"]).D == DMS(75, 12, 42.99999).D
    @test convert(DMS, pleiades["max_alt"]).M == DMS(75, 12, 42.99999).M
    @test convert(DMS, pleiades["max_alt"]).S ≈ DMS(75, 12, 42.99999).S atol=0.5
end