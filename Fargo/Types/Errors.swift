//
//  Errors.swift
//  Fargo
//
//  Created by Ivan Vasic on 31/05/15.
//  Copyright (c) 2015 Ivan Vasic. All rights reserved.
//

import Foundation

public let FargoErrorDomain = "com.fargo.error"

public enum FargoErrorCode: Int {
	case MissingKey		= 0
	case TypeMismatch	= 1
}