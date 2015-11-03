
# Fargo 

Fargo is a very simple and lightweight JSON parsing library with very helpful error debugging support heavily inspired by a functional JSON parsing library [Argo](https://github.com/thoughtbot/Argo). Started out as a fork (f-argo) but changed almost all concepts, mainly, after Swift 2.0, greatly simplified parsing code and now depending on the do/catch for error handling.


## Installation

### CocoaPods

To integrate Fargo into your Xcode project using CocoaPods, specify it in your Podfile:

	source 'https://github.com/CocoaPods/Specs.git'
	platform :ios, '8.0'
	use_frameworks!
	
	pod 'Fargo'

Then, run the following command:

	$ pod install
	
### Carthage

TODO

### Git Submodules

Add this repo as a submodule, and add all the files from `Fargo` subfolder to your workspace.

## Usage tl;dr:

```swift
struct ExampleModel {
	var id: Int
	var text: String?
	var date: NSDate?
	var url: NSURL?
	var tags: [String]
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

// From your JSON data

do {
    let json: AnyObject? = try NSJSONSerialization.JSONObjectWithData(NSData(), options: NSJSONReadingOptions())
    let model: ExampleModel = try JSON(object: json).decode()
} catch {
    XCTFail("Decoding ExampleModel failed with error: \(error)")
}
```

For more examples on how to use Fargo, please check out the tests.
