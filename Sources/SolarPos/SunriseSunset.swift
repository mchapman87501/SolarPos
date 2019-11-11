// Calculates sunrise/sunset times, minutes from midnight:
import Foundation

private let minutesTimePerDay = 60.0 * 24.0
private let degreesPerDay = 360.0
private let minutesPerHalfDay = minutesTimePerDay / 2.0
// How many minutes does it take for earth to rotate one degree?
// That's minutes of time vs. minutes of rotation :)
private let minutesTimePerDegreeRotation = minutesTimePerDay / degreesPerDay

public struct SunriseSunset {
    public let sunsetHourAngle: Double // Sunset hour angle, degrees
    public let sunriseETR: Double  // Sunrise, minutes from midnight, top of atmosphere
    public let sunsetETR: Double   // Sunset, minutes from midnight, top of atmosphere

    /* Initialize given a panel location, a time, and geocentric and topocentric
     * sun angles computed for that time.
     */
    public init(
        location: Location, timespec: TimeSpec,
        solarPos: SolarPos) {
        let geoSunAngles = solarPos.geoSunAngles

        let declination = geoSunAngles.declination
        let latitude = location.latitude

        let ssha = SunriseSunset.calcSunsetHourAngle(
            latitude: latitude, declination: declination)

        let localNoon = SunriseSunset.calcSolarNoon(
            ts: timespec, location: location, solarPos: solarPos)

        let sunrise = SunriseSunset.calcSunriseETR(
            localNoon: localNoon, sunsetHourAngle: ssha)
        let sunset = SunriseSunset.calcSunsetETR(
            localNoon: localNoon, sunsetHourAngle: ssha)

        sunsetHourAngle = ssha
        sunriseETR = sunrise
        sunsetETR = sunset
    }

    // Sunset hour angle, degrees
    // Iqbal, M.  1983.  An Introduction to Solar Radiation.
    // Academic Press, NY., page 16
    // Corrected to account for astronomical refraction and solar disc diameter,
    // per https://en.wikipedia.org/wiki/Sunrise_equation
    static func calcSunsetHourAngle(latitude: Double, declination: Double) -> Double {
        let phi = rads(latitude)
        let drads = rads(declination)
        let alt = rads(-0.83) // altitude of center of solar disk

        let numer = sin(alt) - sin(phi) * sin(drads)
        let denom = cos(phi) * cos(drads)
        // TODO handle small denominator values, small phi, small d
        let cosHrAngle = numer / denom
        if cosHrAngle < -1.0 {
            return 180.0
        } else if cosHrAngle > 1.0 {
            return 0.0
        }
        let resultRad = acos(cosHrAngle)
        let result = degrees(resultRad)
        return result
    }

    static func calcSolarNoon(
        ts timeSpec: TimeSpec, location: Location, solarPos: SolarPos)
        -> Double {
        let eot = solarPos.equationOfTime
        // Offset by longitude gives time offset from prime meridian to
        // the nearest minute.  Adding back the gmt offset effectively finds the
        // offset of the location within its timezone.
        let gmtMinutes = Double(timeSpec.gmtOffset) * 60.0
        let solNoonLocal = SunriseSunset.calcLongitudeOffsetMinutes(
            longitude: location.longitude, eot: eot) + gmtMinutes

        let result = muModulo(solNoonLocal, radix: minutesTimePerDay)
        return result
    }

    static func calcLongitudeOffsetMinutes(longitude: Double, eot: Double) -> Double {
        return minutesPerHalfDay - (longitude * minutesTimePerDegreeRotation) - eot
    }

    static func calcSunriseETR(localNoon: Double, sunsetHourAngle: Double) -> Double {
        // Presumably these bounds checks are to handle locations such as
        // north of the arctic circle, where for some times of the year the
        // sun never rises (or sets).
        if sunsetHourAngle < 1.0 {
            // Why 2999.0 (from the nrel code) -- 2999.0 minutes is a bit more 
            // than 2 days?  24 hrs * 60 minutes/hr = 1440 minutes/day
            return 2999.0
        } else if sunsetHourAngle >= 179.0 {
            return -2999.0
        }
        return localNoon - minutesTimePerDegreeRotation * sunsetHourAngle
    }

    static func calcSunsetETR(localNoon: Double, sunsetHourAngle: Double) -> Double {
        if sunsetHourAngle < 1.0 {
            return -2999.0
        } else if sunsetHourAngle >= 179.0 {
            return 2999.0
        }
        return localNoon + minutesTimePerDegreeRotation * sunsetHourAngle
    }
}
