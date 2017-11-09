//
//  Results+ResultsProtocol.swift
//
//  Created by Anthony Miller on 12/29/16.
//

import Foundation
import ObjectiveC

import RealmSwift

private var _sortDescriptorsKey = "QueryGenie.sortDescriptors"

public final class ResultsWrapper<T>: ResultsProtocol where T: Object {
    public let results: Results<T>
    public init(_ results: Results<T>) { self.results = results }
    
    public typealias Iterator = Results<T>.Iterator
    public func makeIterator() -> ResultsWrapper.Iterator {
        return results.makeIterator()
    }
    
    public func average<U>(ofProperty property: String) -> U? where U : AddableType {
        return results.average(ofProperty: property)
    }
    
    public func max<U>(ofProperty property: String) -> U? where U : MinMaxType {
        return results.max(ofProperty: property)
    }
    
    public func min<U>(ofProperty property: String) -> U? where U : MinMaxType {
        return results.min(ofProperty: property)
    }
    
    public func sum<U>(ofProperty property: String) -> U where U : AddableType {
        return results.sum(ofProperty: property)
    }
    
    public var realm: Realm? {
        return results.realm
    }
    
    public func filter(_ predicate: NSPredicate) -> ResultsWrapper<T> {
        return ResultsWrapper<T>(results.filter(predicate))
    }
    
    public func setValue(_ value: Any?, forKey key: String) {
    }
    
    public var first: T? {
        return results.first
    }
    
    public var count: Int {
        return results.count
    }
    
    /*
     *  MARK: - GenericQueryable
     */
    
    public final func objects() -> AnyCollection<T> {
        return AnyCollection(results)
    }
    
    public func sorted(by keyPath: String, ascending: Bool) -> ResultsWrapper<T> {
        let newSort = SortDescriptor(keyPath: keyPath, ascending: ascending)
        
        var sortDescriptors: [SortDescriptor] = self.sortDescriptors ?? []
        sortDescriptors.append(newSort)
        
        let newResults = ResultsWrapper<T>(results.sorted(by: sortDescriptors))
        newResults.sortDescriptors = sortDescriptors
        return newResults
    }
    
    private var sortDescriptors: [SortDescriptor]? {
        get {
            return objc_getAssociatedObject(self, &_sortDescriptorsKey) as? [SortDescriptor]
        }
        set {
            objc_setAssociatedObject(self, &_sortDescriptorsKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
}

extension ResultsWrapper: Collection {
    // MARK: Collection Support
    
    /// The position of the first element in a non-empty collection.
    /// Identical to endIndex in an empty collection.
    public var startIndex: Int { return 0 }
    
    /// The collection's "past the end" position.
    /// endIndex is not a valid argument to subscript, and is always reachable from startIndex by
    /// zero or more applications of successor().
    public var endIndex: Int { return results.count }
    
    public func index(after i: Int) -> Int { return i + 1 }
    public func index(before i: Int) -> Int { return i - 1 }
    
    public subscript(position: Int) -> T {
        return results[position]
    }
}

extension Object: Equatable {
    
    @objc open override func isEqual(_ object: Any?) -> Bool {
        if let object = object as? Object {
            return self.isSameObject(as: object)
        }
        return super.isEqual(object)
    }
    
//    public static func ==(lhs: Object, rhs: Object) -> Bool {
//        return lhs.isSameObject(as: rhs)
//    }
}
