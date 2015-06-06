//
//  TestModels.swift
//  Fargo
//
//  Created by Ivan Vasic on 31/05/15.
//  Copyright (c) 2015 Ivan Vasic. All rights reserved.
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
	static func make(reqInt: Int)(reqStr: String)(reqBool: Bool)(optStr: String?)(optInt: Int?)(optBool: Bool?) -> SimpleModel {
		let model = SimpleModel(
			reqInt: reqInt,
			reqStr: reqStr,
			reqBool: reqBool,
			optStr: optStr,
			optInt: optInt,
			optBool: optBool)
		return model
	}
	
	static func decode(json: JSON) -> Decoded<SimpleModel> {
		return SimpleModel.make
			<^> json.value("reqInt")
			<*> json.value("reqStr")
			<*> json.value("reqBool")
			<*> json.value("optStr")
			<*> json.value("optInt")
			<*> json.value("optBool")
	}
}

struct NestedModel {
	let reqInt: Int
	let reqStr: String
	let reqSimpleModel: SimpleModel
	let optSimpleModel: SimpleModel?
}

extension NestedModel: Decodable {
	static func make(reqInt: Int)(reqStr: String)(reqSimpleModel: SimpleModel)(optSimpleModel: SimpleModel?) -> NestedModel {
		let model = NestedModel(
			reqInt: reqInt,
			reqStr: reqStr,
			reqSimpleModel: reqSimpleModel,
			optSimpleModel: optSimpleModel)
		return model
	}
	
	static func decode(json: JSON) -> Decoded<NestedModel> {
		return NestedModel.make
			<^> json.value("reqInt")
			<*> json.value("reqStr")
			<*> json.value("reqSimpleModel")
			<*> json.value("optSimpleModel")
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
	static func make(reqInt: [Int])(reqStr: [String])(reqBool: [Bool])(optStr: [String]?)(optInt: [Int]?)(optBool: [Bool]?)(optSimpleModel: [SimpleModel]?) -> CollectionsModel {
		let model = CollectionsModel(
			reqIntArray: reqInt,
			reqStrArray: reqStr,
			reqBoolArray: reqBool,
			optStrArray: optStr,
			optIntArray: optInt,
			optBoolArray: optBool,
			optSimpleModelArray: optSimpleModel)
		return model
	}
	
	static func decode(json: JSON) -> Decoded<CollectionsModel> {
		return CollectionsModel.make
			<^> json.value("reqInt")
			<*> json.value("reqStr")
			<*> json.value("reqBool")
			<*> json.value("optStr")
			<*> json.value("optInt")
			<*> json.value("optBool")
			<*> json.value("optSimpleModel")
	}
}

struct SimpleEmbedded {
	let int: Int
	let str: String?
}

extension SimpleEmbedded: Decodable {
	static func make(int: Int)(str: String?) -> SimpleEmbedded {
		let model = SimpleEmbedded(int: int, str: str)
		return model
	}
	
	static func decode(json: JSON) -> Decoded<SimpleEmbedded> {
		return SimpleEmbedded.make <^> json.value(["embedded", "int"]) <*> json.value(["embedded", "inner", "str"])
	}
}

struct CollectionsEmbedded {
	let ints: [Int]
	let bools: [Bool]?
	let strs: [String]?
}

extension CollectionsEmbedded: Decodable {
	static func make(ints: [Int])(bools: [Bool]?)(strs: [String]?) -> CollectionsEmbedded {
		let model = CollectionsEmbedded(ints: ints, bools: bools, strs: strs)
		return model
	}
	
	static func decode(json: JSON) -> Decoded<CollectionsEmbedded> {
		return CollectionsEmbedded.make
			<^> json.value(["embedded", "ints"])
			<*> json.value(["embedded", "bools"])
			<*> json.value(["embedded", "strs"])
	}
}

struct HeterogenousModel {
	let date: NSDate
	let url: NSURL?
}

extension HeterogenousModel: Decodable {
	static func make(date: NSDate)(url: NSURL?) -> HeterogenousModel {
		let model = HeterogenousModel(date: date, url: url)
		return model
	}
	
	static func convertDate(string: String) -> NSDate {
		let df = NSDateFormatter()
		df.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
		return df.dateFromString(string)!
	}
	
	static func decode(json: JSON) -> Decoded<HeterogenousModel> {
		return HeterogenousModel.make
			<^> json.value("date").map(convertDate)				// with converter function
			<*> json.value("url").map({ NSURL(string: $0) })	// or inline
	}
}
