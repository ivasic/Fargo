//
//  JSONTests.swift
//  Fargo
//
//  Created by Ivan Vasic on 25/07/15.
//  Copyright © 2015 Ivan Vasic. All rights reserved.
//

import XCTest
@testable import Fargo

class JSONTests: XCTestCase {
	
	func testConvertObject() {
		let json = ["key": "value"]
		let j = JSON.convert(json)
		
		switch j {
		case .Object(let o):
			XCTAssertEqual(o.count, 1)
		default:
			XCTFail("Expected object got \(j) instead.")
		}
	}
	
	func testConvertArray() {
		let json = [1, 2, 3, 4, 5]
		let j = JSON.convert(json)
		
		switch j {
		case .Array(let a):
			XCTAssertEqual(a.count, 5)
		default:
			XCTFail("Expected array got \(j) instead.")
		}
	}
	
	func testConvertString() {
		let json = "string"
		let j = JSON.convert(json)
		
		switch j {
		case .String(let str):
			XCTAssertEqual(str, "string")
		default:
			XCTFail("Expected string got \(j) instead.")
		}
	}
	
	func testConvertNumber() {
		let json = 1
		let j = JSON.convert(json)
		
		switch j {
		case .Number(let num):
			XCTAssertEqual(num, 1)
		default:
			XCTFail("Expected number got \(j) instead.")
		}
	}
	
	func testConvertInvalidObject() {
		let json = NSObject()
		let j = JSON.convert(json)
		
		switch j {
		case .Null:
			break
		default:
			XCTFail("Expected null got \(j) instead.")
		}
	}
	
	// MARK: - Description
	
	func testDescription() {
		XCTAssertEqual(JSON.convert("s").description, "String(s)")
		XCTAssertEqual(JSON.convert(0).description, "Number(0)")
		XCTAssertEqual(JSON.convert(NSObject()).description, "Null")
		XCTAssertEqual(JSON.convert([0]).description, "Array([Number(0)])")
		XCTAssertEqual(JSON.convert(["key":"value"]).description, "Object([key: String(value)])")
	}
	
	// MARK: - Decodes
	
	func testDecodeType() {
		let json = JSON.convert("string")
		do {
			let str: String = try json.decode()
			XCTAssertEqual(str, "string")
		} catch {
			XCTFail("\(error)")
		}
	}
	
	func testDecodeTypeArray() {
		let json = JSON.convert([1, 2, 3])
		do {
			let a: [Int] = try json.decode()
			XCTAssertEqual(a, [1, 2, 3])
		} catch {
			XCTFail("\(error)")
		}
	}
	
	func testDecodeIncoherentArray() {
		let json = JSON.convert(["1", 2, 3])
		do {
			let a: [Int] = try json.decode()
			XCTFail("Expected DecodeError, got valid array: \(a)")
		} catch {
			if case DecodeError.TypeMismatch(_) = error {
				// all good
			} else {
				XCTFail("Expected DecodeError.TypeMismatch, got \(error)")
			}
		}
	}
	
	func testDecodeInvalidTypeArray() {
		let json = JSON.convert("string")
		do {
			let a: [Int] = try json.decode()
			XCTFail("Expected DecodeError, got valid array: \(a)")
		} catch {
			if case DecodeError.TypeMismatch(_) = error {
				// all good
			} else {
				XCTFail("Expected DecodeError.TypeMismatch, got \(error)")
			}
		}
	}
	
	// MARK: - Objects
	
	func testDecodeObjectValue() {
		let json = JSON.convert(["key" : "string"])
		do {
			let a: String = try json.value("key")
			XCTAssertEqual(a, "string")
		} catch {
			XCTFail("Decoding error: \(error)")
		}
	}
	
	func testDecodeObjectValueInvalidType() {
		let json = JSON.convert(0)
		do {
			let a: Int = try json.value("key")
			XCTFail("Expeced DecodingError.TypeMismatch got valid obj \(a)")
		} catch {
			if case DecodeError.TypeMismatch(_) = error {
				// all good
			} else {
				XCTFail("Expected DecodeError.TypeMismatch, got \(error)")
			}
		}
	}
	
