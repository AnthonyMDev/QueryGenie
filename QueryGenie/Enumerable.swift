//
//  Enumerable.swift
//
//  Created by Anthony Miller on 12/28/16.
//

import Foundation

/// An entity that can enumerated over, skipping and taking a number of items.
public protocol Enumerable {
    
    var offset: Int { get set }
    var limit: Int { get set }
    
}

extension Enumerable {
    
    /// Sets the offset of the receiver to skip a number of items.
    ///
    /// - Parameter count: The number of items to skip.
    /// - Returns: A copy of the receiver with the given offset.
    public func skip(_ count: Int) -> Self {
        var clone = self
        clone.offset = count
        
        return clone
    }
    
    /// Sets a limit of the number of items the receiver will retrieve.
    ///
    /// - Parameter count: The number of items to take.
    /// - Returns: A copy of the receiver with the given limit.
    public func take(_ count: Int) -> Self {
        var clone = self
        clone.limit = count
        
        return clone
    }
    
}
