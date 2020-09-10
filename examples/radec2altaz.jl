### A Pluto.jl notebook ###
# v0.11.14

using Markdown
using InteractiveUtils

# ╔═╡ 611cc5f2-edf9-11ea-2b42-b38a547930c4
using StarCharts

# ╔═╡ c7ed2366-edf5-11ea-28d8-35dc55156fea
md"# StarCharts.jl"

# ╔═╡ deb83a0e-edf5-11ea-0c00-b960cf65608e
md"## This notebook shows how to convert equatorial J2000 (RA, DEC) coordinates to hortizontal coordinates (alt, az) using StarCharts.jl"

# ╔═╡ 28618678-f2bb-11ea-0839-57eccfc1824e
md"Activate the dev package environment"

# ╔═╡ 9f73b546-edf6-11ea-1b3c-d9eb73299d02
md"Define two helper functions to automatically convert degrees to radians for sin/cos calculations."

# ╔═╡ 886e0170-edf6-11ea-3c9e-6b1130a2e1a4
dsin(β) = sin(deg2rad(β))

# ╔═╡ 92386e8c-edf6-11ea-3790-631c7376ba6c
dcos(β) = cos(deg2rad(β))

# ╔═╡ 7b4a6906-f2b9-11ea-1a9b-3b5cff2a2dfe
md"StarCharts defines coordinate types for decimal degrees (DecimalDegrees), degrees-minutes-seconds (DMS), decimal hours (DecimalHours), and hours-minutes-seconds (HMS)"

# ╔═╡ cfd0045c-edf4-11ea-08e9-5509c91c7055
α, δ = 0, 0 # ra, dec - approx. Polaris

# ╔═╡ ddf4b394-edf4-11ea-3c65-b781a175e56a
ϕ, λ = DMS(38, 54, 17), DMS(-77, 00, 59)  # lat, lon - DC approx lon=-77 

# ╔═╡ Cell order:
# ╟─c7ed2366-edf5-11ea-28d8-35dc55156fea
# ╟─deb83a0e-edf5-11ea-0c00-b960cf65608e
# ╟─28618678-f2bb-11ea-0839-57eccfc1824e
# ╠═611cc5f2-edf9-11ea-2b42-b38a547930c4
# ╟─9f73b546-edf6-11ea-1b3c-d9eb73299d02
# ╠═886e0170-edf6-11ea-3c9e-6b1130a2e1a4
# ╠═92386e8c-edf6-11ea-3790-631c7376ba6c
# ╟─7b4a6906-f2b9-11ea-1a9b-3b5cff2a2dfe
# ╠═cfd0045c-edf4-11ea-08e9-5509c91c7055
# ╠═ddf4b394-edf4-11ea-3c65-b781a175e56a
