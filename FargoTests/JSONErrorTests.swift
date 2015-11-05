//
//  JSONErrorTests.swift
//  Fargo
//
//  Created by Ivan Vasic on 03/11/15.
//  Copyright © 2015 Ivan Vasic. All rights reserved.
//

import XCTest
import Fargo

class JSONErrorTests: XCTestCase {
    
    func testInitMissingKey() {
        // Given
        let json = JSON(object: 0)
        
        // When
        let error = JSON.Error(missingKey: .Key("key"), json: json)
        
        // Then
        XCTAssertEqual(error.debugDescription, "MissingKey `Key(\"key\")` in keyPath `/`")
    }
    
    func testInitTypeMismatch() {
        // Given
        let json = JSON(object: 0)
        
        // When
        let error = JSON.Error(typeMismatchForType: "String", json: json)
        
        // Then
        XCTAssertEqual(error.debugDescription, "TypeMismatch, expected `String` got `__NSCFNumber` for keyPath `/`")
    }
    
    func testDebugDescriptionMissingKey() {
        // Given
        let error = JSON.Error.MissingKey(key: .Key("key"), keyPath: JSON.KeyPath())
        
        // When
        let description = error.debugDescription
        
        // Then
        XCTAssertEqual(description, "MissingKey `Key(\"key\")` in keyPath `/`")
    }
    
    func testDebugDescriptionMissingKeyIndex() {
        // Given
        let error = JSON.Error.MissingKey(key: .Index(0), keyPath: JSON.KeyPath())
        
        // When
        let description = error.debugDescription
        
        // Then
        XCTAssertEqual(description, "MissingKey `Index(0)` in keyPath `/`")
    }
    
    func testDebugDescriptionTypeMismatch() {
        // Given
        let error = JSON.Error.TypeMismatch(expectedType: "Int", actualType: "String", keyPath: JSON.KeyPath())
        
        // When
        let description = error.debugDescription
        
        // Then
        XCTAssertEqual(description, "TypeMismatch, expected `Int` got `String` for keyPath `/`")
    }
    
    // MARK: - Description for JSON
    
    func testDebugDescriptionForJSONForMissingKey() {
        // Given
        let json = JSON(object: ["somekey": "somevalue"])
        let error = JSON.Error.MissingKey(key: .Key("key"), keyPath: JSON.KeyPath())
        
        // When
        let description = error.descriptionForJSON(json)
        
        // Then
        XCTAssertTrue(description.hasPrefix("MissingKey `Key(\"key\")` in JSON :"))
        XCTAssertTrue(description.containsString("somekey"))
        XCTAssertTrue(description.containsString("somevalue"))
        XCTAssertTrue(description.hasSuffix("Full keyPath `/`"))
    }
    
    func testDebugDescriptionForJSONForTypeMismatch() {
        // Given
        let json = JSON(object: ["key": 1])
        let error = JSON.Error.TypeMismatch(expectedType: "String", actualType: "Int", keyPath: JSON.KeyPath())
        
        // When
        let description = error.descriptionForJSON(json)
        
        // Then
        XCTAssertEqual(description, "TypeMismatch, expected `String` got `(Object (1))`. Full keyPath `/`")
    }
    
    func testDebugDescriptionForJSONForTypeMismatchWithInvalidKeyPath() {
        // Given
        let json = JSON(object: ["key": 1])
        let error = JSON.Error.TypeMismatch(expectedType: "String", actualType: "Int", keyPath: JSON.KeyPath(path: [.Key("test")]))
        
        // When
        let description = error.descriptionForJSON(json)
        
        // Then
        XCTAssertEqual(description, "TypeMismatch, expected `String` got `Int`. Full keyPath `/.test`")
    }
}
