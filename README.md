# AmazonS3RequestManager
[![Version](https://img.shields.io/cocoapods/v/QueryGenie.svg?style=flat)](http://cocoapods.org/pods/QueryGenie)
[![License](https://img.shields.io/cocoapods/l/QueryGenie.svg?style=flat)](http://cocoapods.org/pods/QueryGenie)
[![Platform](https://img.shields.io/cocoapods/p/QueryGenie.svg?style=flat)](http://cocoapods.org/pods/QueryGenie)
[![Build Status](https://travis-ci.org/AnthonyMDev/QueryGenie.svg?branch=master)](https://travis-ci.org/AnthonyMDev/QueryGenie)
[![Contact me on Codementor](https://cdn.codementor.io/badges/contact_me_github.svg)](https://www.codementor.io/anthonymdev?utm_source=github&utm_medium=button&utm_term=anthonymdev&utm_campaign=github)

A framework for creating and executing type-safe queries in Swift. Inspired by QueryKit and AlecrimCoreData.

## Features

- [x] Core Data Compatibility
- [x] Realm Compatibility
- [x] Automatic attribute generator for `Realm`.
- [x] [Complete Documentation](http://cocoadocs.org/docsets/QueryGenie)

## Usage

### Attribute Creation

To use `QueryGenie`, you first need to add extensions to your model objects providing attributes for all queryable propeties on your models. For `Realm` models, this can be done simply using the `RealmGenerator`. A generator for `CoreData` models is planned for future release. 

An extension for a `User` model might look as follows:

```swift
extension User {
    static var name:Attribute<String> { return Attribute("name") }
    static var age:Attribute<Int> { return Attribute("age") }
}
```

### Filtering

This allows us to create predicates using our model types.

```swift
let namePredicate: NSPredicate = User.name == "Kyle"
let agePredicate: NSPredicate = User.age > 25
```

These predicates can be used to filter, sort, and execute queries on `Queryable` entities.

For `Realm`: 

```swift

let realm = try! Realm()
let users: Results<User> = realm.objects(User.self)
    .filter { $0.name == "Kyle" }
    .filter { $0.age > 25 }
    .sortedBy(ascending: true) { $0.name } 
    .sortedBy(ascending: false) { $0.age }

```

For `CoreData`:

```swift

let context = NSManagedObjectContext(concurrencyType: .mainQueue)
let users = Table<User>(context: context)
    .filter { $0.name == "Kyle" }
    .filter { $0.age > 25 }
    .sortedBy(ascending: true) { $0.name }
    .sortedBy(ascending: false) { $0.age }

```

This library support many other advanced querying capabilities including `sum`, `min`, `max`, `average`, `any`, `none`, and more. For more information, please [check out the documentation](http://cocoadocs.org/docsets/QueryGenie).

### Primary Keys

Model objects that have a primary key may provide an attribute for the primary key in an extension to support querying unique objects.

For `Realm`, if your object returns a value for `primaryKey`, all you need to do is make your object conform to `UniqueIdentifiable` and provide the value type of your primary key. This extension will be generated for you if you use `RealmGenerator`. 

```swift
extension User: UniqueIdentifiable {
    public typealias UniqueIdentifierType = String
}
```

For `CoreData`, make your object conform to `UniqueIdentifiable` and provide a static attribute for the `primaryKey` with the name of the primary key property on your entity.

```swift
extension User: UniqueIdentifiable {

    static var primaryKey:Attribute<String> { return Attribute("id") }

}
```

### Automatic Attribute Generation

*A Command Line Tool to make automatic attribute generation easier is planned for future release.* 

`QueryGenie` provides a helper class to automatically generate attribute extensions for all of your `Realm` objects. A generator for `CoreData` is planned for future release.

To use the `RealmGenerator`, inlcude the `QueryGenieRealmGenerator` pod in a new test target in your Xcode project.

In that test target, you can create a test that will generate your extensions. 

```swift
import XCTest

import QueryGenieRealmGenerator
import Realm

class GenerateAttributes: XCTestCase {

    func test_generateAttributes() {
        let path = "/Users/AnthonyMDev/MyProject/Models/QueryGenieExtensions"        
        let url = URL(fileURLWithPath: path, isDirectory: true)
        let config = RLMRealmConfiguration.init()
        config.deleteRealmIfMigrationNeeded = true
        try? RealmGenerator.generateAttributeFiles(for: RLMRealm(configuration: config).schema, destination: url)
    }

}
```

## Installation

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects.

To integrate QueryGenie into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

pod 'QueryGenie/Realm', '~> 1.0' // For use with Realm models

pod 'QueryGenie/CoreData', '~> 1.0' // For use with CoreData models
```

Then, run the following command:

```bash
$ pod install
```
