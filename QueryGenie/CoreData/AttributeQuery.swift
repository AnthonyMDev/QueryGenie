//
//  AttributeQuery.swift
//
//  Created by Anthony Miller on 1/4/17.
//

import Foundation
import CoreData

/// A concrete query that can be executed to fetch a dictionary of properties on core data objects.
public final struct AttributeQuery<T: NSDictionary>: AttributeQueryProtocol {
    
    public typealias Element = T
    
    public let context: NSManagedObjectContext
    public let entityDescription: NSEntityDescription
    
    public var offset: Int = 0
    public var limit: Int = 0
    public var batchSize: Int = 20
    
    public var predicate: NSPredicate? = nil
    public var sortDescriptors: [NSSortDescriptor]? = nil
    
    public var returnsDistinctResults = false
    public var propertiesToFetch = [String]()
    
    fileprivate init(context: NSManagedObjectContext, entityDescription: NSEntityDescription, offset: Int, limit: Int, batchSize: Int, predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?) {
        self.context = context
        self.entityDescription = entityDescription
        
        self.offset = offset
        self.limit = limit
        self.batchSize = batchSize
        self.predicate = predicate
        self.sortDescriptors = sortDescriptors
    }

}

/*
 *  MARK: - Table Extensions
 */

extension Table {
    
    // One Attribute
    public func select<P, A: AttributeProtocol>(_ closure: (T.Type) -> A) -> AttributeQuery<P> where A.ValueType == P {
        var attributeQuery = AttributeQuery<P>(
            context: self.context,
            entityDescription: self.entityDescription,
            offset: self.offset,
            limit: self.limit,
            batchSize: self.batchSize,
            predicate: self.predicate,
            sortDescriptors: self.sortDescriptors
        )
        
        attributeQuery.propertiesToFetch.append(closure(T.self).___name)
        
        return attributeQuery
    }

    // Multiple Attributes
    public func select(_ propertiesToFetch: [String]) -> AttributeQuery<NSDictionary> {
        var attributeQuery = AttributeQuery<NSDictionary>(
            context: self.context,
            entityDescription: self.entityDescription,
            offset: self.offset,
            limit: self.limit,
            batchSize: self.batchSize,
            predicate: self.predicate,
            sortDescriptors: self.sortDescriptors
        )
        
        attributeQuery.propertiesToFetch = propertiesToFetch
        
        return attributeQuery
    }

}
