import Foundation

public func apparentSiderealTime(
    jd jDay: Double, jc jCentury: Double,
    nl nutationInLongitude: Double, trueObliq: Double) -> Double {
    let v0Unbounded = (
        280.46061837 +
        360.98564736629 * (jDay - JulianDay.startOfEpoch) +
        0.000387933 * (jCentury * jCentury) -
        ((jCentury * jCentury * jCentury) / 38710000))

    // swiftlint:disable identifier_name
    let v0 = oneRev(v0Unbounded)
    return v0 + nutationInLongitude * cos(rads(trueObliq))
}
