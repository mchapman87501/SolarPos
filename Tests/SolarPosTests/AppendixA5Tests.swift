import XCTest
@testable import SolarPos

class AppendixA5Tests: XCTestCase {
    typealias HPC = HelioPositionCalc
    typealias EPTRec = HPC.EPTRec
    
    // From SolarPositionAlgorithmForSolarRadiationApplications, Example A.5
    private func getTimeSpec() -> TimeSpec {
        let lonDegrees = -105.1786
        // Should gmtOffset be rounded, or truncated?
        let gmtOffset = Int((lonDegrees / 360.0) * 24.0)
        return TimeSpec(
            year: 2003, month: 10, day: 17, 
            hour: 12, minute: 30, second: 30, 
            gmtOffset: gmtOffset, 
            deltaT: 67.0)
    }
    
    private func getJulian() throws -> JulianDay {
        return try JulianDay(timespec: getTimeSpec())
    }
    
    private func getJME() throws -> Double {
        return try getJulian().jme
    }
    
    func testJulian() throws {
        let julian = try getJulian()
        XCTAssertEqual(julian.julianDay, 2452930.312847, accuracy:1.0e-6)
        XCTAssertEqual(julian.jce, 0.037928, accuracy:1.0e-6)
    }
    
    private func eq(
        _ actual: Double, _ expected: Double, epsilon: Double = 1.0e-5, _ msg: String?)
    {
        // TODO handle expected == 0.0
        let fractError = abs((actual - expected) / expected)
        let m = msg ?? ""
        XCTAssertTrue(fractError <= epsilon, "\(m): expected \(expected), actual \(actual), error \(fractError)")
    }
    
    private func assertArrayEq(actual: [Double], expected: [Double], msg: String) {
        XCTAssertEqual(actual.count, expected.count, "\(msg)Length")
        let maxFractErr = 1.0e-6
        let closeEnough = zip(actual, expected).map {
            return abs(($0 - $1) / $1) <= maxFractErr
        }
        let allPassed = closeEnough.reduce(true) { $0 && $1 }
        XCTAssertTrue(allPassed, msg)
    }
    
    private func getLValues(jme: Double, paramSets: [[EPTRec]]) -> [Double] {
        return paramSets.map { HelioPositionCalc.getLValue(jme, $0) }
    }
    
    private func assertLValuesEq(
        jme: Double, paramSets: [[EPTRec]], expected: [Double], msg: String = "")
    {
        let actual = getLValues(jme: jme, paramSets: paramSets)
        assertArrayEq(actual: actual, expected: expected, msg: msg)
    }
    
    func testLTerms() throws {
        assertLValuesEq(
            jme: try getJME(),
            paramSets: [HPC.l0, HPC.l1, HPC.l2, HPC.l3, HPC.l4, HPC.l5],
            expected: [172067561.526586, 628332010650.051147, 61368.682493, 
                       -26.902819, -121.279536, -0.999999],
            msg: "L[n]"
        )
    }
        
    func testBTerms() throws {
        assertLValuesEq(
            jme: try getJME(),
            paramSets: [HPC.b0, HPC.b1], 
            expected: [-176.502688, 3.067582], 
            msg: "B[n]"
        )
    }

    func testRTerms() throws {
        assertLValuesEq(
            jme: try getJME(), 
            paramSets: [HPC.r0, HPC.r1, HPC.r2, HPC.r3, HPC.r4],
            expected: [99653849.037796, 100378.567146, -1140.953507, -141.115419, 
                       1.232361],
            msg: "R[n]"
        )
    }
     
    func testLongitude() throws {
        let actual = HPC.longitude(jme: try getJME())
        XCTAssertEqual(actual, 24.0182616917, accuracy: 1.0e-5, "Longitude")
    }
    
    func testLatitude() throws {
        let actual = HPC.latitude(jme: try getJME())
        XCTAssertEqual(actual, -0.0001011219, accuracy: 1.0e-6, "Latitude")
    }
    
    func testEarthRadiusVector() throws {
        let actual = HPC.earthRadiusVector(jme: try getJME())
        XCTAssertEqual(actual, 0.9965422974, accuracy: 1.0e-6, "Earth Radius Vector")
    }
    
    func testNutations() throws {
        let julian = try getJulian()
        
        XCTAssertEqual(TableA_4_3.coeffs.count, 63)
        let nutation = Nutations(jce: julian.jce)
        let eNutationInLongitude = -0.00399840
        eq(nutation.longitude, eNutationInLongitude, "Nutation in longitude")
        let eNutationInObliquity = 0.00166657
        eq(nutation.obliquity, eNutationInObliquity, "Nutation in obliquity")
    }
    
    func testTrueObliquity() throws {
        let julian = try getJulian()
        let nutations = Nutations(jce: julian.jce)
        let obliq = ObliquityOfEcliptic(jme: julian.jme, nutations: nutations)
        let eTrueObliq = 23.440465
        eq(obliq.trueObliq, eTrueObliq, "True Obliquity")
        
    }
    
    func testIrradianceConditions() throws {
        // Again, all expected values are from Solar Position Algorithm 
        // For Solar Radiation Applications, NREL 2008, Appendix A.5.
        let timespec = getTimeSpec()
        let location = Location(lat: 39.742476, lon: -105.1785, elev: 1830.14)
        let orientation = Orientation(tilt:30.0, azimuth: -10.0)
        let pressure = 820.0 // mbar
        let temperature = 11.0 // Celsius
        
        let solarPos = try SolarPos(
            location: location, timespec: timespec,
            temperature: temperature, pressure: pressure
        )
        
        let eGeoSunRightAscension = 202.22741
        eq(solarPos.geoSunAngles.rightAscension, eGeoSunRightAscension,
           "Geocentric Sun Right Ascension")
        let eGeoSunDeclination = -9.31434
        eq(solarPos.geoSunAngles.declination, eGeoSunDeclination,
           "Geocentric Sun Declination")

        let eObserverLocalHourAngle = 11.105900
        eq(solarPos.topoAngles.observerLocalHourAngle,
           eObserverLocalHourAngle, "Observer Local Hour Angle")

        let eTopoLocalHourAngle = 11.10629
        eq(solarPos.topoAngles.localHourAngle, eTopoLocalHourAngle,
           "Topocentric Local Hour Angle")
        
        let eTopoSunRightAscension = 202.22704
        eq(solarPos.topoAngles.rightAscension, eTopoSunRightAscension,
           "Topocentric Sun Right Ascension")

        let eTopoSunDeclination = -9.316179
        eq(solarPos.topoAngles.declination, eTopoSunDeclination,
           "Topocentric Sun Declination")
        
        let eTopoZenithAngle = 50.11162
        eq(solarPos.topoAngles.zenithAngle, eTopoZenithAngle,
           "Topocentric Zenith Angle")

        let eTopoAzimuthAngle = 194.34024
        eq(solarPos.topoAngles.azimuthAngle, eTopoAzimuthAngle,
           "Topocentric Azimuth Angle")

        // TODO Sun's mean longitude, equation of time, transit, sunrise, sunset
    }
    
    static var allTests = [
        ("testLTerms", testLTerms),
        ("testBTerms", testBTerms),
        ("testRTerms", testRTerms),
        ("testLongitude", testLongitude),
        ("testLatitude", testLatitude),
        ("testNutations", testNutations),
        ("testEarthRadiusVector", testEarthRadiusVector)
    ]
}
