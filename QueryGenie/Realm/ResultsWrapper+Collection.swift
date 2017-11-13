//
//  ResultsWrapper+Collection.swift
//  QueryGenie
//
//  Created by Dominic Miller on 11/9/17.
//

import Foundation

import RealmSwift

extension ResultsWrapper: Collection {
    
    public typealias Iterator = Results<T>.Iterator
    
    /// Returns the `Iterator for the `results.
    public func makeIterator() -> ResultsWrapper.Iterator {
        return results.makeIterator()
    }
    
    /// The position of the first element in a non-empty collection.
    /// Identical to endIndex in an empty collection.
    public var startIndex: Int {
        return results.startIndex
    }
    
    /// The collection's "past the end" position.
    /// endIndex is not a valid argument to subscript, and is always reachable from startIndex by
    /// zero or more applications of successor().
    public var endIndex: Int {
        return results.endIndex
    }
    
    public func index(after i: Int) -> Int {
        return results.index(after: i)
    }
    
    public func index(before i: Int) -> Int {
        return results.index(before: i)
    }
    
    /// :nodoc:
    public func _observe(_ block: @escaping (RealmCollectionChange<AnyRealmCollection<T>>) -> Void) ->
        NotificationToken {
            return results._observe(block)
    }
    
}
