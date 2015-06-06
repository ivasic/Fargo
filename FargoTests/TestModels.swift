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