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
    
}

/*
 *  MARK: - Is Empty
 */

extension Queryable {
    
    public final var isEmpty: Bool {
        return count() == 0
    }
    
}

extension Queryable where Self: Enumerable {
    
    public final var isEmpty: Bool {
        return take(1).count() == 0
    }
    
}

extension Collection where Self: Queryable {
    
    public final var isEmpty: Bool {
        return count() == 0
    }
    
}

extension Collection where Self: Queryable & Enumerable {
    
    public final var isEmpty: Bool {
        return take(1).count() == 0
    }
    
}
