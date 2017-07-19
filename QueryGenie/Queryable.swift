//
//  Queryable.swift
//
//  Created by Anthony Miller on 12/28/16.
//

import Foundation

/// A `Sequence` that can be queried using `NSPredicate` filters.
public protocol Queryable: Sequence {
    
    /// Filters the query items using the given `NSPredicate`.
    ///
    /// - Parameter predicate: The `NSPredicate` to filter the query by.
    /// - Returns: A copy of the receiver with the new filter query added.
    func filter(_ predicate: NSPredicate) -> Self
    
    /// The count of items currently returned by the query.
    func count() -> Int
    
    /// Executes the query.
    ///
    /// - Returns: A collection of the items resulting from the query.
    func objects() -> AnyCollection<Element>
    
    /// Executes the query, taking the first item in the query.
    ///
    /// - Returns: The first item resulting from the query.
    func first() -> Self.Element?
    
}

/*
 *  MARK: - Filtering
 */

extension Queryable {
    
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

extension Queryable where Self.Element: UniqueIdentifiable, Self.Element.UniqueIdentifierType == String {
    
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

extension Queryable where Self: SortedQueryable {
    
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

extension Queryable {
    
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

extension Queryable where Self: Enumerable {
    
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

extension Queryable {
    
    public func first() -> Self.Element? {
        return self.objects().first
    }
    
}

extension Queryable where Self: Enumerable {
    
    public func first() -> Self.Element? {
        return self.take(1).objects().first
    }
    
}

/*
 *  MARK: - Sequence
 */

extension Queryable {
    
    public func makeIterator() -> AnyIterator<Self.Element> {
        return AnyIterator(self.objects().makeIterator())
    }
    
}

/*
 *  MARK: - Is Empty
 */

extension Queryable {
    
    public var isEmpty: Bool {
        return count() == 0
    }
    
}

extension Queryable where Self: Enumerable {
    
    public var isEmpty: Bool {
        return take(1).count() == 0
    }
    
}

extension Collection where Self: Queryable {
    
    public var isEmpty: Bool {
        return count() == 0
    }
    
}

extension Collection where Self: Queryable & Enumerable {
    
    public var isEmpty: Bool {
        return take(1).count() == 0
    }
    
}
