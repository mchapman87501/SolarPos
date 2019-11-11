// Describes solar panel orientation parameters relevant to irradiance calculations.
public struct Orientation {
    public let tilt: Double   // Degrees tilt from horizontal of panel
    public let azimuth: Double // Azimuth of panel surface, degrees. North =  0, East = 90.0, etc.

    public init(tilt: Double, azimuth: Double) {
        self.tilt = tilt
        self.azimuth = azimuth
    }
}
