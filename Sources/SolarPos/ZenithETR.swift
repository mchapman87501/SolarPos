import Foundation

// ETR solar zenith angle (ETR == "Extraterrestrial" or "top of atmosphere")
// Iqbal, M.  1983.  An Introduction to Solar Radiation.
// Academic Press, NY., page 15, Equation 1.5.1
public struct ZenithETR {
    // Zenith angle
    public let zenith: Double
    // Its 'complement' - elevation angle
    public let elev: Double

    public init(declination: Double, hourAngle: Double, latitude: Double) {
        // swiftlint:disable identifier_name
        let cz: Double = {
            let sd = sin(rads(declination))
            let sl = sin(rads(latitude))
            let cd = cos(rads(declination))
            let cl = cos(rads(latitude))
            let ch = cos(rads(hourAngle))

            let result = sd * sl + cd * cl * ch

            if abs(result) > 1.0 {
                return (result >= 0) ? 1.0 : -1.0
            }
            return result
        }()

        // Limit degrees below the horizon to 9 [+90 -> 99]
        let unclipped = degrees(acos(cz))
        zenith = min(unclipped, 99.0)
        elev = 90.0 - zenith
    }
}
