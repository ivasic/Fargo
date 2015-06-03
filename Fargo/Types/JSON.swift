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
	
	static func typeMismatch<T>(expectedType: Swift.String, object: Printable) -> Decoded<T> {
		let error = NSError(domain: FargoErrorDomain, code: FargoErrorCode.TypeMismatch.rawValue, userInfo: [NSLocalizedDescriptionKey: NSLocalizedString("`\(object)` is not a `\(expectedType)`", comment: "")])
		return .Error(error)
	}
	
	static func missingKey<T>(key: Swift.String, object: JSON) -> Decoded<T> {
		let error = NSError(domain: FargoErrorDomain, code: FargoErrorCode.MissingKey.rawValue, userInfo: [NSLocalizedDescriptionKey: NSLocalizedString("Key `\(key)` doesn't exist in \(object)", comment: "")])
		return .Error(error)
	}
	
	func object(key: Swift.String) -> Decoded<[Swift.String: JSON]> {
		switch self {
		case .Object(let o):
			return .Success(Box(o))
		default:
			let error = NSError(domain: FargoErrorDomain, code: FargoErrorCode.TypeMismatch.rawValue, userInfo: [NSLocalizedDescriptionKey: "`\(self)` is not an Object"])
			return .Error(error)
		}
	}
	
	public func value<A where A: Decodable, A == A.DecodedType>(key: Swift.String) -> Decoded<A> {
		let obj = object(key)
		if let error = obj.error { return .Error(error) }
		
		if let s = obj.value![key] {
			return A.decode(s)
		} else {
			return JSON.missingKey(key, object: self)
		}
	}
	
	public func value<A where A: Decodable, A == A.DecodedType>(key: Swift.String) -> Decoded<[A]> {
		let obj = object(key)
		if let error = obj.error { return .Error(error) }
		
		if let array = obj.value![key] {
			switch array {
			case .Array(let jsonArray):
				let mapped = jsonArray.map(A.decode)
				let reduced = mapped.reduce(Decoded<[A]>.Success(Box([A]())), combine: { (accum, decoded) -> Decoded<[A]> in
					switch accum {
					case .Success(let box):
						var array = box.value
						switch decoded {
						case .Success(let valueBox):
							array.append(valueBox.value)
							return .Success(Box(array))
						case .Error(let error): return .Error(error)
						}
					case .Error: return accum
					}
				})
				
				return reduced
			default:
				return JSON.typeMismatch("Array", object: array)
			}
		} else {
			return JSON.missingKey(key, object: self)
		}
	}
	
	public func value<A where A: Decodable, A == A.DecodedType>(key: Swift.String) -> Decoded<[A]?> {
		let obj = object(key)
		if let error = obj.error { return .Error(error) }
		
		if let array = obj.value![key] {
			switch array {
			case .Array(let jsonArray):
				let mapped = jsonArray.map(A.decode)
				let reduced = mapped.reduce(Decoded<[A]?>.Success(Box([A]())), combine: { (accum, decoded) -> Decoded<[A]?> in
					switch accum {
					case .Success(let box):
						var array = box.value
						switch decoded {
						case .Success(let valueBox):
							array?.append(valueBox.value)
							return .Success(Box(array))
						case .Error(let error): return .Error(error)
						}
					case .Error: return accum
					}
				})
				
				return reduced
			default:
				return JSON.typeMismatch("Array", object: array)
			}
		} else {
			return .Success(Box(.None))
		}
	}
	
	public func value<A where A: Decodable, A == A.DecodedType>(key: Swift.String) -> Decoded<A?> {
		let obj = object(key)
		if let error = obj.error { return .Error(error) }
		
		if let s = obj.value![key] {
			let decoded =  A.decode(s)
			switch decoded {
			case .Success(let box): return .Success(Box(.Some(box.value)))
			case .Error(let error): return .Error(error)
			}
		} else {
			return .Success(Box(.None))
		}
	}
	
	public func value<A, T where A: Decodable, A == A.DecodedType>(key: Swift.String, convert: (A) -> T) -> Decoded<T> {
		let obj = object(key)
		if let error = obj.error { return .Error(error) }
		
		if let s = obj.value![key] {
			let decoded =  A.decode(s)
			switch decoded {
			case .Success(let box): return .Success(Box(convert(box.value)))
			case .Error(let error): return .Error(error)
			}
		} else {
			return JSON.missingKey(key, object: self)
		}
	}
	
	public func decode<T: Decodable where T == T.DecodedType>() -> T? {
		return T.decode(self).value
	}
	
//	public func decode<T: Decodable where T == T.DecodedType>(object: AnyObject) -> [T]? {
//		return decode(object).value
//	}
	
	public func decode<T: Decodable where T == T.DecodedType>() -> Decoded<T> {
		return T.decode(self)
	}
	
//	public func decode<T: Decodable where T == T.DecodedType>(object: AnyObject) -> Decoded<[T]> {
//		return decodeArray(JSON.parse(object))
//	}

}
