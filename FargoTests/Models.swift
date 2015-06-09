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
	let date: NSDate?
	let url: NSURL
}

extension HeterogenousModel: Decodable {
	static func make(date: NSDate?)(url: NSURL) -> HeterogenousModel {
		let model = HeterogenousModel(date: date, url: url)
		return model
	}
	
	static func convertDate(string: String?) -> NSDate? {
		if let string = string {
			let df = NSDateFormatter()
			df.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
			return df.dateFromString(string)
		}
		return nil
	}
	
	static func decode(json: JSON) -> Decoded<HeterogenousModel> {
		return HeterogenousModel.make
			<^> json.value("date").convert(convertDate)				// using functions
			<*> json.value("url").convert({ NSURL(string: $0)! })	// or inline
	}
}

struct BigModelInner {
	let id: String
	let guid: String
	let text: String?
}

extension BigModelInner: Decodable {
	
	static func create(id: String)(guid: String)(text: String?) -> BigModelInner {
		return BigModelInner(id: id, guid: guid, text: text)
	}
	
	static func decode(json: JSON) -> Decoded<BigModelInner> {
		return BigModelInner.create
			<^> json.value("id")
			<*> json.value("guid")
			<*> json.value("text")
	}
}

struct BigModel {
	let id: String
	let index: Int
	let guid: String
	let active: Bool
	let balance: Double
	let picture: NSURL?
	let age: Int
	let latitude: Float
	let longitude: Float
	let inner: BigModelInner?
}

extension BigModel: Decodable {
	static func create(id: String)(index: Int)(guid: String)(active: Bool)(balance: Double)(picture: NSURL?)(age: Int)(latitude: Float)(longitude: Float)(inner: BigModelInner?) -> BigModel {
		return BigModel(id: id, index: index, guid: guid, active: active, balance: balance, picture: picture, age: age, latitude: latitude, longitude: longitude, inner: inner)
	}
	
	static func decode(json: JSON) -> Decoded<BigModel> {
		return BigModel.create
			<^> json.value("id")
			<*> json.value("index")
			<*> json.value("guid")
			<*> json.value("active")
			<*> json.value("balance")
			<*> json.value("picture").map({ return NSURL(string: $0) })
			<*> json.value("age")
			<*> json.value("latitude")
			<*> json.value("longitude")
			<*> json.value("inner")
	}
}

struct ExampleModel {
	var id: Int
	var text: String?
	var date: NSDate?
	var url: NSURL?
	var tags: [String]
}

extension ExampleModel: Decodable {
	static func create(id: Int)(text: String?)(date: NSDate?)(url: NSURL?)(tags: [String]) -> ExampleModel {
		return ExampleModel(id: id, text: text, date: NSDate(), url: url, tags: tags)
	}
	
	static func convertDate(string: String) -> NSDate? {
		let df = NSDateFormatter()
		df.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
		return df.dateFromString(string)
	}
	
	static func decode(json: JSON) -> Decoded<ExampleModel> {
		return ExampleModel.create
			<^> json.value("id")
			<*> json.value(["extras", "text"])							// nested objects
			<*> json.value("date").convert(convertDate)					// with converter function
			<*> json.value("url").convert({ return NSURL(string: $0) })	// or inline
			<*> json.value("tags")										// arrays
	}
}

struct ExtendedModel {
	var id: Int
	var examples: [ExampleModel]
}

extension ExtendedModel: Decodable {
	static func create(id: Int)(examples: [ExampleModel]) -> ExtendedModel {
		return ExtendedModel(id: id, examples: examples)
	}
	
	static func decode(json: JSON) -> Decoded<ExtendedModel> {
		return ExtendedModel.create
			<^> json.value("id")
			<*> json.value("examples")	// any object conforming to Decodable will work
	}
}
