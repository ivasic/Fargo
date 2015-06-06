import Foundation

extension String: Decodable {
  public static func decode(j: JSON) -> Decoded<String> {
    switch j {
    case let .String(s): return pure(s)
    default: return j.typeMismatch("String")
    }
  }
}

extension Int: Decodable {
  public static func decode(j: JSON) -> Decoded<Int> {
    switch j {
    case let .Number(n): return pure(n as Int)
    default: return j.typeMismatch("Int")
    }
  }
}

extension Int64: Decodable {
  public static func decode(j: JSON) -> Decoded<Int64> {
    switch j {
    case let .Number(n): return pure(n.longLongValue)
    default: return j.typeMismatch("Int64")
    }
  }
}

extension Double: Decodable {
  public static func decode(j: JSON) -> Decoded<Double> {
    switch j {
    case let .Number(n): return pure(n as Double)
    default: return j.typeMismatch("Double")
    }
  }
}

extension Bool: Decodable {
  public static func decode(j: JSON) -> Decoded<Bool> {
    switch j {
    case let .Number(n): return pure(n as Bool)
    default: return j.typeMismatch("Bool")
    }
  }
}

extension Float: Decodable {
	public static func decode(j: JSON) -> Decoded<Float> {
		switch j {
		case let .Number(n): return pure(n as Float)
		default: return j.typeMismatch("Float")
		}
	}
}

private func pure<A>(a: A) -> Decoded<A> {
	return .Success(Box(a))
}
