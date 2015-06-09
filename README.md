
# Fargo 

Fargo is a JSON parsing library heavily inspired by a functional JSON parsing library [Argo](https://github.com/thoughtbot/Argo). Started out as a fork but changed many concepts, mainly, in order to support iOS 7.0, Fargo is not a framework (although can be used as such). Also, all custom operators are replaced with functions and most dependencies are removed.


## Installation

### Git Submodules

Until we can ditch iOS 7.0 support, this is the preferred installation method.

Add this repo as a submodule, and add all the files from `Fargo` subfolder to your workspace.

You'll also need to add [Box] to your project the same way.

## Usage tl;dr:

```swift
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
	
	static func decode(json: JSON) -> Decoded<ExampleModel> {
		return ExampleModel.create
			<^> json.value("id")
			<*> json.value(["extras", "text"])							// nested objects
			<*> json.value("date").convert(convertDate)						// with converter function
			<*> json.value("url").convert({ return NSURL(string: $0)! })					// or inline
			<*> json.value("tags")										// arrays
	}
}

// From your JSON data

let dict: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.allZeros, error: nil)

if let dict = dict {
	let json = JSON.encode(dict)
	let model: ExampleModel? = json.decode() // decode model object directly
	let decodedModel: Decoded<ExampleModel> = json.decode() // or preserve decoding error info

```

For more examples on how to use Fargo, please check out the tests.
