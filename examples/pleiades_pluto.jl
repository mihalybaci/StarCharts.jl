### A Pluto.jl notebook ###
# v0.11.14

using Markdown
using InteractiveUtils

# ╔═╡ b7d339c4-ff3f-11ea-1611-c7b9f518ff48
using StarCharts

# ╔═╡ cc46977a-ff3f-11ea-2940-2f2d5f5f78bf
using TimeZones

# ╔═╡ c7ed2366-edf5-11ea-28d8-35dc55156fea
md"# A couple of star position tests"

# ╔═╡ 8ffb91a0-f67d-11ea-3708-7b1fdaec8ced
md"### Test for viewing Betelgeuse from Washington, DC"

# ╔═╡ d3ecb1ee-ff3f-11ea-282d-838ad9ab6764
md"**The dict will specialize on one type if instantiated with that type. Avoid that by creating empty dict first.**"

# ╔═╡ f02fdd40-ff3f-11ea-09b9-1188c0ae6daa
md"Position of Washington, D.C."

# ╔═╡ a797151e-f67d-11ea-1593-3bf82a78d9ce
begin
	dc = Dict()
	dc["lat"] = DMS(38, 54, 17)
	dc["lon"] = DMS(-77, 00, 59)
end

# ╔═╡ 3e9ba93a-f35d-11ea-2c7d-5946335002aa
md"""Betelgeuse's position is (RA, DEC) = (05h 55m 10.30536s, +07° 24′ 25.4304″)"""

# ╔═╡ 28a75588-f67e-11ea-2682-5912a12c2f4f
begin
	betelgeuse = Dict()
	betelgeuse["RA"] = HMS(05, 55, 10.30536)
	betelgeuse["DEC"] = DMS(07, 24, 25.4304)
end

# ╔═╡ 82d93486-f67e-11ea-1ac7-4d7a269f9a3d
betelgeuse["α"], betelgeuse["δ"] = convert(DecimalDegree, betelgeuse["RA"]), convert(DecimalDegree, betelgeuse["DEC"])

# ╔═╡ d085eaf8-f35e-11ea-372f-51463b95e1fd
dc["ϕ"], dc["λ"] = convert(DecimalDegree, dc["lat"]), convert(DecimalDegree, dc["lon"])

# ╔═╡ 6ee858e0-f362-11ea-17e9-9730aa54b8a0
date_est = ZonedDateTime(2020, 09, 23, 05, 30, 0, localzone())

# ╔═╡ ce5c8d66-fd9c-11ea-37b8-614263b2b32e
astimezone(date_est, TimeZone("UTC"))

# ╔═╡ 2003811c-f370-11ea-2cc8-875dd4f8fd4d
dc["LST"] = lst(date_est, dc["λ"])

# ╔═╡ 02d12aca-f683-11ea-17dc-fd2a0ca2cc88
dc["LST"]

# ╔═╡ fa093092-f67e-11ea-05a6-892a4f21311f
convert(HMS, dc["LST"])  # astronav value = (4h, 32m, 42.66832s)

# ╔═╡ ec73c1bc-f67f-11ea-14bc-553ed27cb948
betelgeuse["ha"] = lha(dc["LST"], betelgeuse["α"])

# ╔═╡ 88e467dc-f684-11ea-1e9a-f1af7026b682
24 + convert(HMS, betelgeuse["ha"])  # astronav value = (22h, 37m, 32.36296s)

# ╔═╡ bc7193d8-f371-11ea-06cd-f311c11f6061
betelgeuse["alt"] = altitude(dc["ϕ"], betelgeuse["δ"], betelgeuse["ha"])

# ╔═╡ 738877ae-f446-11ea-00b9-69cf9f54ce75
convert(DMS, betelgeuse["alt"])  # Astronav value = (53d, 26m, 28.65902s)

# ╔═╡ 9d08356c-f444-11ea-154c-4b6aa2893d77
betelgeuse["az"] = azimuth(betelgeuse["alt"], betelgeuse["δ"], betelgeuse["ha"])

# ╔═╡ 97dbe1ce-f446-11ea-1cac-3fc3ca2ce8f8
180 + convert(DMS, betelgeuse["az"])  # Astronav value from north = (144d, 6m, 50.98964s)

# ╔═╡ 47f0954c-f38d-11ea-0079-db8374e59d5b
betelgeuse["max_alt"] = maximum_altitude(dc["ϕ"], betelgeuse["δ"])

# ╔═╡ 18c3c31a-f424-11ea-0e59-f186e751f537
convert(DMS, betelgeuse["max_alt"])  # Astronav value = (58d, 30m, 8.430400s)

# ╔═╡ eb21981c-f446-11ea-03be-ff831a78d245
md"**Now transform the coordinates using the `equatorial2horizontal` function**"

# ╔═╡ 0dd9d4a8-f447-11ea-354a-0fe7def5cebd
betelgeuse["alt_easy"], betelgeuse["az_easy"] = equatorial2horizontal(betelgeuse["RA"], betelgeuse["DEC"], dc["lat"], dc["lon"], date_est)

# ╔═╡ e3ab2bdc-ff40-11ea-3430-9d04813417a2
md"### Test equations using rotation matrices instead of the current equations."

# ╔═╡ f7703234-ff40-11ea-1368-2d3887b74109
Rx(α) = [1   0      0
		 0  cos(α) sin(α)
		 0 -sin(α) cos(α)]

