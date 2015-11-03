//
//  JSONTests.swift
//  Fargo
//
//  Created by Ivan Vasic on 03/11/15.
//  Copyright © 2015 Ivan Vasic. All rights reserved.
//

import XCTest
@testable import Fargo

class JSONTests: XCTestCase {
    
    func testObjectType() {
        // Given
        let json = JSON(object: 0)
        
        // When
        let type = json.objectType()
        
        // Then
        XCTAssertEqual(type, "__NSCFNumber")
    }
    
    func testNextKeyPathKey() {
        // Given
        let json = JSON(object: 0)
        
        // When
        let keyPath = json.nextKeyPath("subpath")
        
        // Then
        XCTAssertEqual(keyPath.path.count, 1)
        switch keyPath.path.first! {
        case .Key(let string): XCTAssertEqual(string, "subpath")
        default: XCTFail()
        }
    }
    
    func testNextKeyPathIndex() {
        // Given
        let json = JSON(object: 0)
        
        // When
        let keyPath = json.nextKeyPath(5)
        
        // Then
        XCTAssertEqual(keyPath.path.count, 1)
        switch keyPath.path.first! {
        case .Index(let index): XCTAssertEqual(index, 5)
        default: XCTFail()
        }
    }
    
    func testJsonForKeyPath() {
        // Given
        let json = JSON(object: ["0": [0, 1]])
        let keyPath = JSON.KeyPath(path: [.Key("0"), .Index(1)])
        
        // When
        let result = try? json.jsonForKeyPath(keyPath)
        let object = result?.object as? Int
        
        // Then
        XCTAssertNotNil(result)
        XCTAssertEqual(object ?? -1, 1)
    }
    
    func testJsonForKeyPathThrows() {
        // Given
        let json = JSON(object: ["0": [0, 1]])
        let keyPath = JSON.KeyPath(path: [.Key("0"), .Index(3)])
        
        // When
        do {
            try json.jsonForKeyPath(keyPath)
            XCTFail("Expected the method to throw")
        } catch {
            // Then
            XCTAssertTrue(error is JSON.Error)
        }
    }
    
    func testJsonForKeyString() {
        // Given
        let json = JSON(object: ["0": "0"])
        
        // When
        let result = try? json.jsonForKey("0")
        let object = result?.object as? String
        
        // Then
        XCTAssertNotNil(result)
        XCTAssertEqual(object ?? "", "0")
    }
    
    func testJsonForKeyStringMissingKey() {
        // Given
        let json = JSON(object: ["0": "0"])
        
        // When
        do {
            let _: JSON = try json.jsonForKey("1")
            XCTFail("Expected the method to throw")
        } catch {
            // Then
            XCTAssertTrue(error is JSON.Error)
        }
    }
    
    func testJsonForKeyStringNonObject() {
        // Given
        let json = JSON(object: ["0"])
        
        // When
        do {
            let _: JSON = try json.jsonForKey("0")
            XCTFail("Expected the method to throw")
        } catch {
            // Then
            XCTAssertTrue(error is JSON.Error)
        }
    }
    
    func testJsonForKeyStringOptional() {
        // Given
        let json = JSON(object: ["0": "0"])
        
        // When
        do {
            let result: JSON? = try json.jsonForKey("1")
            // Then
            XCTAssertNil(result)
        } catch {
            XCTFail("Method should not throw")
        }
    }
    
    func testJsonForKeyIndex() {
        // Given
        let json = JSON(object: ["0"])
        
        // When
        let result = try? json.jsonAtIndex(0)
        let object = result?.object as? String
        
        // Then
        XCTAssertNotNil(result)
        XCTAssertEqual(object ?? "", "0")
    }
    
    func testJsonForKeyIndexNonArray() {
        // Given
        let json = JSON(object: ["0":"1"])
        
        // When
        do {
            try json.jsonAtIndex(0)
            XCTFail("Expected the method to throw")
        } catch {
            // Then
            XCTAssertTrue(error is JSON.Error)
        }
    }
    
    func testJsonForKeyIndexArrayOutOfBounds() {
        // Given
        let json = JSON(object: ["0"])
        
        // When
        do {
            try json.jsonAtIndex(1)
            XCTFail("Expected the method to throw")
        } catch {
            // Then
            XCTAssertTrue(error is JSON.Error)
        }
    }
    
    func testJsonForKeys() {
        // Given
        let json = JSON(object: ["0": ["1": 1]])
        
        // When
        let result = try? json.jsonForKeys(["0", "1"])
        let object = result?.object as? Int
        
        // Then
        XCTAssertNotNil(result)
        XCTAssertEqual(object ?? 0, 1)
    }
    
    func testJsonForKeysOptional() {
        // Given
        let json = JSON(object: ["0": ["1": 1]])
        
        // When
        do {
            let result: JSON? = try json.jsonForKeys(["0", "2"])
            // Then
            XCTAssertNil(result)
        } catch {
            XCTFail("Method should not throw")
        }
    }
}

// MARK: - CustomDebugStringConvertible tests

extension JSONTests {
    
    func testDebugDescriptionPrimitive() {
        // Given
        let json = JSON(object: 1)
        
        // When
        let description = json.debugDescription
        
        // Then
        XCTAssertEqual(description, "__NSCFNumber (1)")
    }
    
    func testDebugDescriptionArray() {
        // Given
        let json = JSON(object: [0, 1])
        
        // When
        let description = json.debugDescription
        
        // Then
        XCTAssertEqual(description, "Array<__NSCFNumber> (2)")
    }
    
    func testDebugDescriptionEmptyArray() {
        // Given
        let json = JSON(object: [])
        
        // When
        let description = json.debugDescription
        
        // Then
        XCTAssertEqual(description, "Array (empty)")
    }
    
    func testDebugDescriptionObject() {
        // Given
        let json = JSON(object: ["key": "value"])
        
        // When
        let description = json.debugDescription
        
        // Then
        XCTAssertEqual(description, "Object (1)")
    }
}
