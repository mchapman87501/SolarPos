// Calculates geocentric and topocentric sun angles for a location on earth at
// a given date/time
import Foundation

public struct SolarPos {
    // Cache the inputs from which the angles were calculated
    let timespec: TimeSpec
    let location: Location
    let temperature: Double
    let pressure: Double

    // Calculated values:
    public let geoSunAngles: GeocentricSunAngles
    public let topoAngles: TopocentricAngles
    public let equationOfTime: Double

    /**
     * Calculate geocentric and topocentric angles for a given date/time and
     * location on earth.
     *
     * - parameters:
     *   - timespec: the date/time for which to calculate angles
     *   - location: observer geographical latitude, longitude, and elevation
     *     (above mean sea level?), degrees and meters
     *   - temperature: annual average local temperatures, degrees Celsius
     *   - pressure: annual average local pressure, millibars
     */
    public init(
        location: Location, timespec: TimeSpec,
        temperature: Double, pressure: Double) throws {
        let julian = try JulianDay(timespec: timespec)

        let helioPos = HelioPosition(jme: julian.jme)
        let geoPos = GeocentricPosition(helioPos)
        let nutation = Nutations(jce: julian.jce)
        let obliq = ObliquityOfEcliptic(jme: julian.jme, nutations: nutation)
        let apparentSunLon = apparentSunLongitude(
            lon: geoPos.longitude, nl: nutation.longitude,
            r: helioPos.radius)
        let ast = apparentSiderealTime(
            jd: julian.julianDay, jc: julian.jc, nl: nutation.longitude,
            trueObliq: obliq.trueObliq)
        let geoSunAngles = GeocentricSunAngles(
            apparentSunLongitude: apparentSunLon,
            meanObliquity: obliq.trueObliq,
            geocentricLatitude: geoPos.latitude)
        let topoAngles = TopocentricAngles(
            apparentSiderealTime: ast,
            observerLocation: location, geoSunAngles: geoSunAngles, r: helioPos.radius,
            temperature: temperature, pressure: pressure)

        let equationOfTime = SolarPos.getEquationOfTime(
            jme: julian.jme,
            geoRightAscension: geoSunAngles.rightAscension,
            nutationInLongitude: nutation.longitude,
            obliquityOfEcliptic: obliq.trueObliq)

        self.timespec = timespec
        self.location = location
        self.temperature = temperature
        self.pressure = pressure

        self.geoSunAngles = geoSunAngles
        self.topoAngles = topoAngles
        self.equationOfTime = equationOfTime
    }

    // swiftlint:disable identifier_name

    // This is from Appendix A.1 of "Solar Position Algorithm for Solar Radiation Applications".
    // It requires angles in degrees and returns eq of time in minutes.
    // Perhaps this belongs in TopocentricAngles?
    private static func getEquationOfTime(
        jme: Double,
        geoRightAscension alpha: Double,
        nutationInLongitude: Double,
        obliquityOfEcliptic: Double) -> Double {
        // Per Meeus, m (aka L0) should be modulated to 360.0 degrees.
        let m = oneRev(
            poly(coeffs: [280.4664567, 360007.6982779, 0.03032028,
                          1.0/49931.0, -1.0/15300.0, -1/2000000.0],
                 x: jme))

        // Calculate E in degrees of longitude:
        let nut = nutationInLongitude * cos(rads(obliquityOfEcliptic))
        let e = m - 0.0057183 - alpha + nut
        // Convert degrees in longitude to minutes of time:
        // 360 degrees = 24 * 60 minutes: 1 degree = 1440/360 == 4 minutes.
        // See also the conversions in SunriseSunset.
        let eMinutes = 4.0 * e

        // Modulate vs. 24 hrs (1440 minutes).  From Meeus, abs(E) should always
        // be < 20 minutes.

        return eMinutes
    }
}
