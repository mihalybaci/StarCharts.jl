### A Pluto.jl notebook ###
# v0.11.13

using Markdown
using InteractiveUtils

# ╔═╡ fd2f2740-eeba-11ea-1413-01381e6ee34e
using Dates  # Import the Dates package

# ╔═╡ 7f1320b2-eeba-11ea-235c-a3562e12e8e7
md"## Calculate the GMST"

# ╔═╡ 6ee10096-eebb-11ea-237b-c7e669860811
md"### Refs: Capitaine et al. 2003b, Capitaine et al. 2003c"

# ╔═╡ a9e835be-eeba-11ea-0959-7973a0e64de2
md"**As an example calcuate the GMST for the date 2020 Jaunary 1 12:00:00 UTC.**"

# ╔═╡ 286aca5c-f0ff-11ea-259a-7b42848607b2
md"Equation 43 from Capitaine et al. 2003c requires knowing the UT1 and TT, both in units of centuries post-J2000."

# ╔═╡ 072ee968-eebb-11ea-18db-e328ff722430
#utc = DateTime(2020, 01,01, 12, 0, 0)

# ╔═╡ 6a83b4c8-f1e8-11ea-2296-c9f35c8af573
utc = DateTime(2020, 09, 08, 0, 50, 0)

# ╔═╡ 3042679e-eebb-11ea-2e67-75bef0086611
md" Convert UTC to Julian date"

# ╔═╡ 1f4c39ec-eebb-11ea-1cde-dd6702594f14
jd = datetime2julian(utc)

# ╔═╡ 6101d004-eebb-11ea-234f-2bea22f60da4
md"The ERA from Capitaine 2003b requires the UT1 after J2000. IERS Bulletin A gives:
	
	UT1 = UTC + DUT1
	DUT1 = -0.2

with DUT1 in seconds. Convert DUT1 to days before subtracting from UTC JD."

# ╔═╡ 431e9a44-eebc-11ea-33ab-416a6ec03189
seconds_per_day = 24*3600.0

# ╔═╡ bbc9f124-eebb-11ea-0127-3b1dcae1d0e6
DUT1 = -0.2

# ╔═╡ f724e058-eebb-11ea-1951-c9e5adcd9a1e
md"Convert DUT1 from seconds to days before conversion"

# ╔═╡ 3bd2061a-f1e9-11ea-09c2-87f3610e60f7
md"UT1 in seconds."

# ╔═╡ 23359612-f1e9-11ea-010d-f3109b43d584
ut1 = hour(utc)*3600.0 + minute(utc)*60.0 + second(utc) + DUT1

# ╔═╡ eb2a6d4a-eebb-11ea-120a-95d2b6608f43
ut1_jd = jd + DUT1/seconds_per_day  # days

# ╔═╡ c4aca80c-eebd-11ea-187f-b5aea104f590
md" First convert the Julian Date 2000 January 1d 12h to TT."

# ╔═╡ 8d006476-eebc-11ea-3936-29e14513cc91
md"Next convert UT1 to Tᵤ by subtracting the J2000 JD (Equation 2, Capitaine 2003b)"

# ╔═╡ 88691c50-eebc-11ea-26a7-05397a717bb3
J2000 = 2451545.0

# ╔═╡ 773e828a-eebc-11ea-0db0-07af06ff8507
tᵤ = (ut1_jd - J2000)/36525.0

# ╔═╡ 53cb9be8-eebd-11ea-3835-6308f12c0c41
md"From IERS Bulletin A, UTC and TT are related via TAI and the equations: 
	
	TAI(UTC) = UTC + 37.0[s]
	TT(TAI) = TAI + 32.184[s]

so 
	
	TT = UTC + 37.0[s] + 32.184[s] = UTC + 67.184

which again need the constants converted from seconds to days to Julian centuries post-J2000.
"

# ╔═╡ 369de20a-eebe-11ea-1852-97a25adc4736
J2000_TT = J2000 + 67.184/seconds_per_day

# ╔═╡ 522b4936-eebe-11ea-0586-47f6c54dfe14
md"The UTC of the date being calculated becomes:"

# ╔═╡ 6bc51cdc-eebe-11ea-32c7-29c47c09b2f3
TT = jd + 67.184/seconds_per_day

# ╔═╡ a3061638-eebe-11ea-17ee-e36a3a345e3f
md"t is TT - J2000 TT in Julian centuries."

# ╔═╡ 7be2364a-eebe-11ea-01b2-412ce37ec943
t = (TT - J2000_TT)/36525.0

