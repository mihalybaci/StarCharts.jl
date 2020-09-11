### A Pluto.jl notebook ###
# v0.11.14

using Markdown
using InteractiveUtils

# ╔═╡ 37058e16-f443-11ea-30cc-5b8be9a6b7de
using TimeZones

# ╔═╡ 611cc5f2-edf9-11ea-2b42-b38a547930c4
using StarCharts

# ╔═╡ c7ed2366-edf5-11ea-28d8-35dc55156fea
md"# How to use StarCharts.jl"

# ╔═╡ deb83a0e-edf5-11ea-0c00-b960cf65608e
md"### This notebook will go through the steps to find the altitude and azimuth of Polaris from New York City on 2021 January 1 at midnight."

# ╔═╡ b5dee1a4-f445-11ea-28a9-6b4482e8ae46
md"**First go step-by-step**"

# ╔═╡ 28618678-f2bb-11ea-0839-57eccfc1824e
md"Load up the two packages we will need."

# ╔═╡ 8dd6b554-f35c-11ea-00fc-411ca9664303
md"""StarCharts defines coordinate types for decimal degrees (DecimalDegrees), degrees-minutes-seconds (DMS), decimal hours (DecimalHours), and hours-minutes-seconds (HMS). These will be used for Polaris' position in the sky and New York City's lat/lon.



"""

# ╔═╡ 3e9ba93a-f35d-11ea-2c7d-5946335002aa
md"""Polaris' position is (RA, DEC) = (02h 31m 49.09s, +89° 15′ 50.8″)"""

# ╔═╡ 31e60b72-f35d-11ea-3b8f-d1a1b9d292c9
ra, dec = HMS(02, 31, 49.09), DMS(89, 15, 50.8)

# ╔═╡ 4778f2f6-f35d-11ea-2dfe-adea5881ea8a
md"""New York City's location is (Lat, Lon) = (40°42′46″N, 74°00′22″W)"""

# ╔═╡ 390e3e56-f35d-11ea-18ef-7be5437bc880
lat, lon = DMS(40, 42, 46), DMS(-74, 00, 22)

# ╔═╡ 59395760-f35d-11ea-0b24-df4239534ace
md"From Observational Astronomy (2nd ed.) by Birney, Gonzalez, & Oesper, the altitude and azimuth are given by:

	sin(alt) = sin(ϕ)sin(δ) + cos(ϕ)cos(HA)
	sin(az) = cos(δ)sin(HA)/cos(alt)

where ϕ is the latitude, δ is the declination, and HA is the hour angle."

# ╔═╡ 85cd03a2-f35e-11ea-3a75-cd4c54c27872
α, δ = convert(DecimalDegree, ra), convert(DecimalDegree, dec)

# ╔═╡ d085eaf8-f35e-11ea-372f-51463b95e1fd
ϕ, λ = convert(DecimalDegree, lat), convert(DecimalDegree, lon)

# ╔═╡ fb69c674-f361-11ea-2e09-796d4f27238f
md"Set the date of 2021 January 1 00:00:00 Eastern Standard Time (EST)."

# ╔═╡ 6ee858e0-f362-11ea-17e9-9730aa54b8a0
date_est = ZonedDateTime(2021, 01, 01, 0, 0, 0, localzone())

# ╔═╡ 0b45912a-f364-11ea-09e7-1ffbba3658d0
md"Getting the hour angle requires calculating the local sidereal time (LST) for a specific place and date, which requires the UTC. The conversion from EST to UTC is simply to add 5 hours."

# ╔═╡ e842f6ae-f363-11ea-13fa-c578eb84fc22
date_utc = date_est + TimeZones.Hour(5)

# ╔═╡ 94285038-f362-11ea-0be7-b75cf6bd7127
md"**NOTE:** The `lst` function is designed to read timezones from the computer, so in pratice there is no need to manually manipulate datetimes for local maps."

# ╔═╡ 2003811c-f370-11ea-2cc8-875dd4f8fd4d
LST = lst(date_utc, λ, localtime=false)

# ╔═╡ c838cf00-f38d-11ea-2b7d-c1f36f5c2f4a
convert(HMS, LST)  # Astronav value = (6h, 48, 16.318s)

# ╔═╡ 3ceb1ed2-f370-11ea-0bf3-e37cab474aa6
ha = lha(LST, α)

# ╔═╡ cc3b3a04-f38e-11ea-127a-65beb0237f9f
convert(HMS, ha)  # Astronav value = (4h, 16m, 27.223s)

# ╔═╡ d02820de-f38c-11ea-2ad3-fba8fa600222
md"Before solving the equations, convert qunatities to degrees and define two helper functions to avoid typing out `deg2rad` multiple times."

# ╔═╡ bc7193d8-f371-11ea-06cd-f311c11f6061
alt = altitude(ϕ, δ, ha)

