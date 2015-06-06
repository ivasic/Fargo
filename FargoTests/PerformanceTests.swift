//
//  PerformanceTests.swift
//  Fargo
//
//  Created by Ivan Vasic on 06/06/15.
//  Copyright (c) 2015 Ivan Vasic. All rights reserved.
//

import UIKit
import XCTest
import Fargo

class PerformanceTests: XCTestCase {
	
	let bigJsonPath = NSBundle(forClass: PerformanceTests.self).pathForResource("Big", ofType: "json")!
	
	func testEncodingPerformance() {
		let data = NSData(contentsOfFile: bigJsonPath)!
		let dict: AnyObject = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.allZeros, error: nil)!
		
		self.measureBlock() {
			JSON.encode(dict)
		}
	}
	
	func testDecodingPerformance() {
		let data = NSData(contentsOfFile: bigJsonPath)!
		let dict: AnyObject = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.allZeros, error: nil)!
		let json = JSON.encode(dict)
		self.measureBlock() {
			let model: BigModel? = json.decode()
		}
	}
}
