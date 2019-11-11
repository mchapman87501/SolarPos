import Foundation

// Convert a pressure in inches of Mercury to a pressure in millibars
func mbar(_ inHg: Double) -> Double {
    // TODO (milli)bars are deprecated by NIST and other organizations in favor of 
    let mbarsPerInHg = 1000.0 / 29.53
    return inHg * mbarsPerInHg
}