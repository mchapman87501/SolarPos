// NOTE: Expected values were obtained from 
// https://www.esrl.noaa.gov/gmd/grad/solcalc/

import Foundation
import XCTest
@testable import SolarPos

class DeclinationTests: XCTestCase {
    struct Expected {
        let timespec: TimeSpec
        let expected: Double

        func assertEq(_ actual: Double) {
            // NOAA declinations are to the nearest 0.01 degree
            XCTAssertEqual(actual, expected, accuracy: 0.01)
        }
    }

    func testKSAFDeclinations1() throws {
        func localNoon(
            _ year: Int, _ month: UInt, _ day: UInt, _ dst: Bool
        ) -> TimeSpec {
            return TimeSpec(year: year, month: month, day: day, hour: 12,
                            minute: 0, second: 0, gmtOffset: dst ? -6 : -7)
        }
        // From NOAA site, for KSAF location:
        let cases = [
            Expected(timespec: localNoon(2004, 7, 1, true), expected: 23.05),
            Expected(timespec: localNoon(2018, 2, 24, false), expected: -9.27),
            Expected(timespec: localNoon(2020, 9, 15, true), expected: 2.64)
        ]
        for subTest in cases {
            let location = ksafLoc
            // Just choose some dummy atmospheric conditions:
            let temp = 10.0 // degrees C
            let press = mbar(29.92)

            let pos = try SolarPos(
                location: location, timespec: subTest.timespec,
                temperature: temp, pressure: press)
            let actual = pos.topoAngles.declination
            subTest.assertEq(actual)
        }
    }

    static var allTests = [
        ("testKSAFDeclinations1", testKSAFDeclinations1)
    ]
}