# ╔═╡ 2006a9a0-ff41-11ea-2632-4dcd3068a7af
Ry(β) = [cos(β) 0 -sin(β)
		   0    1   0
		 sin(β) 0  cos(β)]

# ╔═╡ 5d71bd78-ff41-11ea-0a2d-6b1277e5f003
Rz(γ)  = [ cos(γ) sin(γ)  0
		  -sin(γ) cos(γ)  0
			0      0      1]

# ╔═╡ 024e8056-ff42-11ea-2545-05d9e9d71d95
lat_rad = convert(Radian, dc["lat"]).R

# ╔═╡ 2c88fec8-ff42-11ea-2500-c35eac0a10b5
ha_rad = convert(Radian, betelgeuse["ha"]).R

# ╔═╡ cfdebc86-ff42-11ea-0d2d-0dd0ff0b8122
L1 = [cos(convert(Radian, betelgeuse["δ"]).R)*cos(convert(Radian, betelgeuse["ha"]).R)
	 cos(convert(Radian, betelgeuse["δ"]).R)*sin(convert(Radian, betelgeuse["ha"]).R)
	 sin(convert(Radian, betelgeuse["δ"]).R)]

# ╔═╡ 40c5b516-ff42-11ea-2de7-f9e4f2abab98
L2 = Rz(π)*Ry(π/2 - lat_rad)*L1

# ╔═╡ e06f22c6-ff44-11ea-3e12-bd8ed48141dd
z = acos(L2[3])

# ╔═╡ 7647fd9c-ff43-11ea-35bd-992b204bc173
alternate_alt = 90 - convert(DMS, Radian(z))

# ╔═╡ 8330b7dc-ff44-11ea-3546-efe8fc5433c4
convert(DMS, betelgeuse["alt"])

# ╔═╡ ecd2b406-ff44-11ea-15c1-8b583392c117
a = acos(L2[1]/sin(z))

# ╔═╡ b0a70914-ff44-11ea-06f0-277fac7bea0d
alternate_az = convert(DMS, Radian(a))

# ╔═╡ 43ba152a-ff45-11ea-082f-a9a616fb667a
convert(DMS, betelgeuse["az"]) + 180

# ╔═╡ Cell order:
# ╟─c7ed2366-edf5-11ea-28d8-35dc55156fea
# ╟─8ffb91a0-f67d-11ea-3708-7b1fdaec8ced
# ╠═b7d339c4-ff3f-11ea-1611-c7b9f518ff48
# ╠═cc46977a-ff3f-11ea-2940-2f2d5f5f78bf
# ╟─d3ecb1ee-ff3f-11ea-282d-838ad9ab6764
# ╠═f02fdd40-ff3f-11ea-09b9-1188c0ae6daa
# ╠═a797151e-f67d-11ea-1593-3bf82a78d9ce
# ╟─3e9ba93a-f35d-11ea-2c7d-5946335002aa
# ╠═28a75588-f67e-11ea-2682-5912a12c2f4f
# ╠═82d93486-f67e-11ea-1ac7-4d7a269f9a3d
# ╠═d085eaf8-f35e-11ea-372f-51463b95e1fd
# ╠═6ee858e0-f362-11ea-17e9-9730aa54b8a0
# ╠═ce5c8d66-fd9c-11ea-37b8-614263b2b32e
# ╠═2003811c-f370-11ea-2cc8-875dd4f8fd4d
# ╠═02d12aca-f683-11ea-17dc-fd2a0ca2cc88
# ╠═fa093092-f67e-11ea-05a6-892a4f21311f
# ╠═ec73c1bc-f67f-11ea-14bc-553ed27cb948
# ╠═88e467dc-f684-11ea-1e9a-f1af7026b682
# ╠═bc7193d8-f371-11ea-06cd-f311c11f6061
# ╠═738877ae-f446-11ea-00b9-69cf9f54ce75
# ╠═9d08356c-f444-11ea-154c-4b6aa2893d77
# ╠═97dbe1ce-f446-11ea-1cac-3fc3ca2ce8f8
# ╠═47f0954c-f38d-11ea-0079-db8374e59d5b
# ╠═18c3c31a-f424-11ea-0e59-f186e751f537
# ╟─eb21981c-f446-11ea-03be-ff831a78d245
# ╠═0dd9d4a8-f447-11ea-354a-0fe7def5cebd
# ╟─e3ab2bdc-ff40-11ea-3430-9d04813417a2
# ╠═f7703234-ff40-11ea-1368-2d3887b74109
# ╠═2006a9a0-ff41-11ea-2632-4dcd3068a7af
# ╠═5d71bd78-ff41-11ea-0a2d-6b1277e5f003
# ╠═024e8056-ff42-11ea-2545-05d9e9d71d95
# ╠═2c88fec8-ff42-11ea-2500-c35eac0a10b5
# ╠═cfdebc86-ff42-11ea-0d2d-0dd0ff0b8122
# ╠═40c5b516-ff42-11ea-2de7-f9e4f2abab98
# ╠═e06f22c6-ff44-11ea-3e12-bd8ed48141dd
# ╠═7647fd9c-ff43-11ea-35bd-992b204bc173
# ╠═8330b7dc-ff44-11ea-3546-efe8fc5433c4
# ╠═ecd2b406-ff44-11ea-15c1-8b583392c117
# ╠═b0a70914-ff44-11ea-06f0-277fac7bea0d
# ╠═43ba152a-ff45-11ea-082f-a9a616fb667a
