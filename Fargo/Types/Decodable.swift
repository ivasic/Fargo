//
//  Decodable.swift
//  Fargo
//
//  Created by Ivan Vasic on 20/06/15.
//  Copyright © 2015 Ivan Vasic. All rights reserved.
//

import Foundation

public protocol Decodable {
	static func decode(json: JSON) throws -> Self
}