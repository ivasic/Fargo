//
//  JSON.swift
//  Fargo
//
//  Created by Ivan Vasic on 01/11/15.
//  Copyright © 2015 Ivan Vasic. All rights reserved.
//

import Foundation

public struct JSON {
    public let object: AnyObject
    let keyPath: KeyPath
    
    // MARK: - Initialization
    
    public init(object: AnyObject) {
        self.init(object: object, keyPath: KeyPath())
    }
    
    init(object: AnyObject, keyPath: KeyPath) {
        self.object = object
        self.keyPath = keyPath
    }
}

// MARK: - KeyPath

extension JSON {
    
    public struct KeyPath: CustomDebugStringConvertible {
        public let path: [Key]
        
        public enum Key {
            case Key(String)
            case Index(Int)
        }
        
        init(path: [Key] = []) {
            self.path = path
        }
        
        public var debugDescription: String {
            get {
                guard !path.isEmpty else { return "/" }
                return path.reduce("/", combine: { (result, key) -> String in
                    var subpath = ""
                    var separator = ""
                    switch key {
                    case .Key(let str):
                        subpath = str
                        separator = "."
                    case .Index(let idx): subpath = "[\(idx)]"
                    }
                    return "\(result)\(separator)\(subpath)"
                })
            }
        }
    }
}


// MARK: - Methods

extension JSON {

    func objectType() -> String {
        return String(object.dynamicType)
    }
    
    func nextKeyPath(key: String) -> KeyPath {
        var path = keyPath.path
        path.append(.Key(key))
        return KeyPath(path: path)
    }
    
    func nextKeyPath(index: Int) -> KeyPath {
        var path = keyPath.path
        path.append(.Index(index))
        return KeyPath(path: path)
    }
    
    func jsonForKeyPath(keyPath: KeyPath) throws -> JSON {
        return try keyPath.path.reduce(self, combine: { (result, key) -> JSON in
            return try result.jsonForKey(key)
        })
    }
    
    func jsonForKey(key: KeyPath.Key) throws -> JSON {
        switch key {
        case .Key(let string): return try jsonForKey(string)
        case .Index(let index): return try jsonAtIndex(index)
        }
    }
    
    func jsonForKey(key: String) throws -> JSON {
        guard let json = try jsonForKey(key) as JSON? else {
            throw Error.MissingKey(key: .Key(key), keyPath: keyPath)
        }
        return json
    }
    
    func jsonForKey(key: String) throws -> JSON? {
        guard let dictionary = object as? [String: AnyObject] else {
            throw Error.TypeMismatch(expectedType: "Object", actualType: objectType(), keyPath: keyPath)
        }
        guard let object = dictionary[key] else {
            return .None
        }
        return JSON(object: object, keyPath: nextKeyPath(key))
    }
    
    func jsonAtIndex(index: Int) throws -> JSON {
        guard let array = object as? [AnyObject] else {
            throw Error.TypeMismatch(expectedType: "Array", actualType: objectType(), keyPath: keyPath)
        }
        guard array.count > index else {
            throw Error.MissingKey(key: .Index(index), keyPath: keyPath)
        }
        return JSON(object: array[index], keyPath: nextKeyPath(index))
    }
    
    func jsonForKeys(keys: [String]) throws -> JSON {
        return try keys.reduce(self) { (json, key) -> JSON in try json.jsonForKey(key) }
    }
    
    func jsonForKeys(keys: [String]) throws -> JSON? {
        return try keys.reduce(self) { (json, key) -> JSON? in try json?.jsonForKey(key) }
    }
}

// MARK: - Decodes

extension JSON {
    
    public func decode<A where A: Decodable>() throws -> A {
        return try A.decode(self)
    }
    
    public func decode<A where A: Decodable>() throws -> [A] {
        guard let array = object as? [AnyObject] else {
            throw Error.TypeMismatch(expectedType: "Array", actualType: objectType(), keyPath: keyPath)
        }
        return try array.enumerate().map {
            return try JSON(object: $0.element, keyPath: nextKeyPath($0.index)).decode()
        }
    }
}

// MARK: - Values

extension JSON {
    
    // MARK: - Objects
    
    // key -> A
    public func value<A where A: Decodable>(key: String) throws -> A {
        return try A.decode(jsonForKey(key))
    }
    
    // key[] -> A
    public func value<A where A: Decodable>(keys: [String]) throws -> A {
        return try A.decode(jsonForKeys(keys))
    }
    
    // key -> transform(A) -> B
    public func value<A, B where A: Decodable>(key: String, transform: A throws -> B) throws -> B {
        return try transform(A.decode(jsonForKey(key)))
    }
    
    // key[] -> transform(A) -> B
    public func value<A, B where A: Decodable>(keys: [String], transform: A throws -> B) throws -> B {
        return try transform(A.decode(jsonForKeys(keys)))
    }
    
    // MARK: - Optional objects
    
    // key -> A?
    public func value<A where A: Decodable>(key: String) throws -> A? {
        guard let json = try jsonForKey(key) as JSON? else { return .None }
        return try A.decode(json)
    }
    
    // key[] -> A?
    public func value<A where A: Decodable>(keys: [String]) throws -> A? {
        guard let json = try jsonForKeys(keys) as JSON? else { return .None }
        return try A.decode(json)
    }
    
    // key -> transform(A) -> B?
    public func value<A, B where A: Decodable>(key: String, transform: A throws -> B?) throws -> B? {
        guard let json = try jsonForKey(key) as JSON? else { return .None }
        let val = try A.decode(json)
        return try transform(val)
    }
    
    // key[] -> transform(A) -> B?
    public func value<A, B where A: Decodable>(keys: [String], transform: A throws -> B?) throws -> B? {
        guard let json = try jsonForKeys(keys) as JSON? else { return .None }
        return try transform(A.decode(json))
    }
    
    // MARK: - Arrays
    
    // key -> [A]
    public func value<A where A: Decodable>(key: String) throws -> [A] {
        return try jsonForKey(key).decode()
    }
    
    // key -> [A]?
    public func value<A where A: Decodable>(key: String) throws -> [A]? {
        guard let json = try jsonForKey(key) as JSON? else { return .None }
        return try json.decode()
    }
    
    // key[] -> [A]
    public func value<A where A: Decodable>(keys: [String]) throws -> [A] {
        return try jsonForKeys(keys).decode()
    }
    
    // key[] -> [A]?
    public func value<A where A: Decodable>(keys: [String]) throws -> [A]? {
        guard let json = try jsonForKeys(keys) as JSON? else { return .None }
        return try json.decode()
    }
}

extension JSON: CustomDebugStringConvertible {
    public var debugDescription: String {
        get {
            if let array = object as? [AnyObject] {
                if let first = array.first {
                    return "Array<\(first.dynamicType)> (\(array.count))"
                } else {
                    return "Array (empty)"
                }
            } else if let object = object as? [String: AnyObject] {
                return "Object (\(object.keys.count))"
            }
            return "\(objectType()) (\(object))"
        }
    }
}
