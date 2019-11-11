import Foundation

public func apparentSiderealTime(
    jd: Double, jc: Double, nl nutationInLongitude: Double, trueObliq: Double) -> Double 
{
    let v0Unbounded = (
        280.46061837 + 
        360.98564736629 * (jd - JulianDay.startOfEpoch) + 
        0.000387933 * (jc * jc) - 
        ((jc * jc * jc) / 38710000))
    let v0 = oneRev(v0Unbounded)
    return v0 + nutationInLongitude * cos(rads(trueObliq))
}
