//
//  ExampleTests.swift
//  Fargo
//
//  Created by Ivan Vasic on 26/07/15.
//  Copyright © 2015 Ivan Vasic. All rights reserved.
//

import XCTest
import Fargo

class ExampleTests: XCTestCase {
	func testExampleModel() {
		let json = ["id": 1, "text": "text", "date": "2015-07-26", "url": "http://www.github.com", "tags": ["tag1", "tag2"]]
		
		do {
			let model: ExampleModel = try JSON.convert(json).decode()
			XCTAssertEqual(model.id, 1)
			XCTAssert(model.text == "text")
			XCTAssert(model.url?.isEqual(NSURL(string: "http://www.github.com")!) ?? false)
			XCTAssertEqual(model.tags, ["tag1", "tag2"])
		} catch {
			XCTFail("Decoding ExampleModel failed with error: \(error)")
		}
	}
}