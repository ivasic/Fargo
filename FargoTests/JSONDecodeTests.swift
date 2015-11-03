//
//  JSONDecodeTests.swift
//  Fargo
//
//  Created by Ivan Vasic on 03/11/15.
//  Copyright © 2015 Ivan Vasic. All rights reserved.
//

import XCTest
import Fargo

class JSONDecodeTests: XCTestCase {
    
    
    func testDecode() {
        // Given
        let json = JSON(object: "string")
        
        // When
        let result: String? = try? json.decode()
        
        // Then
        XCTAssertEqual(result ?? "", "string")
    }
    
    func testDecodeThrows() {
        // Given
        let json = JSON(object: "string")
        
        // When
        do {
            let _: Int = try json.decode()
            XCTFail("Method should throw")
        } catch {
            // Then
            XCTAssertTrue(error is JSON.Error)
        }
    }
    
    
    func testDecodeArray() {
        // Given
        let json = JSON(object: [0, 1, 2])
        
        // When
        let result: [Int]? = try? json.decode()
        
        // Then
        XCTAssertEqual(result ?? [], [0, 1, 2])
    }
    
    func testDecodeArrayThrowsWithNonArray() {
        // Given
        let json = JSON(object: "string")
        
        // When
        do {
            let _: [Int] = try json.decode()
            XCTFail("Method should throw")
        } catch {
            // Then
            XCTAssertTrue(error is JSON.Error)
        }
    }
    
    func testDecodeArrayTypeMismatchThrows() {
        // Given
        let json = JSON(object: [0, 1, 2])
        
        // When
        do {
            let _: [String] = try json.decode()
            XCTFail("Method should throw")
        } catch {
            // Then
            XCTAssertTrue(error is JSON.Error)
        }
    }
    
}
