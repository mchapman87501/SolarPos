import XCTest
@testable import SolarPos

struct TestRecord {
    let year: Int
    let month: UInt
    let day: Double
    
    let expected: Double
    
    init(_ y: Int, _ m: UInt, _ d: Double, _ df: Double, _ e: Double) {
        year = y
        month = m
        day = d + df
        expected = e
    }
}

class JulianDayTests: XCTestCase {
    func testFromTableA41() throws {
        // Run all of the tests from Table A4.1. of 
        // http://www.nrel.gov/docs/fy08osti/34302.pdf
        
        typealias TR = TestRecord
        let fixture: [TR] = [
            TR(2000, 1, 1, 0.5, 2451545.0),
            TR(1999, 1, 1, 0.0, 2451179.5),
            TR(1987, 1, 27, 0.0, 2446822.5),
            TR(1987, 6, 19, 0.5, 2446966.0),
            TR(1988, 1, 27, 0.0, 2447187.5),
            TR(1988, 6, 19, 0.5, 2447332.0),
            TR(1900, 1, 1, 0.0, 2415020.5),
            TR(1600, 1, 1, 0.0, 2305447.5),
            TR(1600, 12, 31, 0.0, 2305812.5),
            TR(837, 4, 10, 7.0/24.0 + 12.0/(24.0 * 60.0), 2026871.8),
            TR(-123, 12, 31, 0.0, 1676496.5),
            TR(-122, 1, 1, 0.0, 1676497.5),
            TR(-1000, 7, 12, 0.5, 1356001.0),
            TR(-1000, 2, 29, 0.0, 1355866.5),
            TR(-1001, 8, 17, 21.0/24.0 + 36.0/(24.0 * 60.0), 1355671.4),
            TR(-4712, 1, 1, 0.5, 0.0)
        ]
        for tc in fixture {
            let jd = try JulianDay(
                year: tc.year, month: tc.month, day: tc.day)
            // print(jd)
            XCTAssertEqual(
                jd.julianDay, tc.expected, 
                "Failed for \(tc.year), \(tc.month), \(tc.day)")
        }
    }
    
    func testGetDayNum() throws {
        // From NREL's stest00.c:
        let julian = try JulianDay(year:1999, month:7, day:22.0)
        let daynum = try julian.getDayNum()
        XCTAssertEqual(daynum, 203)
    }


    static var allTests = [
        ("testFromTableA41", testFromTableA41),
        ("testGetDayNum", testGetDayNum)
    ]
}
