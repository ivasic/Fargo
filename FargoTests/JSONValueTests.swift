//
//  JSONValueTests.swift
//  Fargo
//
//  Created by Ivan Vasic on 03/11/15.
//  Copyright © 2015 Ivan Vasic. All rights reserved.
//

import XCTest
import Fargo

class JSONValueTests: XCTestCase {
    
    // MARK: - value(key)
    
    func testValue() {
        // Given
        let json = JSON(object: ["key": "value"])
        
        // When
        let value: String? = try? json.value("key")
        
        // Then
        XCTAssertEqual(value ?? "", "value")
    }
    
    func testValueThrowsForMissingKey() {
        // Given
        let json = JSON(object: ["key1": "value"])
        
        // When
        do {
            let _: String = try json.value("key")
            XCTFail("Method should throw")
        } catch {
            // Then
            XCTAssertTrue(error is JSON.Error)
        }
    }
    
    func testValueThrowsForTypeMismatch() {
        // Given
        let json = JSON(object: ["key": 0])
        
        // When
        do {
            let _: String = try json.value("key")
            XCTFail("Method should throw")
        } catch {
            // Then
            XCTAssertTrue(error is JSON.Error)
        }
    }
    
    // MARK: - value(keys)
    
    func testValueForKeys() {
        // Given
        let json = JSON(object: ["key": ["key1": "value"]])
        
        // When
        let value: String? = try? json.value(["key", "key1"])
        
        // Then
        XCTAssertEqual(value ?? "", "value")
    }
    
    func testValueForKeysThrowsForMissingKey() {
        // Given
        let json = JSON(object: ["key": ["key1": "value"]])
        
        // When
        do {
            let _: String = try json.value(["key2", "key1"])
            XCTFail("Method should throw")
        } catch {
            // Then
            XCTAssertTrue(error is JSON.Error)
        }
    }
    
    func testValueForKeysThrowsForTypeMismatch() {
        // Given
        let json = JSON(object: ["key": ["key1": 0]])
        
        // When
        do {
            let _: String = try json.value(["key", "key1"])
            XCTFail("Method should throw")
        } catch {
            // Then
            XCTAssertTrue(error is JSON.Error)
        }
    }
    
    // MARK: - value(key, transform)
    
    func testValueForKeyWithTransform() {
        // Given
        let json = JSON(object: ["key": 123])
        
        // When
        let value: String? = try? json.value("key", transform: { String($0 as Int) })
        
        // Then
        XCTAssertEqual(value ?? "", "123")
    }
    
    // MARK: - value(keys, transform)
    
    func testValueForKeysWithTransform() {
        // Given
        let json = JSON(object: ["key": ["key1": 123]])
        
        // When
        let value: String? = try? json.value(["key", "key1"], transform: { String($0 as Int) })
        
        // Then
        XCTAssertEqual(value ?? "", "123")
    }
}

// MARK: - Optional values

extension JSONValueTests {
    
    // MARK: - value(key)
    
    func testValueOptional() {
        // Given
        let json = JSON(object: ["key": "value"])
        
        // When
        let value: String?? = try? json.value("key")
        
        // Then
        XCTAssertEqual(value ?? "", "value")
    }
    
    func testValueOptionalNil() {
        // Given
        let json = JSON(object: ["key": "value"])
        
        // When
        let value: String?? = try? json.value("no-key")
        
        // Then
        XCTAssertNil(value ?? .Some(0))
    }
    
    func testValueOptionalThrowsForTypeMismatch() {
        // Given
        let json = JSON(object: ["key": 0])
        
        // When
        do {
            let _: String? = try json.value("key")
            XCTFail("Method should throw")
        } catch {
            // Then
            XCTAssertTrue(error is JSON.Error)
        }
    }
    
    // MARK: - value(keys)
    
    func testValueOptionalForKeys() {
        // Given
        let json = JSON(object: ["key": ["key1": "value"]])
        
        // When
        let value: String?? = try? json.value(["key", "key1"])
        
        // Then
        XCTAssertEqual(value ?? "", "value")
    }
    
    func testValueOptionalNilForMissingKey() {
        // Given
        let json = JSON(object: ["key": ["key1": "value"]])
        
        // When
        let value: String?? = try? json.value(["key2", "key1"])
        
        // Then
        XCTAssertNil(value ?? .Some(0))

    }
    
    func testValueOptionalForKeysThrowsForTypeMismatch() {
        // Given
        let json = JSON(object: ["key": ["key1": 0]])
        
        // When
        do {
            let _: String? = try json.value(["key", "key1"])
            XCTFail("Method should throw")
        } catch {
            // Then
            XCTAssertTrue(error is JSON.Error)
        }
    }
    
    // MARK: - value(key, transform)
    
