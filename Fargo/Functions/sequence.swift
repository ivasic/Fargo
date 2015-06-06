import Foundation

func sequence<T>(xs: [Decoded<T>]) -> Decoded<[T]> {
	return reduce(xs, Decoded.Success(Box([]))) { accum, elem in
		curry(+) <^> accum <*> elem.map({ [$0] })
	}
}