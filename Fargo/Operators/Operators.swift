//
//  Operators.swift
//  Fargo
//
//  Created by Ivan Vasic on 06/06/15.
//  Copyright (c) 2015 Ivan Vasic. All rights reserved.
//

import Foundation

infix operator <^> { associativity left precedence 130 }
infix operator <*> { associativity left precedence 130 }

public func <^> <A, B>(f: A -> B, a: Decoded<A>) -> Decoded<B> {
	return a.map(f)
}

public func <*> <A, B>(f: Decoded<A -> B>, a: Decoded<A>) -> Decoded<B> {
	return a.apply(f)
}