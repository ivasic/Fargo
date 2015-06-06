//
//  sequence.swift
//  Fargo
//
//  Created by Ivan Vasic on 06/06/15.
//  Copyright (c) 2015 Ivan Vasic. All rights reserved.
//

import Foundation

func sequence<T>(xs: [Decoded<T>]) -> Decoded<[T]> {
	return reduce(xs, Decoded.Success(Box([]))) { accum, elem in
		curry(+) <^> accum <*> elem.map({ [$0] })
	}
}