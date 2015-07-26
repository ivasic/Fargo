//
//  Examples.swift
//  Fargo
//
//  Created by Ivan Vasic on 26/07/15.
//  Copyright © 2015 Ivan Vasic. All rights reserved.
//

import Fargo

struct ExampleModel {
	var id: Int
	var text: String?
	var date: NSDate?
	var url: NSURL?
	var tags: [String]
}

extension ExampleModel : Decodable {
	static func decode(json: JSON) throws -> ExampleModel {
		return ExampleModel(
			id:		try json.value("id"),
			text:	try json.value("text"),
			date:	try json.value("date", transform: dateFromString),
			url:	try json.value("url", transform: { NSURL(string: $0) }),
			tags:	try json.value("tags")
		)
	}
}
	
func dateFromString(string: String) -> NSDate? {
	let formatter = NSDateFormatter()
	return formatter.dateFromString(string)
}
