//
//  ResultsWrapper.swift
//  QueryGenie
//
//  Created by Dominic on 11/9/17.
//

import Foundation

import RealmSwift

/**
Wrapper class for RealmSwift's `Results<Element>` class that sets the `Element` to `Object`.
 
 - Warning: This class passes through calls to all the methods and properties on `Results` except calls to
````
 static func bridging(from objectiveCValue: Any, with metadata: Any?) -> ResultsWrapper
````
and
````
 var bridged: (objectiveCValue: Any, metadata: Any?)
````
 - Note: `Results<Element>` allows `AnyObject`, setting the `Element` to `Object`
         allows QueryGenie extensions to work with `Results`.
*/
public final class ResultsWrapper<T> where T: Object {
    
    // MARK: - Instance Properties
    
    public let results: Results<T>
    
    // MARK: - Object Life Cycle
    
    public init(_ results: Results<T>) {
        self.results = results
    }
    
    /*
     * MARK - Exposing `Results` Interface
     */
    
    /// A human-readable description of the objects represented by the results.
    public var description: String {
        return results.description
    }
    
    // MARK: - Fast Enumeration
    
    /// :nodoc:
    public func countByEnumerating(with state: UnsafeMutablePointer<NSFastEnumerationState>,
                                   objects buffer: AutoreleasingUnsafeMutablePointer<AnyObject?>,
                                   count len: Int) -> Int {
        return results.countByEnumerating(with: state, objects: buffer, count: len)
    }
    
    /// The type of the objects described by the results.
    public typealias ElementType = T
    
    // MARK: Properties
    
    /// The Realm which manages this results. Note that this property will never return `nil`.
    public var realm: Realm? {
        return results.realm
    }
    
    /**
     Indicates if the results are no longer valid.
     
     The results becomes invalid if `invalidate()` is called on the containing `realm`. An invalidated results can be
     accessed, but will always be empty.
     */
    public var isInvalidated: Bool {
        return results.isInvalidated
    }
    
    /// The number of objects in the results.
    public var count: Int {
        return results.count
    }
    
    // MARK: - Index Retrieval
    
    /**
     Returns the index of the given object in the results, or `nil` if the object is not present.
     */
    public func index(of object: T) -> Int? {
        return results.index(of: object)
    }
    
    /**
     Returns the index of the first object matching the predicate, or `nil` if no objects match.
     
     - parameter predicate: The predicate with which to filter the objects.
     */
    public func index(matching predicate: NSPredicate) -> Int? {
        return results.index(matching: predicate)
    }
    
    /**
     Returns the index of the first object matching the predicate, or `nil` if no objects match.
     
     - parameter predicateFormat: A predicate format string, optionally followed by a variable number of arguments.
     */
    public func index(matching predicateFormat: String, _ args: Any...) -> Int? {
        return results.index(matching: predicateFormat, args)
    }
    
    // MARK: Object Retrieval
    
    /**
     Returns the object at the given `index`.
     
     - parameter index: The index.
     */
    public subscript(position: Int) -> T {
        return results[position]
    }
    
    /// Returns the first object in the results, or `nil` if the results are empty.
    public var first: T? {
        return results.first
    }
    
    /// Returns the last object in the results, or `nil` if the results are empty.
    public var last: T? {
        return results.last
    }
    
    // MARK: - KVC
    
    /**
     Returns an `Array` containing the results of invoking `valueForKey(_:)` with `key` on each of the results.
     
     - parameter key: The name of the property whose values are desired.
     */
    public func value(forKey key: String) -> Any? {
        return results.value(forKey: key)
    }
    
    /**
     Returns an `Array` containing the results of invoking `valueForKeyPath(_:)` with `keyPath` on each of the results.
     
     - parameter keyPath: The key path to the property whose values are desired.
     */
    public func value(forKeyPath keyPath: String) -> Any? {
        return results.value(forKeyPath: keyPath)
    }
    
    /**
     Invokes `setValue(_:forKey:)` on each of the objects represented by the results using the specified `value` and
     `key`.
     
     - warning: This method may only be called during a write transaction.
     
     - parameter value: The object value.
     - parameter key:   The name of the property whose value should be set on each object.
     */
    public func setValue(_ value: Any?, forKey key: String) {
        return results.setValue(value, forKey: key)
    }
    
    // MARK: - Filtering
    
    /**
     Returns a `ResultsWrapper` containing all objects matching the given predicate in the collection.
     
     - parameter predicateFormat: A predicate format string, optionally followed by a variable number of arguments.
     */
    public func filter(_ predicateFormat: String, _ args: Any...) -> ResultsWrapper<T> {
        return ResultsWrapper<T>(results.filter(predicateFormat, args))
    }
    
    /**
     Returns a `ResultsWrapper` containing all objects matching the given predicate in the collection.
     
     - parameter predicate: The predicate with which to filter the objects.
     */
    public func filter(_ predicate: NSPredicate) -> ResultsWrapper<T> {
        return ResultsWrapper<T>(results.filter(predicate))
    }
    
    // MARK: - Sorting
    
