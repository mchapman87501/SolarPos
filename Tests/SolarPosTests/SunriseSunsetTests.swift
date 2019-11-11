import Foundation
import XCTest
@testable import SolarPos

class SunriseSunsetTests: XCTestCase {
    struct ExpectedResult {
        let timespec: TimeSpec
        let sunriseETR: Int // minutes after midnight
        let sunsetETR: Int  // minutes after midnight

        init(_ year: Int, _ month: UInt, _ day: UInt,
             _ sriseHr: Int, _ sriseMinute: Int,
             _ ssetHr: Int, _ ssetMinute: Int, gmtOffset: Int = -7) {
            timespec = TimeSpec(year: year, month: month, day: day,
                                hour: 12, minute: 0, second: 0,
                                gmtOffset: gmtOffset)
            sunriseETR = (sriseHr * 60) + sriseMinute
            sunsetETR = (ssetHr * 60) + ssetMinute
        }

        func description() -> String {
            let spec = timespec
            let tsStr = "timespec(\(spec.year), \(spec.month), \(spec.day)"
            return "Expected(\(tsStr), rise \(sunriseETR), set \(sunsetETR))"
        }
    }

    // Test against some reference sunrise/sunset times from
    // (unnamed online sources) for U.S. airport KSAF
    func testTimesForKSAF() throws {
        let subTests = [
            ExpectedResult(2018, 2, 24, 6, 40, 17, 55),
            ExpectedResult(2004, 7, 1, 5, 53, 20, 24, gmtOffset: -6),
            ExpectedResult(2017, 7, 1, 5, 53, 20, 24, gmtOffset: -6)
        ]

        let location = Location(lat: 35.6171111, lon: -106.0894167, elev: 1935.1)

        let temperature = 21.0 // Darned if I know
        let mbarsPerInHg = 1000.0 / 29.53
        let pressure = 29.96 * mbarsPerInHg

        for testCase in subTests {
            let angles = try SolarPos(
                location: location, timespec: testCase.timespec,
                temperature: temperature, pressure: pressure
            )
            let actual = SunriseSunset(
                location: location, timespec: testCase.timespec,
                solarPos: angles
            )
            XCTAssertEqual(testCase.sunriseETR, Int(0.5 + actual.sunriseETR),
                           testCase.description())
            XCTAssertEqual(testCase.sunsetETR, Int(0.5 + actual.sunsetETR),
                           testCase.description())
        }
    }

    static var allTests = [
        ("testTimesForKSAF", testTimesForKSAF)
    ]
}
