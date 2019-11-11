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
        
        // From NOAA site, for KSAF location:
        func localNoon(_ y: Int, _ m: UInt, _ d: UInt, _ dst: Bool) -> TimeSpec 
        {
            return TimeSpec(year: y, month: m, day: d, hour: 12, 
                            minute: 0, second: 0, gmtOffset: dst ? -6 : -7)
        }
        let cases = [
            Expected(timespec: localNoon(2004, 7,  1, true), expected: 23.05),
            Expected(timespec: localNoon(2018, 2, 24, false), expected: -9.27),
            Expected(timespec: localNoon(2020, 9, 15, true), expected: 2.64)
        ]
        for c in cases {
            let location = ksafLoc
            // Just choose some dummy atmospheric conditions:
            let temp = 10.0 // degrees C
            let press = mbar(29.92)
            
            let sa = try SolarPos(
                location: location, timespec:c.timespec, 
                temperature: temp, pressure: press)
            let actual = sa.topoAngles.declination
            c.assertEq(actual)
        }
    }
    
    static var allTests = [
        ("testKSAFDeclinations1", testKSAFDeclinations1),
    ]
    
}