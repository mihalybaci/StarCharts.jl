### A Pluto.jl notebook ###
# v0.11.12

using Markdown
using InteractiveUtils

# ╔═╡ fd2f2740-eeba-11ea-1413-01381e6ee34e
using Dates  # Import the Dates package

# ╔═╡ 7f1320b2-eeba-11ea-235c-a3562e12e8e7
md"## Calculate the GMST"

# ╔═╡ 6ee10096-eebb-11ea-237b-c7e669860811
md"### This version of GMST is copied from the source code of this website: ###

**https://community.dur.ac.uk/john.lucey/users/lst.html**"

# ╔═╡ 3042679e-eebb-11ea-2e67-75bef0086611
md" Convert UTC to Julian date"

# ╔═╡ 431e9a44-eebc-11ea-33ab-416a6ec03189
const seconds_per_day = 24*3600.0

# ╔═╡ d529d154-eebe-11ea-3dde-b5ac1c2c507f
md"**Now calculate the GMST in arcseconds**"

# ╔═╡ 0e93a2d0-eebf-11ea-0f0d-7be1055d6f7d
md"Make the GMST more useful by converting to hours, minutes, seconds"

# ╔═╡ f0853444-f1e7-11ea-2e14-abd15e6a120f
utc = DateTime(2020, 09, 08, 0, 50, 0)

# ╔═╡ 1f4c39ec-eebb-11ea-1cde-dd6702594f14
jd = datetime2julian(utc)

# ╔═╡ c228cf20-f1e5-11ea-1383-2371227f31aa
MJD = jd - 2400000.5

# ╔═╡ b2a6ba50-f1e5-11ea-2d4c-2ff17843da0c
MJD0 = floor(MJD)

# ╔═╡ a2429802-f1e3-11ea-1f92-6921fe633bc4
tₑ = (MJD0 - 51544.5)/36525.0

# ╔═╡ a4616292-f1e5-11ea-3478-fb244e4d7152
ut = (MJD - MJD0)*24.0

# ╔═╡ 0c6546ae-f1e3-11ea-2283-b5c1e47ab9b0
gmst = 6.697374558 + 1.0027379093*ut + (8640184.812866 + (0.093104 - 0.0000062*tₑ)*tₑ)*tₑ/3600.0  # In hours

# ╔═╡ 17447826-f1e6-11ea-1b3e-2beed5f5ba5b
gmst_dec = gmst%24  # Decimal hours

# ╔═╡ 7d9e82da-eebf-11ea-2815-eda4e62beaef
begin
	GMST_H = convert(Int, floor(gmst_dec))
	GMST_M = convert(Int, floor((gmst_dec - GMST_H)*60))
	GMST_S = gmst_dec - GMST_H - GMST_M/60
	(GMST_H, GMST_M, GMST_S)
end

# ╔═╡ 2adf49de-eec0-11ea-3df8-ddf949436716
md" The website https://jukaukor.mbnet.fi/astronavigation_time.html gives the GMST for 2020 January 01d 12h as 

	GMST = (18, 42, 27.51)
"

# ╔═╡ Cell order:
# ╟─7f1320b2-eeba-11ea-235c-a3562e12e8e7
# ╟─6ee10096-eebb-11ea-237b-c7e669860811
# ╠═fd2f2740-eeba-11ea-1413-01381e6ee34e
# ╟─3042679e-eebb-11ea-2e67-75bef0086611
# ╠═1f4c39ec-eebb-11ea-1cde-dd6702594f14
# ╠═431e9a44-eebc-11ea-33ab-416a6ec03189
# ╠═c228cf20-f1e5-11ea-1383-2371227f31aa
# ╠═b2a6ba50-f1e5-11ea-2d4c-2ff17843da0c
# ╠═a4616292-f1e5-11ea-3478-fb244e4d7152
# ╠═a2429802-f1e3-11ea-1f92-6921fe633bc4
# ╠═0c6546ae-f1e3-11ea-2283-b5c1e47ab9b0
# ╠═17447826-f1e6-11ea-1b3e-2beed5f5ba5b
# ╟─d529d154-eebe-11ea-3dde-b5ac1c2c507f
# ╟─0e93a2d0-eebf-11ea-0f0d-7be1055d6f7d
# ╠═f0853444-f1e7-11ea-2e14-abd15e6a120f
# ╠═7d9e82da-eebf-11ea-2815-eda4e62beaef
# ╟─2adf49de-eec0-11ea-3df8-ddf949436716
