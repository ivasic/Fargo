//
//  FoundationTypes.swift
//  Fargo
//
//  Created by Ivan Vasic on 20/06/15.
//  Copyright © 2015 Ivan Vasic. All rights reserved.
//

import Foundation

extension String: Decodable {
	public static func decode(j: JSON) throws -> String {
		switch j {
		case let .String(s): return s
		default:
			throw DecodeError.TypeMismatch("Expected String, got `\(j)` instead.")
		}
	}
}

extension Bool: Decodable {
	public static func decode(j: JSON) throws -> Bool {
		switch j {
		case let .Number(n): return n as Bool
		default:
			throw DecodeError.TypeMismatch("Expected Bool, got `\(j)` instead.")
		}
	}
}

extension Int: Decodable {
	public static func decode(j: JSON) throws -> Int {
		switch j {
		case let .Number(n): return n as Int
		default:
			throw DecodeError.TypeMismatch("Expected Int, got `\(j)` instead.")
		}
	}
}