import Foundation

extension String: Decodable {
  public static func decode(j: JSON) -> Decoded<String> {
    switch j {
    case let .String(s): return Decoded.pure(s)
    default: return JSON.typeMismatch("String", object: j)
    }
  }
}

extension Int: Decodable {
  public static func decode(j: JSON) -> Decoded<Int> {
    switch j {
    case let .Number(n): return Decoded.pure(n as Int)
    default: return JSON.typeMismatch("Int", object: j)
    }
  }
}

extension Int64: Decodable {
  public static func decode(j: JSON) -> Decoded<Int64> {
    switch j {
    case let .Number(n): return Decoded.pure(n.longLongValue)
    default: return JSON.typeMismatch("Int64", object: j)
    }
  }
}

extension Double: Decodable {
  public static func decode(j: JSON) -> Decoded<Double> {
    switch j {
    case let .Number(n): return Decoded.pure(n as Double)
    default: return JSON.typeMismatch("Double", object: j)
    }
  }
}

extension Bool: Decodable {
  public static func decode(j: JSON) -> Decoded<Bool> {
    switch j {
    case let .Number(n): return Decoded.pure(n as Bool)
    default: return JSON.typeMismatch("Bool", object: j)
    }
  }
}

extension Float: Decodable {
	public static func decode(j: JSON) -> Decoded<Float> {
		switch j {
		case let .Number(n): return Decoded.pure(n as Float)
		default: return JSON.typeMismatch("Float", object: j)
		}
	}
}

