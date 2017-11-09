//
//  ResultsWrapper+ResultsProtocol.swift
//  QueryGenie
//
//  Created by Dominic Miller on 11/8/17.
//

import Foundation

import RealmSwift

private var _sortDescriptorsKey = "QueryGenie.sortDescriptors"

extension ResultsWrapper: ResultsProtocol {

    // MARK: - Queryable
    
    public final func objects() -> AnyCollection<T> {
        return AnyCollection(results)
    }
    
    // MARK: - SortedQueryable
    
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
