//
//  KeyPathTests.swift
//  Fargo
//
//  Created by Ivan Vasic on 03/11/15.
//  Copyright © 2015 Ivan Vasic. All rights reserved.
//

import XCTest
import Fargo

class KeyPathTests: XCTestCase {
    
    func testDebugDescription() {
        // Given
        let keypath = JSON.KeyPath(path: [.Key("0"), .Index(1), .Key("2"), .Index(3)])
        
        // When
        let description = keypath.debugDescription
        
        // Then
        XCTAssertEqual(description, "/.0[1].2[3]")
    }
    
    func testEmptyPathDebugDescription() {
        // Given
        let keypath = JSON.KeyPath()
        
        // When
        let description = keypath.debugDescription
        
        // Then
        XCTAssertEqual(description, "/")
    }
}
