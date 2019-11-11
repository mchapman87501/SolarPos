private func aberrationCorrection(_ earthRadiusVector: Double) -> Double {
    return -20.4898 / (3600.0 * earthRadiusVector)
}

public func apparentSunLongitude(
    lon geocentricLongitude: Double, nl nutationInLongitude: Double,
    r earthRadiusVector: Double) -> Double {
    let aberrCorr = aberrationCorrection(earthRadiusVector)
    return geocentricLongitude + nutationInLongitude + aberrCorr
}
