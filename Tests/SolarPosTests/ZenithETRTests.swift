import XCTest
@testable import SolarPos

class ZenithETRTests: XCTestCase {
    func rounded(_ value: Double) -> Double {
        return round(value * 100.0) / 100.0
    }

    // This is derived from 
    // Iqbal, M.  1983.  An Introduction to Solar Radiation.
    // Academic Press, NY.
    // Example 1.5.1
    func testFromIqbalExample151() {
        let hourAngle = 15.0
        let declination = -8.67
        // NOTE: Iqbal's Example 1.5.1 appears to have an error.
        // It declares that New York city's latitude is
        // 40°7'N == 40.12°N.
        // But its values for sin(latitude) and cos(latitude) correspond to a
        // latitude of 40.78°N, which is close to the value of
        // 40.755931°N reported by Apple Maps.
        // latitudelongitude.org reports 40°42'51.37''N.
        let latitude = 40.78

        let actual = ZenithETR(
            declination: declination, hourAngle: hourAngle,
            latitude: latitude)
        let expected = 51.35
        XCTAssertEqual(rounded(actual.zenith), expected)
        XCTAssertEqual(rounded(actual.elev), 90.0 - expected)
    }

    static var allTests = [
        ("testFromIqbalExample151", testFromIqbalExample151)
    ]
}
