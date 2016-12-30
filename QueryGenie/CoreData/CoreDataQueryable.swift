//
//  CoreDataQueryable.swift
//  ZRCoreData
//
//  Copyright (c) 2016 App-Order, LLC. All rights reserved.
//

import Foundation
import CoreData

// TODO: Document

public protocol CoreDataQueryable: GenericQueryable, Enumerable {
    
    associatedtype Element: NSFetchRequestResult
    
    var batchSize: Int { get set }

    var context: NSManagedObjectContext { get }
    var entityDescription: NSEntityDescription { get }
    
    var predicate: NSPredicate? { get set }
    var sortDescriptors: [NSSortDescriptor]? { get set }

    func toFetchRequest<ResultType: NSFetchRequestResult>() -> NSFetchRequest<ResultType>
    
}

/*
 *  MARK: - Queryable
 */

extension CoreDataQueryable {
    
    public final func filter(_ predicate: NSPredicate) -> Self {
        var clone = self
        
        if let existingPredicate = clone.predicate {
            clone.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [existingPredicate, predicate])
            
        } else {
            clone.predicate = predicate
        }
        
        return clone
    }
    
    
    public final func count() -> Int {
        do {
            let count = try self.context.count(for: self.toFetchRequest() as NSFetchRequest<Self.Element>)
            return count == NSNotFound ? 0 : count
            
        } catch {
            return 0
        }
    }
    
}

/*
 *  MARK: - Aggregate
 */

extension CoreDataQueryable {
    
    public final func sum<U>(_ closure: (Self.Element.Type) -> Attribute<U>) throws -> U {
        let attribute = closure(Self.Element.self)
        return try self.aggregate(withFunctionName: "sum", attribute: attribute)
    }
    
    public final func min<U>(_ closure: (Self.Element.Type) -> Attribute<U>) throws -> U {
        let attribute = closure(Self.Element.self)
        return try self.aggregate(withFunctionName: "min", attribute: attribute)
    }
    
    public final func max<U>(_ closure: (Self.Element.Type) -> Attribute<U>) throws -> U {
        let attribute = closure(Self.Element.self)
        return try self.aggregate(withFunctionName: "max", attribute: attribute)
    }

    public final func average<U>(_ closure: (Self.Element.Type) -> Attribute<U>) throws -> U {
        let attribute = closure(Self.Element.self)
        return try self.aggregate(withFunctionName: "average", attribute: attribute)
    }
    
    private final func aggregate<U>(withFunctionName functionName: String, attribute: Attribute<U>) throws -> U {
        let attributeDescription = self.entityDescription.attributesByName[attribute.___name]!
        
        let keyPathExpression = NSExpression(forKeyPath: attribute.___name)
        let functionExpression = NSExpression(forFunction: "\(functionName):", arguments: [keyPathExpression])
        
        let expressionDescription = NSExpressionDescription()
        expressionDescription.name = "___\(functionName)"
        expressionDescription.expression = functionExpression
        expressionDescription.expressionResultType = attributeDescription.attributeType
        
        let fetchRequest = self.toFetchRequest() as NSFetchRequest<NSDictionary>
        fetchRequest.propertiesToFetch =  [expressionDescription]
        fetchRequest.resultType = NSFetchRequestResultType.dictionaryResultType
        
        let results: [NSDictionary]
        
        if #available(macOS 10.12, iOS 10.0, tvOS 10.0, watchOS 3.0, *) {
            results = try fetchRequest.execute()
        }
        else {
            results = try self.context.fetch(fetchRequest)
        }
        
        guard let firstResult = results.first else { throw Error.unexpectedValue(results) }
        
        guard let anyObjectValue = firstResult.value(forKey: expressionDescription.name)
            else { throw Error.unexpectedValue(firstResult) }
        
        guard let value = anyObjectValue as? U else { throw Error.unexpectedValue(anyObjectValue) }
        
        return value
    }
    
}
