import Foundation

public struct GeocentricSunAngles {
    public let rightAscension: Double
    public let declination: Double
    
    public init(apparentSunLongitude lambda: Double, 
         meanObliquity epsilon: Double, 
         geocentricLatitude beta: Double)
    {
        rightAscension = GeocentricSunAngles.getRightAscension(
            apparentSunLongitude: lambda,
            meanObliquity: epsilon,
            geocentricLatitude: beta)
        declination = GeocentricSunAngles.getDeclination(
            apparentSunLongitude: lambda,
            meanObliquity: epsilon,
            geocentricLatitude: beta)
    }

    private static func getRightAscension(
        apparentSunLongitude lambda: Double, 
        meanObliquity epsilon: Double, 
        geocentricLatitude beta: Double) -> Double
    {
        /*  Contrast this with
            Michalsky, J.  1988.  The Astronomical Almanac's algorithm for
            approximate solar position (1950-2050).  Solar Energy 40 (3),
            pp. 227-235, which omits the numerator's "-tan(beta) * sin(epsilon)" */
        let rlambda = rads(lambda)
        let repsilon = rads(epsilon)
        let rbeta = rads(beta)
        
        let n1 = sin(rlambda) * cos(repsilon)
        let n2 = tan(rbeta) * sin(repsilon)
        let numerator = n1 - n2
        let denominator = cos(rlambda)
        // 3.9.2. Calculate alpha in degrees using Equation 12,
        // then limit it to the range from 0° to 360° using the technique described in step 3.2.6.
        let result = oneRev(degrees(atan2(numerator, denominator)))
        return result
    }
    
    private static func getDeclination(
        apparentSunLongitude lambda: Double, 
        meanObliquity epsilon: Double, 
        geocentricLatitude beta: Double) -> Double
    {
        let rbeta = rads(beta)
        let repsilon = rads(epsilon)
        let rlambda = rads(lambda)
        let result = degrees(asin(sin(rbeta) * cos(repsilon) + 
                                  cos(rbeta) * sin(repsilon) * sin(rlambda)))
        // Declination is -180.0..180.0, not 0..360.0
        return (result <= 180.0) ? result : result - 360.0
    }
    
}
