import XCTest
@testable import SolarPos

class OrientationTests: XCTestCase {
    func testInit() {
        let tilt = 12.5
        let azimuth = 37.5

        let actual = Orientation(tilt: tilt, azimuth: azimuth)
        XCTAssertEqual(actual.tilt, tilt)
        XCTAssertEqual(actual.azimuth, azimuth)
    }

    static var allTests = [
        ("testInit", testInit)
    ]
}
