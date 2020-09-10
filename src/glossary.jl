#=

    This file creates a glossary of terms that can be used to further
    explain the variables in this moduule.

=#


"""
glossary()

Shows a glossary of terms and expressions used in this package"
"""
function glossary()
    println("Find a way to pretty print this.")
    println("Also, a custom type might work for better printing")
    gloss = Dict("UTC" => "Universal Coordinated Time - International reference time",
                 "TAI" => "International Atomic Time - Standard given by atomic clocks",
                 "GMST" => "Greenwich Mean Sideral Time")
    println(gloss)
end

#= 

List of terms for glossary:
    local sideral time
    hour angle
=#