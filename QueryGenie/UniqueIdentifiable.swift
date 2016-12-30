//
//  UniqueIdentifiable.swift
//  ZRModels
//
//  Created by Anthony Miller on 2/11/16.
//  Copyright © 2016 App-Order. All rights reserved.
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
    
    /// The primary key on instances of the object used to access the unique identifier.
    static var primaryKey: Attribute<String> { get }
    
    /// The unique identifier for the object.
    var uniqueIdentifier: UniqueIdentifierType { get }
    
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

/*
 *  MARK: - Default Implementation Extensions
 */

// MARK: NSObject
public extension UniqueIdentifiable where Self: NSObject {
    
    var uniqueIdentifier: UniqueIdentifierType {
        return value(forKey: type(of: self).primaryKey.___name) as! UniqueIdentifierType
    }
    
}

// MARK: Collection
public extension UniqueIdentifiable where Self: Collection, Self.Index == String {
    
    var uniqueIdentifier: Self.Iterator.Element {
        return self[type(of: self).primaryKey.___name]
    }
    
}