    /**
     Returns a `ResultsWrapper` containing the objects represented by the results, but sorted.
     
     Objects are sorted based on the values of the given key path. For example, to sort a collection of `Student`s from
     youngest to oldest based on their `age` property, you might call
     `students.sorted(byKeyPath: "age", ascending: true)`.
     
     - warning: Collections may only be sorted by properties of boolean, `Date`, `NSDate`, single and double-precision
     floating point, integer, and string types.
     
     - parameter keyPath:   The key path to sort by.
     - parameter ascending: The direction to sort in.
     */
    public func sorted(byKeyPath keyPath: String, ascending: Bool = true) -> ResultsWrapper<T> {
        return ResultsWrapper<T>(results.sorted(byKeyPath: keyPath, ascending: ascending))
    }
    
    /**
     Returns a `ResultsWrapper` containing the objects represented by the results, but sorted.
     
     - warning: Collections may only be sorted by properties of boolean, `Date`, `NSDate`, single and double-precision
     floating point, integer, and string types.
     
     - see: `sorted(byKeyPath:ascending:)`
     
     - parameter sortDescriptors: A sequence of `SortDescriptor`s to sort by.
     */
    public func sorted<S: Sequence>(by sortDescriptors: S) -> ResultsWrapper<T>
        where S.Iterator.Element == SortDescriptor {
            return ResultsWrapper<T>(results.sorted(by: sortDescriptors))
    }
    
    // MARK: - Aggregate Operations
    
    /**
     Returns the minimum (lowest) value of the given property among all the results, or `nil` if the results are empty.
     
     - warning: Only a property whose type conforms to the `MinMaxType` protocol can be specified.
     
     - parameter property: The name of a property whose minimum value is desired.
     */
    public func min<U: MinMaxType>(ofProperty property: String) -> U? {
        return results.min(ofProperty: property)
    }
    
    /**
     Returns the maximum (highest) value of the given property among all the results, or `nil` if the results are empty.
     
     - warning: Only a property whose type conforms to the `MinMaxType` protocol can be specified.
     
     - parameter property: The name of a property whose minimum value is desired.
     */
    public func max<U: MinMaxType>(ofProperty property: String) -> U? {
        return results.max(ofProperty: property)
    }
    
    /**
     Returns the sum of the values of a given property over all the results.
     
     - warning: Only a property whose type conforms to the `AddableType` protocol can be specified.
     
     - parameter property: The name of a property whose values should be summed.
     */
    public func sum<U: AddableType>(ofProperty property: String) -> U {
        return results.sum(ofProperty: property)
    }
    
    /**
     Returns the average value of a given property over all the results, or `nil` if the results are empty.
     
     - warning: Only the name of a property whose type conforms to the `AddableType` protocol can be specified.
     
     - parameter property: The name of a property whose average value should be calculated.
     */
    public func average<U: AddableType>(ofProperty property: String) -> U? {
        return results.average(ofProperty: property)
    }
    
    // MARK: - Notifications
    
    /**
     Registers a block to be called each time the collection changes.
     
     The block will be asynchronously called with the initial results, and then called again after each write
     transaction which changes either any of the objects in the collection, or which objects are in the collection.
     
     The `change` parameter that is passed to the block reports, in the form of indices within the collection, which of
     the objects were added, removed, or modified during each write transaction. See the `RealmCollectionChange`
     documentation for more information on the change information supplied and an example of how to use it to update a
     `UITableView`.
     
     At the time when the block is called, the collection will be fully evaluated and up-to-date, and as long as you do
     not perform a write transaction on the same thread or explicitly call `realm.refresh()`, accessing it will never
     perform blocking work.
     
     Notifications are delivered via the standard run loop, and so can't be delivered while the run loop is blocked by
     other activity. When notifications can't be delivered instantly, multiple notifications may be coalesced into a
     single notification. This can include the notification with the initial collection.
     
     For example, the following code performs a write transaction immediately after adding the notification block, so
     there is no opportunity for the initial notification to be delivered first. As a result, the initial notification
     will reflect the state of the Realm after the write transaction.
     
     ```swift
     let results = realm.objects(Dog.self)
     print("dogs.count: \(dogs?.count)") // => 0
     let token = dogs.observe { changes in
     switch changes {
     case .initial(let dogs):
     // Will print "dogs.count: 1"
     print("dogs.count: \(dogs.count)")
     break
     case .update:
     // Will not be hit in this example
     break
     case .error:
     break
     }
     }
     try! realm.write {
     let dog = Dog()
     dog.name = "Rex"
     person.dogs.append(dog)
     }
     // end of run loop execution context
     ```
     
     You must retain the returned token for as long as you want updates to be sent to the block. To stop receiving
     updates, call `invalidate()` on the token.
     
     - warning: This method cannot be called during a write transaction, or when the containing Realm is read-only.
     
     - parameter block: The block to be called whenever a change occurs.
     - returns: A token which must be held for as long as you want updates to be delivered.
     */
    public func observe(_ block: @escaping (RealmCollectionChange<Results<T>>) -> Void) -> NotificationToken {
        return results.observe(block)
    }
    
}
