public func muModulo(_ v: Double, radix: Double = 360.0) -> Double {
    let whole = radix * Double(Int(v / radix))
    let fract = v - whole
    let result = (fract >= 0) ? fract : (fract + radix)
    return result
}

public func oneRev(_ v: Double) -> Double {
    return muModulo(v)
}

public func longitudeLimit(_ degrees: Double) -> Double {
    let dRev = muModulo(degrees)
    if (dRev > 180.0) {
        return dRev - 360.0
    }
    return dRev
}

public func degrees(_ rads: Double) -> Double {
    return 180.0 * rads / .pi
    // return modulo(180.0 * rads / .pi, radix: 360.0)
}

public func rads(_ degrees: Double) -> Double {
    return .pi * degrees / 180.0
}

// Generate successive integer powers of term, starting from 0
fileprivate class Powers{
    let term: Double
    private var currValue = 1.0
    
    init(_ t: Double) {
        term = t
    }

    func next() -> Double {
        defer { currValue *= term }
        return currValue
    }
}

public func poly(coeffs: [Double], x: Double) -> Double {
    let powers = Powers(x)
    let terms = coeffs.map { $0 * powers.next() }
    return terms.reduce(0.0) { $0 + $1 }
}

// Linear interpolation across x, with crash on extrapolation :)
public func linterp(x: Double, xvals: [Double], yvals: [Double]) -> Double {
    var i = 1
    while x > xvals[i] {
        i += 1
    }
    let xfract = (x - xvals[i - 1]) / (xvals[i] - xvals[i - 1])
    return xfract * (yvals[i] - yvals[i - 1]) + yvals[i - 1]
}