# ╔═╡ 55ca22c6-eec1-11ea-0d16-7f287941b44b
md"Value of `t` makes sense because 2020 January 1d 12h is 20 years = 0.2 Julian centuries after 2000 January 1d 12h."

# ╔═╡ d529d154-eebe-11ea-3dde-b5ac1c2c507f
md"**Now calculate the GMST in arcseconds**"

# ╔═╡ f7f94a60-f0fe-11ea-202d-f98cb5e532de
GMST_P03 = ut1 + 24110.5493771 + 8640184.79447825*tᵤ + 307.4771013*(t-tᵤ) + 0.092772110*t^2 - 0.0000002926*t^3 - 0.00000199708*t^4 - 0.000000002454*t^5

# ╔═╡ 0e93a2d0-eebf-11ea-0f0d-7be1055d6f7d
md"Make the GMST more useful by converting to hours, minutes, seconds"

# ╔═╡ 6a35f9e4-eebf-11ea-283b-c30f32a94a64
GMST_decimal_hours = (GMST_P03/3600)%24

# ╔═╡ 7d9e82da-eebf-11ea-2815-eda4e62beaef
begin
	GMST_H = floor(GMST_decimal_hours)
	GMST_M = floor((GMST_decimal_hours - GMST_H)*60)
	GMST_S = GMST_decimal_hours - GMST_H - GMST_M/60
	(GMST_H, GMST_M, GMST_S)
end

# ╔═╡ 2adf49de-eec0-11ea-3df8-ddf949436716
md" The website https://jukaukor.mbnet.fi/astronavigation_time.html gives the GMST for 2020 January 01d 12h as 

	GMST = (18, 42, 27.51)

They use a different, older calculation, but shouldn't the values be similar?"

# ╔═╡ Cell order:
# ╟─7f1320b2-eeba-11ea-235c-a3562e12e8e7
# ╟─6ee10096-eebb-11ea-237b-c7e669860811
# ╟─a9e835be-eeba-11ea-0959-7973a0e64de2
# ╟─286aca5c-f0ff-11ea-259a-7b42848607b2
# ╠═fd2f2740-eeba-11ea-1413-01381e6ee34e
# ╠═072ee968-eebb-11ea-18db-e328ff722430
# ╠═6a83b4c8-f1e8-11ea-2296-c9f35c8af573
# ╟─3042679e-eebb-11ea-2e67-75bef0086611
# ╠═1f4c39ec-eebb-11ea-1cde-dd6702594f14
# ╟─6101d004-eebb-11ea-234f-2bea22f60da4
# ╠═431e9a44-eebc-11ea-33ab-416a6ec03189
# ╠═bbc9f124-eebb-11ea-0127-3b1dcae1d0e6
# ╟─f724e058-eebb-11ea-1951-c9e5adcd9a1e
# ╠═3bd2061a-f1e9-11ea-09c2-87f3610e60f7
# ╠═23359612-f1e9-11ea-010d-f3109b43d584
# ╠═eb2a6d4a-eebb-11ea-120a-95d2b6608f43
# ╟─c4aca80c-eebd-11ea-187f-b5aea104f590
# ╟─8d006476-eebc-11ea-3936-29e14513cc91
# ╠═88691c50-eebc-11ea-26a7-05397a717bb3
# ╠═773e828a-eebc-11ea-0db0-07af06ff8507
# ╟─53cb9be8-eebd-11ea-3835-6308f12c0c41
# ╠═369de20a-eebe-11ea-1852-97a25adc4736
# ╟─522b4936-eebe-11ea-0586-47f6c54dfe14
# ╠═6bc51cdc-eebe-11ea-32c7-29c47c09b2f3
# ╟─a3061638-eebe-11ea-17ee-e36a3a345e3f
# ╠═7be2364a-eebe-11ea-01b2-412ce37ec943
# ╟─55ca22c6-eec1-11ea-0d16-7f287941b44b
# ╟─d529d154-eebe-11ea-3dde-b5ac1c2c507f
# ╠═f7f94a60-f0fe-11ea-202d-f98cb5e532de
# ╟─0e93a2d0-eebf-11ea-0f0d-7be1055d6f7d
# ╠═6a35f9e4-eebf-11ea-283b-c30f32a94a64
# ╠═7d9e82da-eebf-11ea-2815-eda4e62beaef
# ╟─2adf49de-eec0-11ea-3df8-ddf949436716
