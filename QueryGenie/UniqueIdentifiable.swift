//
//  UniqueIdentifiable.swift
//  QueryGenie
//
//  Created by Anthony Miller on 2/11/16.
//

import Foundation

/// An entity that can be uniquely identified using a primary key.
///
/// Entities of the same type with the same `uniqueIdentifier` should
/// be considered to represent the same object. By default, this
/// protocol makes those objects "equal" using the `Equatable` 
/// protocol. You may override this behavior.
public protocol UniqueIdentifiable: Sortable, Equatable {
    
    /// The type of the `uniqueIdentifier`.
    associatedtype UniqueIdentifierType: Hashable
    
    /// The key on instances of the object used to access the unique identifier.
    static var primaryKey: Attribute<UniqueIdentifierType> { get }
    
    /// The unique identifier for the object.
    var uniqueIdentifier: UniqueIdentifierType { get set }
    
}

/*
 *  MARK: - Equatable
 */

public func == <T: UniqueIdentifiable>(lhs: T, rhs: T) -> Bool {
    return lhs.uniqueIdentifier == rhs.uniqueIdentifier
}

/*
 *  MARK: - Sortable
 */

public extension UniqueIdentifiable where Self.UniqueIdentifierType: Comparable {
    
    public func isOrderedBefore(_ element: Self) -> Bool {
        return self.uniqueIdentifier < element.uniqueIdentifier
    }
    
}
