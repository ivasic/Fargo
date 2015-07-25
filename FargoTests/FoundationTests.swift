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
	
	func testDecodingString() {
		let json = JSON.convert("string")
		do {
			let a: String = try json.decode()
			XCTAssertEqual(a, "string")
		} catch {
			XCTFail("Failed decoding String \(error)")
		}
	}
	
	func testDecodingErrorString() {
		let json = JSON.convert(0)
		do {
			let a: String = try json.decode()
			XCTFail("Expected DecodeError, got valid object: \(a)")
		} catch {
			XCTAssert(error is DecodeError)
		}
	}
	
	func testDecodingBool() {
		let json = JSON.convert(true)
		do {
			let a: Bool = try json.decode()
			XCTAssertEqual(a, true)
		} catch {
			XCTFail("Failed decoding Bool \(error)")
		}
	}
	
	func testDecodingErrorBool() {
		let json = JSON.convert("s")
		do {
			let a: Bool = try json.decode()
			XCTFail("Expected DecodeError, got valid object: \(a)")
		} catch {
			XCTAssert(error is DecodeError)
		}
	}
	
	func testDecodingFloat() {
		let json = JSON.convert(0)
		do {
			let a: Float = try json.decode()
			XCTAssertEqual(a, 0)
		} catch {
			XCTFail("Failed decoding Float \(error)")
		}
	}
	
	func testDecodingErrorFloat() {
		let json = JSON.convert("0")
		do {
			let a: Float = try json.decode()
			XCTFail("Expected DecodeError, got valid object: \(a)")
		} catch {
			XCTAssert(error is DecodeError)
		}
	}
	
	func testDecodingDouble() {
		let json = JSON.convert(0)
		do {
			let a: Double = try json.decode()
			XCTAssertEqual(a, 0)
		} catch {
			XCTFail("Failed decoding Double \(error)")
		}
	}
	
	func testDecodingErrorDouble() {
		let json = JSON.convert("0")
		do {
			let a: Double = try json.decode()
			XCTFail("Expected DecodeError, got valid object: \(a)")
		} catch {
			XCTAssert(error is DecodeError)
		}
	}
	
	func testDecodingInt() {
		let json = JSON.convert(0)
		do {
			let a: Int = try json.decode()
			XCTAssertEqual(a, 0)
		} catch {
			XCTFail("Failed decoding Int \(error)")
		}
	}
	
	func testDecodingErrorInt() {
		let json = JSON.convert("0")
		do {
			let a: Int = try json.decode()
			XCTFail("Expected DecodeError, got valid object: \(a)")
		} catch {
			XCTAssert(error is DecodeError)
		}
	}
	
	func testDecodingUInt() {
		let json = JSON.convert(0)
		do {
			let a: UInt = try json.decode()
			XCTAssertEqual(a, 0)
		} catch {
			XCTFail("Failed decoding UInt \(error)")
		}
	}
	
	func testDecodingErrorUInt() {
		let json = JSON.convert("0")
		do {
			let a: UInt = try json.decode()
			XCTFail("Expected DecodeError, got valid object: \(a)")
		} catch {
			XCTAssert(error is DecodeError)
		}
	}
}