# ╔═╡ 738877ae-f446-11ea-00b9-69cf9f54ce75
convert(DMS, alt)  # Astronav value = (41h, 11m, 33.059s)

# ╔═╡ 9d08356c-f444-11ea-154c-4b6aa2893d77
az = azimuth(alt, δ, ha)

# ╔═╡ 97dbe1ce-f446-11ea-1cac-3fc3ca2ce8f8
DMS(360, 0, 0) - convert(DMS, az)  # Astronav value = (359d, 07m, 20.480s)

# ╔═╡ fdba389e-f38b-11ea-1d65-f1b54b70672c
md"Since Polaris has an DEC ≈ 90, it's altitude should follow the simple relationship:
	
	alt(Polaris) ≈ lat(NYC)
	41.1925 ≈ 40.71

Pretty good. As the star rotates around the North Celestial Pole, the maximum altitude can be found as well by the following equation

	max_alt = (90 - δ) + ϕ

which should yield an identical result to calculating the altitude with the local hour angle equal to zero."

# ╔═╡ 47f0954c-f38d-11ea-0079-db8374e59d5b
max_alt = maximum_altitude(ϕ, δ)

# ╔═╡ 18c3c31a-f424-11ea-0e59-f186e751f537
convert(DMS, max_alt)  # Astronav value = (41d, 26m, 55.200s)

# ╔═╡ eb21981c-f446-11ea-03be-ff831a78d245
md"**Now transform the coordinates using the `equatorial2horizontal` function**"

# ╔═╡ 0dd9d4a8-f447-11ea-354a-0fe7def5cebd
alt_easy, az_easy = equatorial2horizontal(ra, dec, lat, lon, date_est)

# ╔═╡ 28868508-f447-11ea-14f8-872160646fa2
alt_easy == alt

# ╔═╡ cb957830-f447-11ea-3fe3-77192f4a62da
az_easy == az

# ╔═╡ Cell order:
# ╟─c7ed2366-edf5-11ea-28d8-35dc55156fea
# ╟─deb83a0e-edf5-11ea-0c00-b960cf65608e
# ╟─b5dee1a4-f445-11ea-28a9-6b4482e8ae46
# ╟─28618678-f2bb-11ea-0839-57eccfc1824e
# ╠═37058e16-f443-11ea-30cc-5b8be9a6b7de
# ╠═611cc5f2-edf9-11ea-2b42-b38a547930c4
# ╟─8dd6b554-f35c-11ea-00fc-411ca9664303
# ╟─3e9ba93a-f35d-11ea-2c7d-5946335002aa
# ╠═31e60b72-f35d-11ea-3b8f-d1a1b9d292c9
# ╟─4778f2f6-f35d-11ea-2dfe-adea5881ea8a
# ╠═390e3e56-f35d-11ea-18ef-7be5437bc880
# ╟─59395760-f35d-11ea-0b24-df4239534ace
# ╠═85cd03a2-f35e-11ea-3a75-cd4c54c27872
# ╠═d085eaf8-f35e-11ea-372f-51463b95e1fd
# ╟─fb69c674-f361-11ea-2e09-796d4f27238f
# ╠═6ee858e0-f362-11ea-17e9-9730aa54b8a0
# ╟─0b45912a-f364-11ea-09e7-1ffbba3658d0
# ╠═e842f6ae-f363-11ea-13fa-c578eb84fc22
# ╟─94285038-f362-11ea-0be7-b75cf6bd7127
# ╠═2003811c-f370-11ea-2cc8-875dd4f8fd4d
# ╠═c838cf00-f38d-11ea-2b7d-c1f36f5c2f4a
# ╠═3ceb1ed2-f370-11ea-0bf3-e37cab474aa6
# ╠═cc3b3a04-f38e-11ea-127a-65beb0237f9f
# ╟─d02820de-f38c-11ea-2ad3-fba8fa600222
# ╠═bc7193d8-f371-11ea-06cd-f311c11f6061
# ╠═738877ae-f446-11ea-00b9-69cf9f54ce75
# ╠═9d08356c-f444-11ea-154c-4b6aa2893d77
# ╠═97dbe1ce-f446-11ea-1cac-3fc3ca2ce8f8
# ╟─fdba389e-f38b-11ea-1d65-f1b54b70672c
# ╠═47f0954c-f38d-11ea-0079-db8374e59d5b
# ╠═18c3c31a-f424-11ea-0e59-f186e751f537
# ╟─eb21981c-f446-11ea-03be-ff831a78d245
# ╠═0dd9d4a8-f447-11ea-354a-0fe7def5cebd
# ╠═28868508-f447-11ea-14f8-872160646fa2
# ╠═cb957830-f447-11ea-3fe3-77192f4a62da
