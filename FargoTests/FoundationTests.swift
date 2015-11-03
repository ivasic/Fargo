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
        let json = JSON(object: "string")
		do {
			let a: String = try json.decode()
			XCTAssertEqual(a, "string")
		} catch {
			XCTFail("Failed decoding String \(error)")
		}
	}
	
	func testDecodingErrorString() {
		let json = JSON(object: 0)
		do {
			let a: String = try json.decode()
			XCTFail("Expected DecodeError, got valid object: \(a)")
		} catch {
			XCTAssert(error is JSON.Error)
		}
	}
	
	func testDecodingBool() {
		let json = JSON(object: true)
		do {
			let a: Bool = try json.decode()
			XCTAssertEqual(a, true)
		} catch {
			XCTFail("Failed decoding Bool \(error)")
		}
	}
	
	func testDecodingErrorBool() {
		let json = JSON(object: "s")
		do {
			let a: Bool = try json.decode()
			XCTFail("Expected DecodeError, got valid object: \(a)")
		} catch {
			XCTAssert(error is JSON.Error)
		}
	}
	
	func testDecodingFloat() {
		let json = JSON(object: 0)
		do {
			let a: Float = try json.decode()
			XCTAssertEqual(a, 0)
		} catch {
			XCTFail("Failed decoding Float \(error)")
		}
	}
	
	func testDecodingErrorFloat() {
		let json = JSON(object: "0")
		do {
			let a: Float = try json.decode()
			XCTFail("Expected JSON.Error, got valid object: \(a)")
		} catch {
			XCTAssert(error is JSON.Error)
		}
	}
	
	func testDecodingDouble() {
		let json = JSON(object: 0)
		do {
			let a: Double = try json.decode()
			XCTAssertEqual(a, 0)
		} catch {
			XCTFail("Failed decoding Double \(error)")
		}
	}
	
	func testDecodingErrorDouble() {
		let json = JSON(object: "0")
		do {
			let a: Double = try json.decode()
			XCTFail("Expected JSON.Error, got valid object: \(a)")
		} catch {
			XCTAssert(error is JSON.Error)
		}
	}
	
	func testDecodingInt() {
		let json = JSON(object: 0)
		do {
			let a: Int = try json.decode()
			XCTAssertEqual(a, 0)
		} catch {
			XCTFail("Failed decoding Int \(error)")
		}
	}
	
	func testDecodingErrorInt() {
		let json = JSON(object: "0")
		do {
			let a: Int = try json.decode()
			XCTFail("Expected JSON.Error, got valid object: \(a)")
		} catch {
			XCTAssert(error is JSON.Error)
		}
	}
	
	func testDecodingUInt() {
		let json = JSON(object: 0)
		do {
			let a: UInt = try json.decode()
			XCTAssertEqual(a, 0)
		} catch {
			XCTFail("Failed decoding UInt \(error)")
		}
	}
	
	func testDecodingErrorUInt() {
		let json = JSON(object: "0")
		do {
			let a: UInt = try json.decode()
			XCTFail("Expected JSON.Error, got valid object: \(a)")
		} catch {
			XCTAssert(error is JSON.Error)
		}
	}
}
