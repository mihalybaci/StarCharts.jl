#=

    This file is intended to give an idea of how StarCharts.jl 
    *SHOULD* work in the future, *NOT* how it currently works.
    The goal is to focus functions to perform these tasks

=#

chart = StarChart(:blank)  # Loads a blank chart
chart = StarChart(lat, lon)  # Gives a pre-made chart for current time 
chart = StartChart(lat, lon, datetime)  # Gives a pre-made chart for datetime

show(chart)  # Show the current chart
update!(chart, object)  # An an object or list to chart
add(object_list)  # Add object list to pull from
info(object_name)  # Print information, e.g. for Sirius (position, other names, max altitude)
clear!(chart)  # Removes all objects from chart