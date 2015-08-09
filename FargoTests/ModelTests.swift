//
//  ModelTests.swift
//  Fargo
//
//  Created by Ivan Vasic on 20/06/15.
//  Copyright © 2015 Ivan Vasic. All rights reserved.
//

import XCTest
import Fargo

class ModelTests: XCTestCase {

    func testSimpleModel() {
		let j = ["reqInt" : 42, "reqStr" : "test", "reqBool" : true, "optStr" : "optional", "optInt" : 2, "optBool" : false]
		let json = JSON.convert(j)
		
		do {
			let m: SimpleModel = try json.decode()
			XCTAssertEqual(m.reqInt, 42)
			XCTAssertEqual(m.reqStr, "test")
			XCTAssertEqual(m.reqBool, true)
			XCTAssertEqual(m.optStr!, "optional")
			XCTAssertEqual(m.optInt!, 2)
			XCTAssertEqual(m.optBool!, false)
		} catch {
			XCTFail("SimpleModel could not be decoded: \(error)")
		}
	}
	
	func testSimpleModelOptionalNullDecoding() {
		let j = ["reqInt" : 42, "reqStr" : "test", "reqBool" : true]
		let json = JSON.convert(j)
		
		do {
			let m: SimpleModel = try json.decode()
			XCTAssertEqual(m.reqInt, 42)
			XCTAssertEqual(m.reqStr, "test")
			XCTAssertEqual(m.reqBool, true)
			XCTAssertNil(m.optStr)
			XCTAssertNil(m.optInt)
			XCTAssertNil(m.optBool)
		} catch {
			XCTFail("SimpleModel could not be decoded: \(error)")
		}
	}

	func testNestedModelDecoding() {
		let s1 = ["reqInt" : 42,
			"reqStr" : "test",
			"reqBool" : true,
			"optStr" : "optional",
			"optInt" : 2,
			"optBool" : false]
		let s2 = ["reqInt" : 24,
			"reqStr" : "tset",
			"reqBool" : false,
			"optStr" : "lanoitpo",
			"optInt" : 1,
			"optBool" : true]
		
		let nested = ["reqInt" : 242,
			"reqStr" : "nested",
			"reqSimpleModel": s1,
			"optSimpleModel": s2]
		
		let json = JSON.convert(nested)
		
		do {
			let m: NestedModel = try json.decode()
			XCTAssertEqual(m.reqInt, 242)
			XCTAssertEqual(m.reqStr, "nested")
			XCTAssertEqual(m.reqSimpleModel.reqInt, 42)
			XCTAssertEqual(m.reqSimpleModel.reqStr, "test")
			XCTAssertEqual(m.reqSimpleModel.reqBool, true)
			XCTAssertEqual(m.reqSimpleModel.optInt ?? 0, 2)
			XCTAssertEqual(m.reqSimpleModel.optStr ?? "", "optional")
			XCTAssertEqual(m.reqSimpleModel.optBool ?? true, false)
			XCTAssertEqual(m.optSimpleModel?.reqInt ?? 0, 24)
			XCTAssertEqual(m.optSimpleModel?.reqStr ?? "", "tset")
			XCTAssertEqual(m.optSimpleModel?.reqBool ?? true, false)
			XCTAssertEqual(m.optSimpleModel?.optInt ?? 0, 1)
			XCTAssertEqual(m.optSimpleModel?.optStr ?? "", "lanoitpo")
			XCTAssertEqual(m.optSimpleModel?.optBool ?? false, true)
		} catch {
			XCTFail("NestedModel could not be decoded: \(error)")
		}
	}

	func testNestedModelNullDecoding() {
		let s1 = ["reqInt" : 42,
			"reqStr" : "test",
			"reqBool" : true]
		
		let nested = ["reqInt" : 242,
			"reqStr" : "nested",
			"reqSimpleModel": s1]
		
		let json = JSON.convert(nested)
		
		do {
			let m: NestedModel = try json.decode()
			XCTAssertEqual(m.reqInt, 242)
			XCTAssertEqual(m.reqStr, "nested")
			XCTAssertEqual(m.reqSimpleModel.reqInt, 42)
			XCTAssertEqual(m.reqSimpleModel.reqStr, "test")
			XCTAssertEqual(m.reqSimpleModel.reqBool, true)
			XCTAssertNil(m.reqSimpleModel.optInt)
			XCTAssertNil(m.reqSimpleModel.optStr)
			XCTAssertNil(m.reqSimpleModel.optBool)
			XCTAssertTrue(m.optSimpleModel == nil)
		} catch {
			XCTFail("NestedModel could not be decoded: \(error)")
		}
	}
	
