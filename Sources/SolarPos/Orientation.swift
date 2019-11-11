// Describes solar panel orientation parameters relevant to irradiance calculations.
public struct Orientation {
    public let tilt: Double   // Degrees tilt from horizontal of panel
    public let azimuth: Double // Azimuth of panel surface, degrees. North =  0, East = 90.0, etc.
    
    public init(tilt t: Double, azimuth a: Double) {
        tilt = t
        azimuth = a
    }
}