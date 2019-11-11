import XCTest
@testable import SolarPos

struct TestRecord {
    let year: Int
    let month: UInt
    let day: Double

    let expected: Double

    init(_ year: Int, _ month: UInt, _ day: Double, _ dayFract: Double, _ expected: Double) {
        self.year = year
        self.month = month
        self.day = day + dayFract
        self.expected = expected
    }
}

typealias TRec = TestRecord

class JulianDayTests: XCTestCase {
    func testFromTableA41() throws {
        // Run all of the tests from Table A4.1. of 
        // http://www.nrel.gov/docs/fy08osti/34302.pdf

        let subTests: [TRec] = [
            TRec(2000, 1, 1, 0.5, 2451545.0),
            TRec(1999, 1, 1, 0.0, 2451179.5),
            TRec(1987, 1, 27, 0.0, 2446822.5),
            TRec(1987, 6, 19, 0.5, 2446966.0),
            TRec(1988, 1, 27, 0.0, 2447187.5),
            TRec(1988, 6, 19, 0.5, 2447332.0),
            TRec(1900, 1, 1, 0.0, 2415020.5),
            TRec(1600, 1, 1, 0.0, 2305447.5),
            TRec(1600, 12, 31, 0.0, 2305812.5),
            TRec(837, 4, 10, 7.0/24.0 + 12.0/(24.0 * 60.0), 2026871.8),
            TRec(-123, 12, 31, 0.0, 1676496.5),
            TRec(-122, 1, 1, 0.0, 1676497.5),
            TRec(-1000, 7, 12, 0.5, 1356001.0),
            TRec(-1000, 2, 29, 0.0, 1355866.5),
            TRec(-1001, 8, 17, 21.0/24.0 + 36.0/(24.0 * 60.0), 1355671.4),
            TRec(-4712, 1, 1, 0.5, 0.0)
        ]
        for testCase in subTests {
            let jday = try JulianDay(
                year: testCase.year, month: testCase.month, day: testCase.day)
            XCTAssertEqual(
                jday.julianDay, testCase.expected,
                "Failed for \(testCase.year), \(testCase.month), \(testCase.day)")
        }
    }

    func testGetDayNum() throws {
        // From NREL's stest00.c:
        let julian = try JulianDay(year: 1999, month: 7, day: 22.0)
        let daynum = try julian.getDayNum()
        XCTAssertEqual(daynum, 203)
    }

    static var allTests = [
        ("testFromTableA41", testFromTableA41),
        ("testGetDayNum", testGetDayNum)
    ]
}
