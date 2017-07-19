//
//  TableProtocol.swift
//
//  Created by Anthony Miller on 1/4/17.
//

import Foundation
import CoreData

// An entity that represents a queryable table of objects for a type in a core data managed object context.
public protocol TableProtocol: CoreDataQueryable {
    
}

/*
 *  MARK: - Create, Delete, and Refresh
 */

extension TableProtocol where Self.Element: NSManagedObject {
    
    public func create() -> Self.Element {
        if #available(macOS 10.12, iOS 10.0, tvOS 10.0, watchOS 3.0, *) {
            return Self.Element(context: self.context)
        }
        else {
            return Self.Element(entity: self.entityDescription, insertInto: self.context)
        }
    }

    public func delete(_ entity: Self.Element) {
        self.context.delete(entity)
    }
    
    public func refresh(_ entity: Self.Element, mergeChanges: Bool = true) {
        self.context.refresh(entity, mergeChanges: mergeChanges)
    }

}

/*
 *  MARK: - Delete All
 */

extension TableProtocol {
    
    public func deleteAll() throws {
        let fetchRequest = self.toFetchRequest() as NSFetchRequest<NSManagedObjectID>
        fetchRequest.resultType = .managedObjectIDResultType
        
        let objectIDs: [NSManagedObjectID]
        
        if #available(macOS 10.12, iOS 10.0, tvOS 10.0, watchOS 3.0, *) {
            objectIDs = try fetchRequest.execute()
        }
        else {
            objectIDs = try self.context.fetch(fetchRequest)
        }
        
        for objectID in objectIDs {
            let object = try self.context.existingObject(with: objectID)
            self.context.delete(object)
        }
    }

}

extension TableProtocol where Self.Element: NSManagedObject {
    
    public func firstOrCreated(_ predicateClosure: (Self.Element.Type) -> NSComparisonPredicate) -> Self.Element {
        let predicate = predicateClosure(Self.Element.self)
        
        if let entity = self.filter(predicate).first() {
            return entity
        }
        else {
            let entity = self.create()
            
            let attributeName = predicate.leftExpression.keyPath
            let value: Any = predicate.rightExpression.constantValue!
            
            (entity as NSManagedObject).setValue(value, forKey: attributeName)
            
            return entity
        }
    }

}

/*
 *  MARK: - GenericQueryable
 */

extension TableProtocol {
    
    public func objects() -> AnyCollection<Self.Element> {
        do {
            return try AnyCollection(self.context.fetch(self.toFetchRequest() as NSFetchRequest<Self.Element>))
        }
        catch {
            return AnyCollection<Self.Element>([])
        }
    }
    
}

/*
 *  MARK: - CoreDataQueryable
 */

extension TableProtocol {
    
    public func toFetchRequest<ResultType: NSFetchRequestResult>() -> NSFetchRequest<ResultType> {
        let fetchRequest = NSFetchRequest<ResultType>()
        
        fetchRequest.entity = self.entityDescription
        
        fetchRequest.fetchOffset = self.offset
        fetchRequest.fetchLimit = self.limit
        fetchRequest.fetchBatchSize = (self.limit > 0 && self.batchSize > self.limit ? 0 : self.batchSize)
        
        fetchRequest.predicate = self.predicate
        fetchRequest.sortDescriptors = self.sortDescriptors
        
        return fetchRequest
    }
    
}
