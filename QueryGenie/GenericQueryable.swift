//
//  GenericQueryable.swift
//
//  Created by Anthony Miller on 12/28/16.
//

import Foundation

/// A query of items of a generic type `Element`.
public protocol GenericQueryable: Queryable {
    
    associatedtype Element = Self.Iterator.Element
    
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

extension GenericQueryable {
    
    public final func filter(_ predicateClosure: (Self.Element.Type) -> NSPredicate) -> Self {
        return self.filter(predicateClosure(Self.Element.self))
    }
    
    public final func count(_ predicateClosure: (Self.Element.Type) -> NSPredicate) -> Int {
        return self.filter(predicateClosure(Self.Element.self)).count()
    }
    
    public final func first(_ predicateClosure: (Self.Element.Type) -> NSPredicate) -> Self.Element? {
        return self.filter(predicateClosure(Self.Element.self)).first()
    }
    
}

extension GenericQueryable where Self.Element: UniqueIdentifiable, Self.Element.UniqueIdentifierType == String {
    
    /// Finds the object of the `Element` type with the given unique identifier, if one exists.
    ///
    /// - Parameter id: The unique identifier to find the object for.
    ///
    /// - Returns: The object for the `id`, or `nil` if the object does not exists.
    public final func object(forUniqueId id: String) -> Self.Element? {
        return self.first { $0.primaryKey == id }
    }
    
    /// Finds the object of the `Element` type with the given unique identifier, if one exists.
    ///
    /// - Parameter id: The unique identifier to find the object for.
    ///
    /// - Returns: The object for the `id`, or `nil` if the object does not exists.
    public final func object(forUniqueId id: Attribute<String>) -> Self.Element? {
        return self.object(forUniqueId: id.___name)
    }

}

/*
 *  MARK: - Ordering
 */

extension GenericQueryable where Self: SortedQueryable {
    
    /// Sorts the query by an attribute.
    ///
    /// - Parameters:
    ///   - ascending: `true` to sort ascending. `false` to sort descending.
    ///   - orderingClosure: The closure returning the attribute on the `Element.Type` to sort by.
    /// - Returns: A sorted copy of the receiver.
    public final func sortedBy<A: AttributeProtocol, V>(ascending: Bool = true, _ orderingClosure: (Self.Element.Type) -> A) -> Self where A.ValueType == V {
        return self.sorted(by: orderingClosure(Self.Element.self), ascending: ascending)
    }
    
}

/*
 *  MARK: - Any/None
 */

extension GenericQueryable {
    
    /// Determines if any items match the given query.
    ///
    /// - Parameter predicateClosure: The closure returning a predicate to filter the query by.
    /// - Returns: `true` if any items match the query, otherwise `false`.
    public final func any(_ predicateClosure: (Self.Element.Type) -> NSPredicate) -> Bool {
        return !self.filter(predicateClosure(Self.Element.self)).isEmpty
    }
    
    /// Determines if no items match the given query.
    ///
    /// - Parameter predicateClosure: The closure returning a predicate to filter the query by.
    /// - Returns: `false` if any items match the query, otherwise `true`.
    public final func none(_ predicateClosure: (Self.Element.Type) -> NSPredicate) -> Bool {
        return self.filter(predicateClosure(Self.Element.self)).isEmpty
    }
    
}

extension GenericQueryable where Self: Enumerable {
    
    /// Determines if any items match the given query.
    ///
    /// - Parameter predicateClosure: The closure returning a predicate to filter the query by.
    /// - Returns: `true` if any items match the query, otherwise `false`.
    public final func any(_ predicateClosure: (Self.Element.Type) -> NSPredicate) -> Bool {
        return !self.filter(predicateClosure(Self.Element.self)).isEmpty
    }
    
    /// Determines if no items match the given query.
    ///
    /// - Parameter predicateClosure: The closure returning a predicate to filter the query by.
    /// - Returns: `false` if any items match the query, otherwise `true`.
    public final func none(_ predicateClosure: (Self.Element.Type) -> NSPredicate) -> Bool {
        return self.filter(predicateClosure(Self.Element.self)).isEmpty
    }
    
}

/*
 *  MARK: - First
 */

extension GenericQueryable {
    
    public final func first() -> Self.Element? {
        return self.objects().first
    }
    
}

extension GenericQueryable where Self: Enumerable {
    
    public final func first() -> Self.Element? {
        return self.take(1).objects().first
    }
    
}

/*
 *  MARK: - Sequence
 */

extension GenericQueryable {
    
    public final func makeIterator() -> AnyIterator<Self.Element> {
        return AnyIterator(self.objects().makeIterator())
    }
    
}
