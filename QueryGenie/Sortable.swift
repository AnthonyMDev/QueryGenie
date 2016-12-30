//
//  Sortable.swift
//  ZRModels
//
//  Created by Anthony Miller on 7/31/15.
//  Copyright (c) 2015 App-Order. All rights reserved.
//

import Foundation

/// An collection of this entity may be sorted.
/// This serves as an alternative to `Comparable` when the appropriate sort order 
/// does not necessarially denote a greater than, less than, or equal value.
public protocol Sortable {
    
    /// Determines if the receiver should be ordered before or after the given 
    /// entity in an ordered collection.
    ///
    /// - Parameter element: The other entity to determine order for.
    /// - Returns: `true` if the receiver should come before the `element`, 
    ///             or `false` if it should come after.
    func isOrderedBefore(_ element: Self) -> Bool
    
}

public extension Sequence where Self.Iterator.Element: Sortable {
    
    /// Returns the elements of the sequence, sorted.
    ///
    /// You can sort any sequence of elements that conform to the
    /// `Sortable` protocol by calling this method.
    ///
    /// The sorting algorithm is not stable. A nonstable sort may change the
    /// relative order of elements where `isOrderedBefore(_:)` returns the 
    /// same value when the receiver and target are swapped.
    ///
    /// - Returns: A sorted array of the sequence's elements.    
    public func sorted() -> [Self.Iterator.Element] {
        return self.sorted(by: { (lhs, rhs) -> Bool in
            return lhs.isOrderedBefore(rhs)
        })
    }
    
}

public extension Array where Element: Sortable {
    
    /// Return an `Array` containing the sorted elements of `source`.
    ///
    /// The sorting algorithm is not stable (can change the relative order of
    /// elements that compare equal).
    public mutating func sort() {
        self = sorted()
    }

}

public extension Set where Element: Sortable {
    
    /// Return `Set` containing the sorted elements of `source`.
    ///
    /// The sorting algorithm is not stable (can change the relative order of
    /// elements that compare equal).
    public mutating func sort() {
        self = Set(sorted())
    }
    
}
