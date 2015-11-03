//
//  Decodable.swift
//  Fargo
//
//  Created by Ivan Vasic on 01/11/15.
//  Copyright © 2015 Ivan Vasic. All rights reserved.
//

import Foundation

public protocol Decodable {
    static func decode(json: JSON) throws -> Self
}

public protocol PrimitiveDecodable: Decodable { }

extension PrimitiveDecodable {
    public static func decode(json: JSON) throws -> Self {
        guard let obj = json.object as? Self else {
            throw JSON.Error.TypeMismatch(expectedType: String(Self.self), actualType: json.objectType(), keyPath: json.keyPath)
        }
        return obj
    }
}