	func testDecodeObjectValueWithTransform() {
		let json = JSON.convert(["key" : 0])
		let transform: (Int -> Float) = { Float($0) }
		do {
			let a: Float = try json.value("key", transform: transform)
			XCTAssertEqual(a, 0)
		} catch {
			XCTFail("Decoding error: \(error)")
		}
	}
	
	func testDecodeObjectValueWithTransformToOptional() {
		let json = JSON.convert(["key" : 0])
		let transform: (Int -> Float?) = { Float($0) }
		do {
			let a: Float? = try json.value("key", transform: transform)
			XCTAssert(a == 0)
		} catch {
			XCTFail("Decoding error: \(error)")
		}
	}
	
	func testDecodeObjectValueWithTransformToOptionalNone() {
		let json = JSON.convert([:])
		let transform: (Int -> Float?) = { Float($0) }
		do {
			let a: Float? = try json.value("key", transform: transform)
			XCTAssert(a == .None)
		} catch {
			XCTFail("Decoding error: \(error)")
		}
	}
	
	func testDecodeNestedObjectValueWithTransform() {
		let json = JSON.convert(["parent" : ["key": "1"]])
		let transform: (String -> Int) = { $0.characters.count }
		do {
			let a: Int = try json.value(["parent", "key"], transform: transform)
			XCTAssertEqual(a, 1)
		} catch {
			XCTFail("Decoding error: \(error)")
		}
	}
	
	func testDecodeNestedObjectValueWithTransformToOptional() {
		let json = JSON.convert(["parent" : ["key": "1"]])
		let transform: (String -> Int?) = { $0.characters.count }
		do {
			let a: Int? = try json.value(["parent", "key"], transform: transform)
			XCTAssert(a == 1)
		} catch {
			XCTFail("Decoding error: \(error)")
		}
	}
	
	func testDecodeNestedObjectValueWithTransformToOptionalNone() {
		let json = JSON.convert(["parent" : [:]])
		let transform: (String -> Int?) = { $0.characters.count }
		do {
			let a: Int? = try json.value(["parent", "key"], transform: transform)
			XCTAssert(a == .None)
		} catch {
			XCTFail("Decoding error: \(error)")
		}
	}
	
	// MARK: - Arrays
	
	func testDecodeArrayValue() {
		let json = JSON.convert(["key": [true, false, true]])
		do {
			let a: [Bool] = try json.value("key")
			XCTAssertEqual(a, [true, false, true])
		} catch {
			XCTFail("Decoding error: \(error)")
		}
	}
	
	func testDecodeArrayValueOptional() {
		let json = JSON.convert(["key": [true, false, true]])
		do {
			let a: [Bool]? = try json.value("key")
			XCTAssertTrue((a ?? []) == [true, false, true])
		} catch {
			XCTFail("Decoding error: \(error)")
		}
	}
	
	func testDecodeArrayValueOptionalNone() {
		let json = JSON.convert([:])
		do {
			let a: [Bool]? = try json.value("key")
			XCTAssertNil(a)
		} catch {
			XCTFail("Decoding error: \(error)")
		}
	}
	
	func testDecodeNestedArrayValue() {
		let json = JSON.convert(["parent": ["key": [true, false, true]]])
		do {
			let a: [Bool] = try json.value(["parent", "key"])
			XCTAssertEqual(a, [true, false, true])
		} catch {
			XCTFail("Decoding error: \(error)")
		}
	}
	
	func testDecodeNestedArrayValueOptional() {
		let json = JSON.convert(["parent": ["key": [true, false, true]]])
		do {
			let a: [Bool]? = try json.value(["parent", "key"])
			XCTAssertTrue((a ?? []) == [true, false, true])
		} catch {
			XCTFail("Decoding error: \(error)")
		}
	}
	
	func testDecodeNestedArrayValueOptionalNone() {
		let json = JSON.convert([:])
		do {
			let a: [Bool]? = try json.value(["parent", "key"])
			XCTAssertNil(a)
		} catch {
			XCTFail("Decoding error: \(error)")
		}
	}

}