    func testValueOptionalForKeyWithTransform() {
        // Given
        let json = JSON(object: ["key": "123"])
        
        // When
        let value: Int?? = try? json.value("key", transform: { Int($0 as String) })
        
        // Then
        XCTAssertEqual(value ?? 0, 123)
    }
    
    func testValueOptionalNilForKeyWithTransform() {
        // Given
        let json = JSON(object: ["key": "123"])
        
        // When
        let value: Int?? = try? json.value("no-key", transform: { Int($0 as String) })
        
        // Then
        XCTAssertNil(value ?? .Some(1))
    }
    
    // MARK: - value(keys, transform)
    
    func testValueOptionalForKeysWithTransform() {
        // Given
        let json = JSON(object: ["key": ["key1": 123]])
        
        // When
        let value: String?? = try? json.value(["key", "key1"], transform: { String($0 as Int) })
        
        // Then
        XCTAssertEqual(value ?? "", "123")
    }
    
    func testValueOptionalNilForKeysWithTransform() {
        // Given
        let json = JSON(object: ["key": ["key1": 123]])
        
        // When
        let value: String?? = try? json.value(["key", "no-key"], transform: { String($0 as Int) })
        
        // Then
        XCTAssertNil(value ?? "", "123")
    }
}

// MARK: - Arrays

extension JSONValueTests {
    
    // MARK: - value(key)
    
    func testArrayValue() {
        // Given
        let json = JSON(object: ["key": [0, 1]])
        
        // When
        let value: [Int]? = try? json.value("key")
        
        // Then
        XCTAssertEqual(value ?? [], [0, 1])
    }
    
    func testArrayValueThrowsForMissingKey() {
        // Given
        let json = JSON(object: ["key": [0, 1]])
        
        // When
        do {
            let _: [Int] = try json.value("no-key")
            XCTFail("Method should throw")
        } catch {
            // Then
            XCTAssertTrue(error is JSON.Error)
        }
    }
    
    func testArrayValueThrowsForTypeMismatch() {
        // Given
        let json = JSON(object: ["key": ["0", "1"]])
        
        // When
        do {
            let _: [Int] = try json.value("key")
            XCTFail("Method should throw")
        } catch {
            // Then
            XCTAssertTrue(error is JSON.Error)
        }
    }
    
    // MARK: - value(keys)
    
    func testArrayValueForKeys() {
        // Given
        let json = JSON(object: ["key": ["key1": [0, 1]]])
        
        // When
        let value: [Int]? = try? json.value(["key", "key1"])
        
        // Then
        XCTAssertEqual(value ?? [], [0, 1])
    }
    
    func testArrayValueForKeysThrowsForMissingKey() {
        // Given
        let json = JSON(object: ["key": ["key1": [0, 1]]])
        
        // When
        do {
            let _: [Int] = try json.value(["key2", "key1"])
            XCTFail("Method should throw")
        } catch {
            // Then
            XCTAssertTrue(error is JSON.Error)
        }
    }
    
    func testArrayValueForKeysThrowsForTypeMismatch() {
        // Given
        let json = JSON(object: ["key": ["key1": ["0", "1"]]])
        
        // When
        do {
            let _: [Int] = try json.value(["key", "key1"])
            XCTFail("Method should throw")
        } catch {
            // Then
            XCTAssertTrue(error is JSON.Error)
        }
    }
}


// MARK: - Arrays Optionals

extension JSONValueTests {
    
    // MARK: - value(key)
    
    func testArrayValueOptional() {
        // Given
        let json = JSON(object: ["key": [0, 1]])
        
        // When
        let value: [Int]?? = try? json.value("key")
        
        // Then
        XCTAssertEqual((value ?? []) ?? [], [0, 1])
    }
    
    func testArrayValueOptionalNil() {
        // Given
        let json = JSON(object: ["key": [0, 1]])
        
        // When
        let value: [Int]?? = try? json.value("no-key")
        
        // Then
        XCTAssertNil(value ?? .Some(0))
    }
    
    func testArrayValueOptionalThrowsForTypeMismatch() {
        // Given
        let json = JSON(object: ["key": 0])
        
        // When
        do {
            let _: [Int]? = try json.value("key")
            XCTFail("Method should throw")
        } catch {
            // Then
            XCTAssertTrue(error is JSON.Error)
        }
    }
    
    // MARK: - value(keys)
    
    func testArrayValueOptionalForKeys() {
        // Given
        let json = JSON(object: ["key": ["key1": [0, 1]]])
        
        // When
        let value: [Int]?? = try? json.value(["key", "key1"])
        
        // Then
        XCTAssertEqual((value ?? []) ?? [], [0, 1])
    }
    
    func testArrayValueOptionalNilForMissingKey() {
        // Given
        let json = JSON(object: ["key": ["key1": [0, 1]]])
        
        // When
        let value: [Int]?? = try? json.value(["key2", "key1"])
        
        // Then
        XCTAssertNil(value ?? .Some(0))
        
    }
}
