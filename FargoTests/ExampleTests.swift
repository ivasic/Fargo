//
//  ExampleTests.swift
//  Fargo
//
//  Created by Ivan Vasic on 26/07/15.
//  Copyright © 2015 Ivan Vasic. All rights reserved.
//

import XCTest
import Fargo

class ExampleTests: XCTestCase { }

// MARK: - ExampleModel

extension ExampleTests {
    
	func testExampleModel() {
		let json = ["id": 1, "text": "text", "date": "2015-07-26", "url": "http://www.github.com", "tags": ["tag1", "tag2"]]
		
		do {
            let model: ExampleModel = try JSON(object: json).decode()
			XCTAssertEqual(model.id, 1)
			XCTAssert(model.text == "text")
			XCTAssert(model.url?.isEqual(NSURL(string: "http://www.github.com")!) ?? false)
			XCTAssertEqual(model.tags, ["tag1", "tag2"])
		} catch {
			XCTFail("Decoding ExampleModel failed with error: \(error)")
		}
	}
}

// MARK: - Read World Example

extension ExampleTests {
    
    func testRealWorldModel() {
        // Given
        let json = ["id": "1", "email": "someone@somewhere.comething", "profile": ["name": "John Doe", "age": 32, "avatar": "http://placehold.it/100x100", "lastLogin": "2015-11-11"], "status": 1, "permissions": [0,2] ]
        
        // When
        let user: User? = try? JSON(object: json).decode()
        
        // Then
        XCTAssertNotNil(user)
    }
    
}