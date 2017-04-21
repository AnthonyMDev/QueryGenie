//
//  SortedQueryable.swift
//
//  Created by Anthony Miller on 12/29/16.
//

import Foundation

/// A query that can be sorted.
public protocol SortedQueryable: Queryable {
    
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

extension SortedQueryable {
        
    /// Sorts the query by an attribute.
    ///
    /// - Parameters:
    ///   - attribute: The attribute to sort the query by.
    ///   - ascending: `true` to sort ascending. `false` to sort descending.
    /// - Returns: A sorted copy of the receiver.
    public final func sorted<A: AttributeProtocol>(by attribute: A, ascending: Bool) -> Self {
        return sorted(by: attribute.___name, ascending: ascending)
    }
    
}
