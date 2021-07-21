//
//  ResultsQueryable.swift
//
//  Created by Anthony Miller on 12/28/16.
//

import Foundation

import RealmSwift

/// A `Sequence` that can be queried using `NSPredicate` filters.
public protocol ResultsQueryable: Collection {
    
    /// Filters the query items using the given `NSPredicate`.
    ///
    /// - Parameter predicate: The `NSPredicate` to filter the query by.
    /// - Returns: A copy of the receiver with the new filter query added.
    func filter(_ predicate: NSPredicate) -> Self
    
    /// The count of items currently returned by the query.
    func count() -> Int
    
    /// Executes the query, taking the first item in the query.
    ///
    /// - Returns: The first item resulting from the query.
    func first() -> Self.Element?
    
    /// Sorts the query by the given key path.
    ///
    /// - Note: The implementation of this func should accept multiple calls to this function and sort the query by each
    ///         of the given sort parameters in the order they were called.
    ///
    /// - Parameters:
    ///   - keyPath: The key path on objects for the query to sort the query by.
    ///   - ascending: `true` to sort ascending, `false` to sort descending.
    /// - Returns: A copy of the query mutated to sort by the given key path.
    func sorted(by keyPath: String, ascending: Bool) -> Self
    
}

/*
 *  MARK: - Filtering
 */

extension ResultsQueryable where Self.Element: Object {
    
    public func filter(_ predicateClosure: (Self.Element.Type) -> NSPredicate) -> Self {
        return self.filter(predicateClosure(Self.Element.self))
    }
    
    public func count(_ predicateClosure: (Self.Element.Type) -> NSPredicate) -> Int {
        return self.filter(predicateClosure(Self.Element.self)).count()
    }
    
    public func first(_ predicateClosure: (Self.Element.Type) -> NSPredicate) -> Self.Element? {
        return self.filter(predicateClosure(Self.Element.self)).first()
    }
    
}

extension ResultsQueryable where Self.Element: UniqueIdentifiable, Self.Element.UniqueIdentifierType == String, Self.Element: Object {
    
    /// Finds the object of the `Element` type with the given unique identifier, if one exists.
    ///
    /// - Parameter id: The unique identifier to find the object for.
    ///
    /// - Returnsobject for the `id`, or `nil` if the object does not exists.
    public func object(forUniqueId id: String) -> Self.Element? {
        return self.first { $0.primaryKey == id }
    }
    
    /// Finds the object of the `Element` type with the given unique identifier, if one exists.
    ///
    /// - Parameter id: The unique identifier to find the object for.
    ///
    /// - Returns: The object for the `id`, or `nil` if the object does not exists.
    public func object(forUniqueId id: Attribute<String>) -> Self.Element? {
        return self.object(forUniqueId: id.___name)
    }
    
}

/*
 *  MARK: - Ordering
 */

extension ResultsQueryable where Self.Element: Object {
    
    /// Sorts the query by an attribute.
    ///
    /// - Parameters:
    ///   - attribute: The attribute to sort the query by.
    ///   - ascending: `true` to sort ascending. `false` to sort descending.
    /// - Returns: A sorted copy of the receiver.
    public func sorted<A: AttributeProtocol>(by attribute: A, ascending: Bool) -> Self {
        return sorted(by: attribute.___name, ascending: ascending)
    }
    
    /// Sorts the query by an attribute.
    ///
    /// - Parameters:
    ///   - ascending: `true` to sort ascending. `false` to sort descending.
    ///   - orderingClosure: The closure returning the attribute on the `Element.Type` to sort by.
    /// - Returns: A sorted copy of the receiver.
    public func sortedBy<A: AttributeProtocol, V>(ascending: Bool = true, _ orderingClosure: (Self.Element.Type) -> A) -> Self where A.ValueType == V {
        return self.sorted(by: orderingClosure(Self.Element.self), ascending: ascending)
    }
    
}

/*
 *  MARK: - Any/None
 */

extension ResultsQueryable where Self: Results<Object> {
    
    /// Determines if any items match the given query.
    ///
    /// - Parameter predicateClosure: The closure returning a predicate to filter the query by.
    /// - Returns: `true` if any items match the query, otherwise `false`.
    public func any(_ predicateClosure: (Self.Element.Type) -> NSPredicate) -> Bool {
        return !self.filter(predicateClosure(Self.Element.self)).isEmpty
    }
    
    /// Determines if no items match the given query.
    ///
    /// - Parameter predicateClosure: The closure returning a predicate to filter the query by.
    /// - Returns: `false` if any items match the query, otherwise `true`.
    public func none(_ predicateClosure: (Self.Element.Type) -> NSPredicate) -> Bool {
        return self.filter(predicateClosure(Self.Element.self)).isEmpty
    }
    
}

/*
 *  MARK: - First
 */

extension ResultsQueryable where Self: Results<Object> {
    
    public func objects() -> AnyCollection<Element> {
        return AnyCollection(self)
    }
    
}

/*
 *  MARK: - Sequence
 */

extension ResultsQueryable where Self: Results<Object> {
    
    public func makeIterator() -> AnyIterator<Element> {
        return AnyIterator(self.objects().makeIterator())
    }
    
}

/*
 *  MARK: - Is Empty
 */

extension ResultsQueryable {
    
    public var isEmpty: Bool {
        return count() == 0
    }
    
}

extension ResultsQueryable where Self: Enumerable {
    
    public var isEmpty: Bool {
        return take(1).count() == 0
    }
    
}

extension Collection where Self: ResultsQueryable {
    
    public var isEmpty: Bool {
        return count() == 0
    }
    
}

extension Collection where Self: ResultsQueryable & Enumerable {
    
    public var isEmpty: Bool {
        return take(1).count() == 0
    }
    
}

