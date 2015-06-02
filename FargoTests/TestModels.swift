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
	static func make(#reqInt: Decoded<Int>, reqStr: Decoded<String>, reqBool: Decoded<Bool>, optStr: Decoded<String?>, optInt: Decoded<Int?>, optBool: Decoded<Bool?>) -> Decoded<SimpleModel> {
		
		if let e = reqInt.error { return .Error(e) }
		if let e = reqStr.error { return .Error(e) }
		if let e = reqBool.error { return .Error(e) }
		if let e = optStr.error { return .Error(e) }
		if let e = optInt.error { return .Error(e) }
		if let e = optBool.error { return .Error(e) }
		
		let model = SimpleModel(
			reqInt: reqInt.value!,
			reqStr: reqStr.value!,
			reqBool: reqBool.value!,
			optStr: optStr.value!,
			optInt: optInt.value!,
			optBool: optBool.value!)
		return .Success(Box(model))
	}
	
	static func decode(json: JSON) -> Decoded<SimpleModel> {
		return SimpleModel.make(
			reqInt: json.value("reqInt"),
			reqStr: json.value("reqStr"),
			reqBool: json.value("reqBool"),
			optStr: json.value("optStr"),
			optInt: json.value("optInt"),
			optBool: json.value("optBool")
		)
	}
}

struct NestedModel {
	let reqInt: Int
	let reqStr: String
	let reqSimpleModel: SimpleModel
	let optSimpleModel: SimpleModel?
}

extension NestedModel: Decodable {
	static func make(#reqInt: Decoded<Int>, reqStr: Decoded<String>, reqSimpleModel: Decoded<SimpleModel>, optSimpleModel: Decoded<SimpleModel?>) -> Decoded<NestedModel> {
		
		if let e = reqInt.error { return .Error(e) }
		if let e = reqStr.error { return .Error(e) }
		if let e = reqSimpleModel.error { return .Error(e) }
		if let e = optSimpleModel.error { return .Error(e) }
		
		let model = NestedModel(
			reqInt: reqInt.value!,
			reqStr: reqStr.value!,
			reqSimpleModel: reqSimpleModel.value!,
			optSimpleModel: optSimpleModel.value!)
		return .Success(Box(model))
	}
	
	static func decode(json: JSON) -> Decoded<NestedModel> {
		return NestedModel.make(
			reqInt: json.value("reqInt"),
			reqStr: json.value("reqStr"),
			reqSimpleModel: json.value("reqSimpleModel"),
			optSimpleModel: json.value("optSimpleModel")
		)
	}
}