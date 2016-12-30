//
//  GenericQueryable.swift
//
//  Created by Anthony Miller on 12/28/16.
//  Copyright © 2016 App-Order. All rights reserved.
//

import Foundation

// TODO: Document
public protocol GenericQueryable: Queryable {
    
    associatedtype Element = Self.Iterator.Element
    
    func objects() -> AnyCollection<Element>
    
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
    
    public final func sortedBy<A: AttributeProtocol, V>(ascending: Bool = true, _ orderingClosure: (Self.Element.Type) -> A) -> Self where A.ValueType == V {
        return self.sorted(by: orderingClosure(Self.Element.self), ascending: ascending)
    }
    
}

/*
 *  MARK: - Any/None
 */

extension GenericQueryable {
    
    public final func any(_ predicateClosure: (Self.Element.Type) -> NSPredicate) -> Bool {
        return !self.filter(predicateClosure(Self.Element.self)).isEmpty
    }
    
    public final func none(_ predicateClosure: (Self.Element.Type) -> NSPredicate) -> Bool {
        return self.filter(predicateClosure(Self.Element.self)).isEmpty
    }
    
}

extension GenericQueryable where Self: Enumerable {
    
    public final func any(_ predicateClosure: (Self.Element.Type) -> NSPredicate) -> Bool {
        return !self.filter(predicateClosure(Self.Element.self)).isEmpty
    }
    
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
