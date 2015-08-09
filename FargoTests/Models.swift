//
//  Models.swift
//  Fargo
//
//  Created by Ivan Vasic on 20/06/15.
//  Copyright © 2015 Ivan Vasic. All rights reserved.
//

import Foundation
import Fargo

struct SimpleModel {
	let reqInt: Int
	let reqStr: String
	let reqBool : Bool
	let optStr: String?
	let optInt: Int?
	let optBool : Bool?
}

extension SimpleModel: Decodable {
	static func decode(json: JSON) throws -> SimpleModel {
		let rInt: Int = try json.value("reqInt")
		let rStr: String = try json.value("reqStr")
		let rBool: Bool = try json.value("reqBool")
		let optInt: Int? = try json.value("optInt")
		let optStr: String? = try json.value("optStr")
		let optBool: Bool? = try json.value("optBool")
		
		return SimpleModel(reqInt: rInt, reqStr: rStr, reqBool: rBool, optStr: optStr, optInt: optInt, optBool: optBool)
	}
}

struct NestedModel {
	let reqInt: Int
	let reqStr: String
	let reqSimpleModel: SimpleModel
	let optSimpleModel: SimpleModel?
}

extension NestedModel: Decodable {
	static func decode(json: JSON) throws -> NestedModel {
		let rInt: Int = try json.value("reqInt")
		let rStr: String = try json.value("reqStr")
		let reqSimpleModel: SimpleModel = try json.value("reqSimpleModel")
		let optSimpleModel: SimpleModel? = try json.value("optSimpleModel")
		
		return NestedModel(reqInt: rInt, reqStr: rStr, reqSimpleModel: reqSimpleModel, optSimpleModel: optSimpleModel)
	}
}

struct CollectionsModel {
	let reqIntArray: [Int]
	let reqStrArray: [String]
	let reqBoolArray : [Bool]
	let optStrArray: [String]?
	let optIntArray: [Int]?
	let optBoolArray : [Bool]?
	let optSimpleModelArray : [SimpleModel]?
}

extension CollectionsModel: Decodable {
	static func decode(json: JSON) throws -> CollectionsModel {
		let rInt: [Int] = try json.value("reqInt")
		let rStr: [String] = try json.value("reqStr")
		let rBool: [Bool] = try json.value("reqBool")
		let optStr: [String]? = try json.value("optStr")
		let optInt: [Int]? = try json.value("optInt")
		let optBool: [Bool]? = try json.value("optBool")
		let optSimpleModel: [SimpleModel]? = try json.value("optSimpleModel")
		
		return CollectionsModel(reqIntArray: rInt, reqStrArray: rStr, reqBoolArray: rBool, optStrArray: optStr, optIntArray: optInt, optBoolArray: optBool, optSimpleModelArray: optSimpleModel)
	}
}

struct SimpleEmbedded {
	let int: Int
	let str: String?
}

extension SimpleEmbedded: Decodable {
	static func decode(json: JSON) throws -> SimpleEmbedded {
		let rInt: Int = try json.value(["embedded", "int"])
		let rStr: String? = try json.value(["embedded", "inner", "string"])
		
		return SimpleEmbedded(int: rInt, str: rStr)
	}
}

struct CollectionsEmbedded {
	let ints: [Int]
	let bools: [Bool]?
	let strs: [String]?
}

extension CollectionsEmbedded: Decodable {
	static func decode(json: JSON) throws -> CollectionsEmbedded {
		let ints: [Int] = try json.value(["embedded", "ints"])
		let bools: [Bool]? = try json.value(["embedded", "bools"])
		let strs: [String]? = try json.value(["embedded", "strs"])
		
		return CollectionsEmbedded(ints: ints, bools: bools, strs: strs)
	}
}

struct TransformsModel {
	let date: NSDate?
	let url: NSURL
}

extension TransformsModel: Decodable {
	
	static func convertDate(string: String) -> NSDate? {
		let df = NSDateFormatter()
		df.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
		return df.dateFromString(string)
	}
	
	static func decode(json: JSON) throws -> TransformsModel {
		let date: NSDate? = try json.value("date", transform: convertDate)
		let url: NSURL = try json.value("url", transform: { NSURL(string: $0)! })
		
		return TransformsModel(date: date, url: url)
	}
}

struct TransformsModel2 {
	let number: Int
}

extension TransformsModel2: Decodable {
	
	static func convert(str: String) throws -> Int {
		if let num = Int(str) {
			return num
		}
		
		throw DecodeError.TypeMismatch("Expected string representation of a number, got \(str)")
	}
	
	static func decode(json: JSON) throws -> TransformsModel2 {
		let num: Int = try json.value("number", transform: convert)
		return TransformsModel2(number: num)
	}
}

