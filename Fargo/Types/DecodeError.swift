//
//  DecodeError.swift
//  Fargo
//
//  Created by Ivan Vasic on 20/06/15.
//  Copyright © 2015 Ivan Vasic. All rights reserved.
//

import Foundation

public enum DecodeError : ErrorType {
	case MissingKey(String)
	case TypeMismatch(String)
}