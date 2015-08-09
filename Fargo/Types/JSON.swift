//
//  JSON.swift
//  Fargo
//
//  Created by Ivan Vasic on 20/06/15.
//  Copyright © 2015 Ivan Vasic. All rights reserved.
//

import Foundation

public enum JSON {
	case Object([Swift.String: JSON])
	case Array([JSON])
	case String(Swift.String)
	case Number(NSNumber)
	case Null
}

public extension JSON {
	public static func convert(json: AnyObject) -> JSON {
		switch json {
		case let v as [AnyObject]: return .Array(v.map(convert))
			
		case let v as [Swift.String: AnyObject]:
			return .Object(v.reduce([:]) { (var accum, elem) in
				let parsedValue = (Optional.Some(elem.1).map(convert)) ?? .Null
				accum[elem.0] = parsedValue
				return accum
				})
			
		case let v as Swift.String: return .String(v)
		case let v as NSNumber: return .Number(v)
		default: return .Null
		}
	}
}

// MARK: - Decodes

extension JSON {
	public func decode<A where A: Decodable, A == A.DecodedType>() throws -> A {
		return try A.decode(self)
	}
	
	public func decode<A where A: Decodable, A == A.DecodedType>() throws -> [A] {
		switch self {
		case let .Array(a): return try a.mmap(A.decode)
		default:
			throw DecodeError.TypeMismatch("Expected an Array, got `\(self)` instead")
		}
	}
}

// MARK: - Values 

extension JSON {
	
	// MARK: - Objects
	
	public func value<A where A: Decodable, A == A.DecodedType>(key: Swift.String) throws -> A {
		return try A.decode(JSONForKey(key, json: self))
	}
	
	public func value<A, B where A: Decodable, A == A.DecodedType>(key: Swift.String, transform: A throws -> B) throws -> B {
		let val = try A.decode(JSONForKey(key, json: self))
		return try transform(val)
	}
	
	public func value<A where A: Decodable, A == A.DecodedType>(key: Swift.String) throws -> A? {
		guard let json = try optionalJSONForKey(key, json: self) else { return .None }
		return try A.decode(json)
	}
	
	public func value<A, B where A: Decodable, A == A.DecodedType>(key: Swift.String, transform: A throws -> B?) throws -> B? {
		guard let json = try optionalJSONForKey(key, json: self) else { return .None }
		let val = try A.decode(json)
		return try transform(val)
	}
	
	public func value<A where A: Decodable, A == A.DecodedType>(keys: [Swift.String]) throws -> A {
		return try A.decode(keys.mreduce(self) { (json, key) -> JSON in try JSONForKey(key, json: json) })
	}
	
	public func value<A, B where A: Decodable, A == A.DecodedType>(keys: [Swift.String], transform: A throws -> B) throws -> B {
		let val = try A.decode(keys.mreduce(self) { (json, key) -> JSON in try JSONForKey(key, json: json) })
		return try transform(val)
	}
	
	public func value<A where A: Decodable, A == A.DecodedType>(keys: [Swift.String]) throws -> A? {
		guard let json = try optionalJSONForKeys(keys, json: self) else { return .None }
		return try A.decode(json)
	}
	
	public func value<A, B where A: Decodable, A == A.DecodedType>(keys: [Swift.String], transform: A throws -> B?) throws -> B? {
		guard let json = try optionalJSONForKeys(keys, json: self) else { return .None }
		let val = try A.decode(json)
		return try transform(val)
	}
	
	// MARK: - Arrays
	
	public func value<A where A: Decodable, A == A.DecodedType>(key: Swift.String) throws -> [A] {
		return try JSONForKey(key, json: self).decode()
	}
	
	public func value<A where A: Decodable, A == A.DecodedType>(key: Swift.String) throws -> [A]? {
		guard let json = try optionalJSONForKey(key, json: self) else { return .None }
		return try json.decode()
	}
	
	public func value<A where A: Decodable, A == A.DecodedType>(keys: [Swift.String]) throws -> [A] {
		return try keys.mreduce(self, combine: { (json, key) -> JSON in try JSONForKey(key, json: json) }).decode()
	}
	
	public func value<A where A: Decodable, A == A.DecodedType>(keys: [Swift.String]) throws -> [A]? {
		guard let json = try optionalJSONForKeys(keys, json: self) else { return .None }
		return try json.decode()
	}
}

// MARK: - Private methods

private func JSONForKey(key: Swift.String, json: JSON) throws -> JSON {
	switch json {
	case let .Object(o): return try guardNull(key, json: o[key] ?? .Null)
	default: throw DecodeError.TypeMismatch("Expected an Object, got `\(json)` instead.")
	}
}

private func guardNull(key: Swift.String, json: JSON) throws -> JSON {
	switch json {
	case .Null: throw DecodeError.MissingKey("Key `\(key)` not found in JSON `\(json)`")
	default: return json
	}
}

private func optionalJSONForKey(key: Swift.String, json: JSON) throws -> JSON? {
	do {
		return try JSONForKey(key, json: json)
	} catch DecodeError.MissingKey(_) {
		return .None
	}
}

private func optionalJSONForKeys(keys: [Swift.String], json: JSON) throws -> JSON? {
	do {
		return try keys.mreduce(json) { (json, key) -> JSON in try JSONForKey(key, json: json) }
	} catch DecodeError.MissingKey(_) {
		return .None
	}
}

// MARK: - CustomStringConvertible

extension JSON: CustomStringConvertible {
	public var description: Swift.String {
		switch self {
		case let .String(v): return "String(\(v))"
		case let .Number(v): return "Number(\(v))"
		case .Null: return "Null"
		case let .Array(a): return "Array(\(a.description))"
		case let .Object(o): return "Object(\(o.description))"
		}
	}
}
