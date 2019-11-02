//
//  Results+ResultsProtocol.swift
//  QueryGenie
//
//  Created by Dominic on 11/9/17.
//

import Foundation

import RealmSwift

private var _sortDescriptorsKey = "QueryGenie.sortDescriptors"

extension Results: ResultsProtocol {
    
    // MARK: - Queryable
    public func count() -> Int {
        return count
    }
    
    public func first() -> Element? {
        return first
    }
    
    // MARK: - SortedQueryable
    
    public func sorted(by keyPath: String, ascending: Bool) -> Results<Element> {
        let newSort = SortDescriptor(keyPath: keyPath, ascending: ascending)
        
        var sortDescriptors: [SortDescriptor] = self.sortDescriptors ?? []
        sortDescriptors.append(newSort)
        
        let newResults = sorted(by: sortDescriptors)
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
