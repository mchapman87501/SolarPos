import Foundation
import XCTest
@testable import SolarPos

class SunriseSunsetTests: XCTestCase {
    // Test against some reference sunrise/sunset times from
    // (unnamed online sources) for U.S. airport KSAF
    func testTimesForKSAF() throws {
        struct ExpectedResult {
            let ts: TimeSpec
            let sunriseETR: Int // minutes after midnight
            let sunsetETR: Int  // minutes after midnight
            
            init(_ y: Int, _ m: UInt, _ d: UInt, 
                 _ sriseHr: Int, _ sriseMinute: Int, 
                 _ ssetHr: Int, _ ssetMinute: Int, gmtOffset: Int = -7)
            {
                ts = TimeSpec(year: y, month: m, day: d, 
                              hour: 12, minute: 0, second: 0, gmtOffset: gmtOffset)
                sunriseETR = (sriseHr * 60) + sriseMinute
                sunsetETR = (ssetHr * 60) + ssetMinute
            }
            
            func description() -> String {
                return "Expected(ts(\(ts.year), \(ts.month), \(ts.day)), rise \(sunriseETR), set \(sunsetETR))"
            }
        }
        
        let expected = [
            ExpectedResult(2018, 2, 24, 6, 40, 17, 55),
            ExpectedResult(2004, 7, 1, 5, 53, 20, 24, gmtOffset: -6),
            ExpectedResult(2017, 7, 1, 5, 53, 20, 24, gmtOffset: -6),
        ]

        let location = Location(lat: 35.6171111, lon: -106.0894167, elev: 1935.1)
        
        let temperature = 21.0 // Darned if I know
        // TODO (milli)bars are deprecated by NIST and other organizations in favor of 
        let mbarsPerInHg = 1000.0 / 29.53
        let pressure = 29.96 * mbarsPerInHg
        
        for e in expected {
            let angles = try SolarPos(
                location: location, timespec: e.ts, 
                temperature: temperature, pressure: pressure
            )
            let actual = SunriseSunset(
                location: location, timespec: e.ts, solarPos: angles
            )
            XCTAssertEqual(e.sunriseETR, Int(0.5 + actual.sunriseETR), e.description())
            XCTAssertEqual(e.sunsetETR, Int(0.5 + actual.sunsetETR), e.description())
        }
    }

    static var allTests = [
        ("testTimesForKSAF", testTimesForKSAF),
    ]
}
