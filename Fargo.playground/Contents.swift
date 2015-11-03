//: Playground - noun: a place where people can play

import UIKit
@testable import Fargo

struct ExampleModel {
    let id: Int
    let text: String?
    let date: NSDate?
    let url: NSURL?
    let tags: [String]
}

extension ExampleModel : Decodable {
    static func decode(json: JSON) throws -> ExampleModel {
        return try ExampleModel(
            id:     json.value("id"),
            text:   json.value("text"),
            date:   json.value("date", transform: dateFromString),
            url:    json.value("url", transform: { NSURL(string: $0) }),
            tags:   json.value("tags")
        )
    }
}

func dateFromString(string: String) -> NSDate? {
    let formatter = NSDateFormatter()
    return formatter.dateFromString(string)
}

let json = ["id": 1, "text": "text", "date": "2015-07-26", "url": "http://www.github.com", "tags": ["tag1", "tag2"]]

do {
    let model: ExampleModel = try JSON(object: json).decode()
    print(model)
} catch {
    print(error)
}