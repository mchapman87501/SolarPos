public struct ObliquityOfEcliptic {
    public let meanObliq: Double
    public let trueObliq: Double

    private static let coeffs = [84381.448, -4680.93, -1.55, 1999.25, 51.38, -249.67, -39.05, 7.12, 27.87, 5.79, 2.45]

    public init(jme: Double, nutations: Nutations) {

        let mean = poly(coeffs: ObliquityOfEcliptic.coeffs, x: jme/10.0)

        meanObliq = mean
        trueObliq = mean / 3600.0 + nutations.obliquity
    }
}
