### A Pluto.jl notebook ###
# v0.12.0

using Markdown
using InteractiveUtils

# ╔═╡ 09356c9e-01aa-11eb-34f2-e1d02c7504b2
begin
	using CSV
	using DataFrames
	using GMT
	using StarCharts
	using TimeZones
end

# ╔═╡ febbe432-01a9-11eb-01a6-cd25506707dc
md"# Example starchart"

# ╔═╡ 298ad6c8-01aa-11eb-3379-87f169f1e56c
simbad_header = ["#", "Identifier", "Type", "CoordString", "U", "B", "V", "R", "I", "SpType", "Bib", "Note"]

# ╔═╡ 36256a42-01aa-11eb-074a-77ec6dd4e2e7
data = DataFrame(CSV.read("/home/michael/dev/StarCharts/data/objects_vmag6.txt", delim="|", skipto=10, header=simbad_header, footerskip=2))

# ╔═╡ d9e2f672-01aa-11eb-3f55-31f5d6de89f9
raw_rows = size(data)[1]

# ╔═╡ e38fdd34-01aa-11eb-01b9-e76dc101e90a
dropmissing!(data, :CoordString)

# ╔═╡ 474cccec-01ab-11eb-29bd-f507fcb167d8
filter!(row -> strip(row.CoordString) != "No Coord.", data)

# ╔═╡ 5a76b724-01ab-11eb-0d63-3378bbb90137
begin
	replace!(data.U, "     ~" => "99.999")
	replace!(data.B, "     ~" => "99.999")
	replace!(data.V, "     ~" => "99.999")
	replace!(data.R, "     ~" => "99.999")
	replace!(data.I, "     ~" => "99.999")

	data.U = (typeof(data.U[1]) == String) ? parse.(Float64, data.U) : data.U
	data.B = (typeof(data.B[1]) == String) ? parse.(Float64, data.B) : data.B
	data.V = (typeof(data.V[1]) == String) ? parse.(Float64, data.V) : data.V
	data.R = (typeof(data.R[1]) == String) ? parse.(Float64, data.R) : data.R
	data.I = (typeof(data.I[1]) == String) ? parse.(Float64, data.I) : data.I
end

# ╔═╡ 7aa6b04e-01ab-11eb-24fb-dddb51fc6e50
tz_time = ZonedDateTime(2020, 09, 23, 05, 30, 0, localzone())

# ╔═╡ 061e297e-01af-11eb-12ff-07c31c6ef6dd
lat, lon = DMS(38, 54, 17), DMS(-77, 00, 59)

# ╔═╡ 944b9dd4-01ab-11eb-1246-d3d786b5b429
begin 
	data.RA = [(0, 0, 0.0) for i = 1:size(data)[1]]
	data.DEC = [(0, 0, 0.0) for i = 1:size(data)[1]]
	data.ALT = [0.0 for i = 1:size(data)[1]]
	data.AZ = [0.0 for i = 1:size(data)[1]]
end

# ╔═╡ a2979e10-01ab-11eb-1d2a-0703120821f1
for i = 1:size(data)[1]
    valstrings = split(data["CoordString"][i], " ")
    data.RA[i] = (parse(Int, valstrings[1]), parse(Int, valstrings[2]), parse(Float64, valstrings[3]))
    data.DEC[i] = (parse(Int, valstrings[4]), parse(Int, valstrings[5]), parse(Float64, valstrings[6]))
    alti, azi = equatorial2horizontal(HMS(data.RA[i]), DMS(data.DEC[i]), lat, lon, tz_time)
    data.ALT[i], data.AZ[i] = alti.D, azi.D
end

# ╔═╡ d946d2aa-01ab-11eb-2197-739f606b361c
data.ZD = 90 .- data.ALT

# ╔═╡ 52eded0c-01af-11eb-280d-c5b3e19cb2ec
maximum(data.ALT) - minimum(data.ALT)

# ╔═╡ 6b5567a8-01af-11eb-1498-c1c17654f211
maximum(data.AZ) - minimum(data.AZ)

# ╔═╡ e23086a4-01ab-11eb-312e-278e4bb11f18
visible = data[(0 .< data.ZD .< 90), :]

# ╔═╡ e94dbdda-01ab-11eb-00ec-49371bce4d51
bright = visible[(visible.V .≤ 2), :]

# ╔═╡ 52d82e3e-01ac-11eb-27db-b32b9c24c7b3
minimum(bright.ZD), maximum(bright.ZD)

# ╔═╡ c8b7862c-01ac-11eb-3102-677aea23a732
orion = data[occursin.("Ori", data.Identifier) .& (data.V .< 4), :]

# ╔═╡ 275a259a-01ad-11eb-392a-3f0070a56768
orion[(strip.(orion.Identifier) .== "* alf Ori"), 13:end]  # Betelgeuse - Astronav value = (53d, 26m, 28.65902s)

# ╔═╡ 0017e4aa-01ac-11eb-2ff1-132bb3b78222
θ = 0:0.05:2π+0.5

# ╔═╡ 09a23eb4-01ac-11eb-0542-49f783350333
r = [90 for i=1:length(θ)]

# ╔═╡ 612219de-0245-11eb-3693-859972651ddb
coast(region=(-30,30,60,72), proj=(name=:Stereographic, center=[0,90], paralles=60),
      frame=:a10g, res=:low, area=250, land=:royalblue, water=:seashell,
      figscale="1:30000000", show=1)

# ╔═╡ Cell order:
# ╟─febbe432-01a9-11eb-01a6-cd25506707dc
# ╠═09356c9e-01aa-11eb-34f2-e1d02c7504b2
# ╠═298ad6c8-01aa-11eb-3379-87f169f1e56c
# ╠═36256a42-01aa-11eb-074a-77ec6dd4e2e7
# ╠═d9e2f672-01aa-11eb-3f55-31f5d6de89f9
# ╠═e38fdd34-01aa-11eb-01b9-e76dc101e90a
# ╠═474cccec-01ab-11eb-29bd-f507fcb167d8
# ╠═5a76b724-01ab-11eb-0d63-3378bbb90137
# ╠═7aa6b04e-01ab-11eb-24fb-dddb51fc6e50
# ╠═061e297e-01af-11eb-12ff-07c31c6ef6dd
# ╠═944b9dd4-01ab-11eb-1246-d3d786b5b429
# ╠═a2979e10-01ab-11eb-1d2a-0703120821f1
# ╠═d946d2aa-01ab-11eb-2197-739f606b361c
# ╠═52eded0c-01af-11eb-280d-c5b3e19cb2ec
# ╠═6b5567a8-01af-11eb-1498-c1c17654f211
# ╠═e23086a4-01ab-11eb-312e-278e4bb11f18
# ╠═e94dbdda-01ab-11eb-00ec-49371bce4d51
# ╠═52d82e3e-01ac-11eb-27db-b32b9c24c7b3
# ╠═c8b7862c-01ac-11eb-3102-677aea23a732
# ╠═275a259a-01ad-11eb-392a-3f0070a56768
# ╠═0017e4aa-01ac-11eb-2ff1-132bb3b78222
# ╠═09a23eb4-01ac-11eb-0542-49f783350333
# ╠═612219de-0245-11eb-3693-859972651ddb
