//
//  Array.swift
//  Fargo
//
//  Created by Ivan Vasic on 20/06/15.
//  Copyright © 2015 Ivan Vasic. All rights reserved.
//

import Foundation

extension Array {
	
	/// Workaround for Swift 2.0b1 bug where map doesn't rethrow
	func mmap<T>(@noescape transform: (Generator.Element) throws -> T) throws -> [T] {
		var ts: [T] = []
		for x in self {
			ts.append(try transform(x))
		}
		return ts
	}
	
	/// Workaround for Swift 2.0b1 bug where reduce doesn't rethrow
	func mreduce<T>(initial: T, @noescape combine: (T, Generator.Element) throws -> T) throws -> T {
		var accum: T = initial
		for x in self {
			accum = try combine(accum, x)
		}
		return accum
	}
}