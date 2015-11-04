//
//  Examples.swift
//  Fargo
//
//  Created by Ivan Vasic on 26/07/15.
//  Copyright © 2015 Ivan Vasic. All rights reserved.
//

import Fargo
import Foundation

// MARK: Simple ExampleModel

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


// MARK: - Real World Example

struct User {
    let id: String
    let email: String
    let profile: Profile
    let status: Status
    let permissions: [Permission]
}

struct Profile {
    let name: String
    let nickname: String?
    let age: Int?
    let avatarURL: NSURL?
    let lastLogin: NSDate?
}

enum Status: Int {
    case Active     = 0
    case Inactive   = 1
}

enum Permission: Int {
    case CanRead    = 0
    case CanComment = 1
    case CanWrite   = 2
}


extension Permission: Decodable {
    static func decode(json: JSON) throws -> Permission {
        guard let permission = try Permission(rawValue: json.decode()) else {
            throw JSON.Error(typeMismatchForType: "Int", json: json)
        }
        return permission
    }
}

extension Status: Decodable {
    static func decode(json: JSON) throws -> Status {
        guard let permission = try Status(rawValue: json.decode()) else {
            throw JSON.Error(typeMismatchForType: "Int", json: json)
        }
        return permission
    }
}

extension Profile: Decodable {
    static func decode(json: JSON) throws -> Profile {
        return try Profile(
            name:           json.value("name"),
            nickname:       json.value("nickname"),
            age:            json.value("age"),
            avatarURL:      json.value("avatar", transform: { NSURL(string: $0) }),
            lastLogin:      json.value("lastLogin", transform: { NSDateFormatter().dateFromString($0) })
        )
    }
}

extension User: Decodable {
    static func decode(json: JSON) throws -> User {
        return try User(
            id: json.value("id"),
            email: json.value("email"),
            profile: json.value("profile"),
            status: json.value("status"),
            permissions: json.value("permissions")
        )
    }
}
