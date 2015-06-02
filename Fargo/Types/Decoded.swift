
public enum Decoded<T> {
	case Success(Box<T>)
	case Error(NSError)
	
	public var value: T? {
		switch self {
		case let .Success(box): return box.value
		default: return .None
		}
	}
	
	public var error: NSError? {
		switch self {
		case let .Error(e): return e
		default: return .None
		}
	}
	
	public static func pure(t: T) -> Decoded<T> {
		return .Success(Box(t))
	}
}

extension Decoded: Printable {
	public var description: String {
		switch self {
		case let .Success(x): return "Success(\(x))"
		case let .Error(e): return "Error(\(e))"
		}
	}
}