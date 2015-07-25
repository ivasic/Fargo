//
//  FoundationTests.swift
//  Fargo
//
//  Created by Ivan Vasic on 25/07/15.
//  Copyright © 2015 Ivan Vasic. All rights reserved.
//

import XCTest
import Fargo

class FoundationTests: XCTestCase {
    
	func testDecodingErrorString() {
		let j = ["s" : 1]
		let json = JSON.convert(j)
		do {
			let _: String = try json.value("s")
		} catch {
			XCTAssert(error is DecodeError)
		}
    }
	
	func testDecodingErrorInt() {
		let j = ["s" : "s"]
		let json = JSON.convert(j)
		do {
			let _: Int = try json.value("s")
		} catch {
			XCTAssert(error is DecodeError)
		}
	}
	
	func testDecodingErrorBool() {
		let j = ["s" : "s"]
		let json = JSON.convert(j)
		do {
			let _: Bool = try json.value("s")
		} catch {
			XCTAssert(error is DecodeError)
		}
	}
}
