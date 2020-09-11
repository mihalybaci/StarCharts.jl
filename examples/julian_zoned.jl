using TimeZones

# Julian conversions
const JULIANEPOCH = ZonedDateTime(-4713, 11, 24, 12, TimeZone("UTC"))

"""
    julian2datetime(julian_days) -> DateTime

Take the number of Julian calendar days since epoch `-4713-11-24T12:00:00` and return the
corresponding `DateTime`.
"""
function julian2datetime(f)
    rata = JULIANEPOCH + round(Int64, Int64(86400000) * f)
    return DateTime(UTM(rata))
end

"""
    datetime2julian(dt::DateTime) -> Float64

Take the given `DateTime` and return the number of Julian calendar days since the julian
epoch `-4713-11-24T12:00:00` as a [`Float64`](@ref).
"""
datetime2julian(dt::ZonedDateTime) = (vaue(dt) - JULIANEPOCH) / 86400000.0
