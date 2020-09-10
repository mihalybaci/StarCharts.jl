### A Pluto.jl notebook ###
# v0.11.14

using Markdown
using InteractiveUtils

# ╔═╡ 611cc5f2-edf9-11ea-2b42-b38a547930c4
begin
	using Dates  # This provides the DateTime 
	using StarCharts
end

# ╔═╡ c7ed2366-edf5-11ea-28d8-35dc55156fea
md"# How to use StarCharts.jl"

# ╔═╡ deb83a0e-edf5-11ea-0c00-b960cf65608e
md"### This notebook will go through the steps to find the altitude and azimuth of Polaris from New York City on 2021 January 1 at midnight."

# ╔═╡ 28618678-f2bb-11ea-0839-57eccfc1824e
md"Load up the two packages we will need."

# ╔═╡ 8dd6b554-f35c-11ea-00fc-411ca9664303
md"""StarCharts defines coordinate types for decimal degrees (DecimalDegrees), degrees-minutes-seconds (DMS), decimal hours (DecimalHours), and hours-minutes-seconds (HMS). These will be used for Polaris' position in the sky and New York City's lat/lon.



"""

# ╔═╡ 3e9ba93a-f35d-11ea-2c7d-5946335002aa
md"""Polaris' position is (RA, DEC) = (02h 31m 49.09s, +89° 15′ 50.8″)"""

# ╔═╡ 31e60b72-f35d-11ea-3b8f-d1a1b9d292c9
ra, dec = HMS(02, 31, 49.09), DMS(89, 15,50.8)

# ╔═╡ 4778f2f6-f35d-11ea-2dfe-adea5881ea8a
md"""New York City's location is (Lat, Lon) = (40°42′46″N, 74°00′22″W)"""

# ╔═╡ 390e3e56-f35d-11ea-18ef-7be5437bc880
lat, lon = DMS(38, 54, 17), DMS(-77, 00, 59)

# ╔═╡ 59395760-f35d-11ea-0b24-df4239534ace
md"From Observational Astronomy (2nd ed.) by Birney, Gonzalez, & Oesper, the altitude and azimuth are given by:

	sin(alt) = sin(ϕ)sin(δ) + cos(ϕ)cos(HA)
	sin(az) = cos(δ)sin(HA)/cos(alt)

where ϕ is the latitude, δ is the declination, and HA is the hour angle."

# ╔═╡ 1a861f84-f35e-11ea-0adb-d3580ab64515
md"Before solving the equations, convert qunatities to degrees and define two helper functions to avoid typing out `deg2rad` multiple times."

# ╔═╡ 85cd03a2-f35e-11ea-3a75-cd4c54c27872
α, δ = convert(DecimalDegree, ra), convert(DecimalDegree, dec)

# ╔═╡ d085eaf8-f35e-11ea-372f-51463b95e1fd
ϕ, λ = convert(DecimalDegree, lat), convert(DecimalDegree, lon)

# ╔═╡ 886e0170-edf6-11ea-3c9e-6b1130a2e1a4
dsin(β) = sin(deg2rad(β))

# ╔═╡ 92386e8c-edf6-11ea-3790-631c7376ba6c
dcos(β) = cos(deg2rad(β))

# ╔═╡ fb69c674-f361-11ea-2e09-796d4f27238f
md"Set the date of 2021 January 1 00:00:00 Eastern Standard Time (EST)."

# ╔═╡ 6ee858e0-f362-11ea-17e9-9730aa54b8a0
date_est = DateTime(2021, 01, 01, 0, 0, 0)

# ╔═╡ 0b45912a-f364-11ea-09e7-1ffbba3658d0
md"Getting the hour angle requires calculating the local sidereal time (LST) for a specific place and date, which requires the UTC. The conversion from EST to UTC is simply to add 4 hours."

# ╔═╡ e842f6ae-f363-11ea-13fa-c578eb84fc22
date_utc = date_est + Dates.Hour(4)

# ╔═╡ 94285038-f362-11ea-0be7-b75cf6bd7127
md"**NOTE:** The `lst` function is designed to read timezones from the computer, so in pratice there is no need to manually manipulate datetimes for local maps."

# ╔═╡ 2d29f774-f362-11ea-01ec-19cecf1ee877
hour_angle = ha(LST, α)

# ╔═╡ d608c254-f361-11ea-30a1-ff75ca2a0fe1
#alt = dsin(ϕ)*dsin(δ) + dcos(ϕ)*dcos(

# ╔═╡ Cell order:
# ╟─c7ed2366-edf5-11ea-28d8-35dc55156fea
# ╟─deb83a0e-edf5-11ea-0c00-b960cf65608e
# ╟─28618678-f2bb-11ea-0839-57eccfc1824e
# ╠═611cc5f2-edf9-11ea-2b42-b38a547930c4
# ╟─8dd6b554-f35c-11ea-00fc-411ca9664303
# ╟─3e9ba93a-f35d-11ea-2c7d-5946335002aa
# ╠═31e60b72-f35d-11ea-3b8f-d1a1b9d292c9
# ╟─4778f2f6-f35d-11ea-2dfe-adea5881ea8a
# ╠═390e3e56-f35d-11ea-18ef-7be5437bc880
# ╟─59395760-f35d-11ea-0b24-df4239534ace
# ╟─1a861f84-f35e-11ea-0adb-d3580ab64515
# ╠═85cd03a2-f35e-11ea-3a75-cd4c54c27872
# ╠═d085eaf8-f35e-11ea-372f-51463b95e1fd
# ╠═886e0170-edf6-11ea-3c9e-6b1130a2e1a4
# ╠═92386e8c-edf6-11ea-3790-631c7376ba6c
# ╟─fb69c674-f361-11ea-2e09-796d4f27238f
# ╠═6ee858e0-f362-11ea-17e9-9730aa54b8a0
# ╟─0b45912a-f364-11ea-09e7-1ffbba3658d0
# ╠═e842f6ae-f363-11ea-13fa-c578eb84fc22
# ╟─94285038-f362-11ea-0be7-b75cf6bd7127
# ╠═2d29f774-f362-11ea-01ec-19cecf1ee877
# ╠═d608c254-f361-11ea-30a1-ff75ca2a0fe1