	func testCollectionsModelDecoding() {
		let s1 = ["reqInt" : 42,
			"reqStr" : "test",
			"reqBool" : true,
			"optStr" : "optional",
			"optInt" : 2,
			"optBool" : false]
		
		let collections: [String: AnyObject] = ["reqInt" : [1, 2, 3],
			"reqStr" : ["1", "2", "3"],
			"reqBool" : [true, true, false],
			"optStr" : ["3", "2", "1"],
			"optInt" : [3, 2, 1],
			"optBool" : [false, false, true],
			"optSimpleModel": [s1, s1, s1]
		]
		
		let json = JSON.convert(collections)
		
		do {
			let m: CollectionsModel = try json.decode()
			XCTAssertEqual(m.reqIntArray, [1, 2, 3])
			XCTAssertEqual(m.reqStrArray, ["1", "2", "3"])
			XCTAssertEqual(m.reqBoolArray, [true, true, false])
			XCTAssertEqual(m.optStrArray ?? [], ["3", "2", "1"])
			XCTAssertEqual(m.optIntArray ?? [], [3, 2, 1])
			XCTAssertEqual(m.optBoolArray ?? [], [false, false, true])
			XCTAssertEqual(m.optSimpleModelArray?.first?.optInt ?? 0, 2)
			XCTAssertEqual(m.optSimpleModelArray?.last?.optInt ?? 0, 2)
		} catch {
			XCTFail("CollectionsModel could not be decoded: \(error)")
		}
	}
	
	func testEmbeddedObjectsDecoding() {
		let j = ["embedded" : ["int": 42, "inner": ["string": "test"]]]
		let json = JSON.convert(j)
		
		
		do {
			let m: SimpleEmbedded = try json.decode()
			XCTAssertEqual(m.int, 42)
			XCTAssertEqual(m.str ?? "", "test")
		} catch {
			XCTFail("SimpleModel could not be decoded: \(error)")
		}
	}
	
	func testEmbeddedObjectsNullDecoding() {
		let j = ["embedded" : ["int": 42]]
		let json = JSON.convert(j)
		
		do {
			let m: SimpleEmbedded = try json.decode()
			XCTAssertEqual(m.int, 42)
			XCTAssertNil(m.str)
		} catch {
			XCTFail("SimpleModel could not be decoded: \(error)")
		}
	}
	
	func testEmbeddedCollectionsDecoding() {
		let j: [String: AnyObject] = ["embedded" : ["ints": [42, 1, 2], "bools": [true, false], "strs": ["1", "2"]]]
		let json = JSON.convert(j)
		
		do {
			let m: CollectionsEmbedded = try json.decode()
			XCTAssertEqual(m.ints, [42,1,2])
			XCTAssertEqual(m.bools ?? [], [true, false])
			XCTAssertEqual(m.strs ?? [], ["1", "2"])
		} catch {
			XCTFail("CollectionsEmbedded could not be decoded: \(error)")
		}
	}
	
	func testEmbeddedCollectionsNullDecoding() {
		let j: [String: AnyObject] = ["embedded" : ["ints": [42, 1, 2], "strs": NSNull()]]
		let json = JSON.convert(j)
		
		do {
			let m: CollectionsEmbedded = try json.decode()
			XCTAssertEqual(m.ints, [42,1,2])
			XCTAssertNil(m.bools)
			XCTAssertNil(m.strs)
		} catch {
			XCTFail("CollectionsEmbedded could not be decoded: \(error)")
		}
	}
	
	func testOptionalTransform() {
		let j = ["number" : "42"]
		let json = JSON.convert(j)
		
		do {
			let m: TransformsModel2 = try json.decode()
			XCTAssertEqual(m.number, 42)
		} catch {
			XCTFail("TransformsModel2 could not be decoded: \(error)")
		}
	}
	
	func testOptionalTransformFail() {
		let j = ["number" : "text"]
		let json = JSON.convert(j)
		
		do {
			let m: TransformsModel2 = try json.decode()
			XCTFail("Should not have succeeded. Got model: \(m)")
		} catch {
			if case DecodeError.TypeMismatch(_) = error {
				// all good
			} else {
				XCTFail("Expected DecodeError.TypeMismatch, got \(error)")
			}
		}
	}
}
