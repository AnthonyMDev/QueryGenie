//
//  Results+ResultsProtocol.swift
//
//  Created by Anthony Miller on 12/29/16.
//

import Foundation
import ObjectiveC

import RealmSwift

private var _sortDescriptorsKey = "QueryGenie.sortDescriptors"

extension Results: ResultsProtocol {
    
    public func first() -> T? {
        return self.first
    }    
    
    /*
     *  MARK: - GenericQueryable
     */
    
    public final func objects() -> AnyCollection<Element> {
        return AnyCollection(self)
    }
    
    public func sorted(by keyPath: String, ascending: Bool) -> Results<T> {
        let newSort = SortDescriptor(keyPath: keyPath, ascending: ascending)
        
        var sortDescriptors: [SortDescriptor] = self.sortDescriptors ?? []
        sortDescriptors.append(newSort)
        
        let newResults = self.sorted(by: sortDescriptors)
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
