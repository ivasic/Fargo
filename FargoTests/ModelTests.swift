//
//  ModelTests.swift
//  FargoTests
//
//  Created by Ivan Vasic on 31/05/15.
//  Copyright (c) 2015 Ivan Vasic. All rights reserved.
//

import UIKit
import XCTest
import Fargo

class ModelTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
	}
	
	func testSimpleModelDecoding() {
		let j = ["reqInt" : 42,
			"reqStr" : "test",
			"reqBool" : true,
			"optStr" : "optional",
			"optInt" : 2,
			"optBool" : false]
		let json = JSON.encode(j)
		
		if let m: SimpleModel = json.decode() {
			XCTAssertEqual(m.reqInt, 42)
			XCTAssertEqual(m.reqStr, "test")
			XCTAssertEqual(m.reqBool, true)
			XCTAssertEqual(m.optStr!, "optional")
			XCTAssertEqual(m.optInt!, 2)
			XCTAssertEqual(m.optBool!, false)
		} else {
			XCTFail("SimpleModel could not be decoded")
		}
	}

	func testSimpleModelOptionalNullDecoding() {
		let j = ["reqInt" : 42,
			"reqStr" : "test",
			"reqBool" : true
		]
		let json = JSON.encode(j)
		
		if let m: SimpleModel = json.decode() {
			XCTAssertEqual(m.reqInt, 42)
			XCTAssertEqual(m.reqStr, "test")
			XCTAssertEqual(m.reqBool, true)
			XCTAssertNil(m.optStr)
			XCTAssertNil(m.optInt)
			XCTAssertNil(m.optBool)
		} else {
			XCTFail("SimpleModel could not be decoded")
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
		
		let json = JSON.encode(nested)
		
		if let m: NestedModel = json.decode() {
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
		} else {
			XCTFail("NestedModel could not be decoded")
		}
	}
	
	
	func testNestedModelNullDecoding() {
		
		let s1 = ["reqInt" : 42,
			"reqStr" : "test",
			"reqBool" : true]
		let s2 = ["reqInt" : 24,
			"reqStr" : "tset",
			"reqBool" : false]
		
		let nested = ["reqInt" : 242,
			"reqStr" : "nested",
			"reqSimpleModel": s1]
		
		let json = JSON.encode(nested)
		
		if let m: NestedModel = json.decode() {
			XCTAssertEqual(m.reqInt, 242)
			XCTAssertEqual(m.reqStr, "nested")
			XCTAssertEqual(m.reqSimpleModel.reqInt, 42)
			XCTAssertEqual(m.reqSimpleModel.reqStr, "test")
			XCTAssertEqual(m.reqSimpleModel.reqBool, true)
			XCTAssertNil(m.reqSimpleModel.optInt)
			XCTAssertNil(m.reqSimpleModel.optStr)
			XCTAssertNil(m.reqSimpleModel.optBool)
			XCTAssertTrue(m.optSimpleModel == nil)
		} else {
			XCTFail("NestedModel could not be decoded")
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
		
		let json = JSON.encode(collections)
		
		if let m: CollectionsModel = json.decode() {
			XCTAssertEqual(m.reqIntArray, [1, 2, 3])
			XCTAssertEqual(m.reqStrArray, ["1", "2", "3"])
			XCTAssertEqual(m.reqBoolArray, [true, true, false])
			XCTAssertEqual(m.optStrArray ?? [], ["3", "2", "1"])
			XCTAssertEqual(m.optIntArray ?? [], [3, 2, 1])
			XCTAssertEqual(m.optBoolArray ?? [], [false, false, true])
			XCTAssertEqual(m.optSimpleModelArray?.first?.optInt ?? 0, 2)
			XCTAssertEqual(m.optSimpleModelArray?.last?.optInt ?? 0, 2)
		} else {
			XCTFail("CollectionsModel could not be decoded")
		}
	}
	
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
}
