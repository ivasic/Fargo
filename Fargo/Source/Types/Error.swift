//
//  Error.swift
//  Fargo
//
//  Created by Ivan Vasic on 01/11/15.
//  Copyright © 2015 Ivan Vasic. All rights reserved.
//

import Foundation

extension JSON {
    public enum Error : ErrorType, CustomDebugStringConvertible {
        case MissingKey(key: JSON.KeyPath.Key, keyPath: JSON.KeyPath)
        case TypeMismatch(expectedType: String, actualType: String, keyPath: JSON.KeyPath)
        
        public init(typeMismatchForType type: String, json: JSON) {
            self = .TypeMismatch(expectedType: type, actualType: json.objectType(), keyPath: json.keyPath)
        }
        
        public init(missingKey key: JSON.KeyPath.Key, json: JSON) {
            self = .MissingKey(key: key, keyPath: json.keyPath)
        }
        
        public var debugDescription: String {
            get {
                switch self {
                case .MissingKey(let key, let keyPath):
                    return "MissingKey `\(key)` in keyPath `\(keyPath)`"
                case .TypeMismatch(let expected, let actual, let keyPath):
                    return "TypeMismatch, expected `\(expected)` got `\(actual)` for keyPath `\(keyPath)`"
                }
            }
        }
        
        public func descriptionForJSON(json: JSON) -> String {
            switch self {
            case .MissingKey(let key, let keyPath):
                var string = "MissingKey `\(key)`"
                if let json = try? json.jsonForKeyPath(keyPath) {
                    string = "\(string) in JSON : `\(json.object)`"
                }
                string = "\(string). Full keyPath `\(keyPath)`"
                return string
            case .TypeMismatch(let expected, let actual, let keyPath):
                var string = "TypeMismatch, expected `\(expected)`"
                if let json = try? json.jsonForKeyPath(keyPath) {
                    string = "\(string) got `(\(json))`"
                } else {
                    string = "\(string) got `\(actual)`"
                }
                string = "\(string). Full keyPath `\(keyPath)`"
                return string
            }
        }
    }
}
