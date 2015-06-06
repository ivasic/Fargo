import Foundation

public enum JSON {
  case Object([Swift.String: JSON])
  case Array([JSON])
  case String(Swift.String)
  case Number(NSNumber)
  case Null
}

public extension JSON {
  static func encode(json: AnyObject) -> JSON {
    switch json {
    case let v as [AnyObject]: return .Array(v.map(self.encode))

    case let v as [Swift.String: AnyObject]:
      return .Object(reduce(v, [:]) { (var accum, elem) in
        let parsedValue = (Optional.Some(elem.1).map(self.encode)) ?? .Null
        accum[elem.0] = parsedValue
        return accum
      })

    case let v as Swift.String: return .String(v)
    case let v as NSNumber: return .Number(v)
    default: return .Null
    }
  }
}

extension JSON: Decodable {
  public static func decode(j: JSON) -> Decoded<JSON> {
    return .Success(Box(j))
  }
}

extension JSON: Printable {
  public var description: Swift.String {
    switch self {
    case let .String(v): return "String(\(v))"
    case let .Number(v): return "Number(\(v))"
    case let .Null: return "Null"
    case let .Array(a): return "Array(\(a.description))"
    case let .Object(o): return "Object(\(o.description))"
    }
  }
}

extension JSON: Equatable { }

public func == (lhs: JSON, rhs: JSON) -> Bool {
  switch (lhs, rhs) {
  case let (.String(l), .String(r)): return l == r
  case let (.Number(l), .Number(r)): return l == r
  case let (.Null, .Null): return true
  case let (.Array(l), .Array(r)): return l == r
  case let (.Object(l), .Object(r)): return l == r
  default: return false
  }
}

extension JSON {
	public func typeMismatch<T>(expectedType: Swift.String) -> Decoded<T> {
		return .TypeMismatch("\(self) is not a \(expectedType)")
	}
}

extension JSON {
	
	// MARK: - Objects
	
	// Pull value from JSON
	public func value<A where A: Decodable, A == A.DecodedType>(key: Swift.String) -> Decoded<A> {
		return decodedJSONForKey(self, key).flatMap(A.decode)
	}
	
	// Pull optional value from JSON
	public func value<A where A: Decodable, A == A.DecodedType>(key: Swift.String) -> Decoded<A?> {
		return .optional(self.value(key))
	}
	
	// Pull embedded value from JSON
	public func value<A where A: Decodable, A == A.DecodedType>(keys: [Swift.String]) -> Decoded<A> {
		return flatReduce(keys, self, decodedJSONForKey).flatMap(A.decode)
	}
	
	// Pull embedded optional value from JSON
	public func value<A where A: Decodable, A == A.DecodedType>(keys: [Swift.String]) -> Decoded<A?> {
		return .optional(self.value(keys))
	}
	
	// MARK: Arrays
	
	// Pull array from JSON
	public func value<A where A: Decodable, A == A.DecodedType>(key: Swift.String) -> Decoded<[A]> {
		return self.value(key).flatMap(decodeArray)
	}
	
	// Pull optional array from JSON
	public func value<A where A: Decodable, A == A.DecodedType>(key: Swift.String) -> Decoded<[A]?> {
		return .optional(self.value(key))
	}
	
	// Pull embedded array from JSON
	public func value<A where A: Decodable, A == A.DecodedType>(keys: [Swift.String]) -> Decoded<[A]> {
		return self.value(keys).flatMap(decodeArray)
	}
	
	// Pull embedded optional array from JSON
	public func value<A where A: Decodable, A == A.DecodedType>(keys: [Swift.String]) -> Decoded<[A]?> {
		return .optional(self.value(keys))
	}
}

extension JSON {
	public func decode<A where A: Decodable, A == A.DecodedType>() -> A? {
		return decode().value
	}
	
	public func decode<A where A: Decodable, A == A.DecodedType>() -> [A]? {
		return  decode().value
	}
	
	public func decode<A where A: Decodable, A == A.DecodedType>() -> Decoded<A> {
		return A.decode(self)
	}
	
	public func decode<A where A: Decodable, A == A.DecodedType>() -> Decoded<[A]> {
		return decodeArray(self)
	}
}

private func decodeArray<T where T: Decodable, T == T.DecodedType>(json: JSON) -> Decoded<[T]> {
	switch json {
	case let .Array(a): return sequence(a.map(T.decode))
	default: return json.typeMismatch("Array")
	}
}

private func decodedJSONForKey(json: JSON, key: String) -> Decoded<JSON> {
	switch json {
	case let .Object(o): return guardNull(key, o[key] ?? .Null)
	default: return json.typeMismatch("Object")
	}
}

private func guardNull(key: String, j: JSON) -> Decoded<JSON> {
	switch j {
	case .Null: return .MissingKey(key)
	default: return .Success(Box(j))
	}
}

private func flatReduce<S: SequenceType, U>(sequence: S, initial: U, combine: (U, S.Generator.Element) -> Decoded<U>) -> Decoded<U> {
	return reduce(sequence, Decoded.Success(Box(initial))) { accum, x in
		accum.flatMap({ combine($0, x) })
	}
}