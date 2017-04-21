//
//  CoreDataQueryable.swift
//
//  Created by Anthony Miller on 1/4/17.
//

import Foundation
import CoreData

/// A queryable entity that executes an `NSFetchRequest`.
public protocol CoreDataQueryable: GenericQueryable, Enumerable {
    
    associatedtype Element: NSFetchRequestResult
    
    /// The number items to fetch in each batch for the fetch request.
    var batchSize: Int { get set }

    /// The context the fetch request will be executed in.
    var context: NSManagedObjectContext { get }
    
    /// The entity description for the entity to be fetched.
    var entityDescription: NSEntityDescription { get }
    
    /// The predicate to execute the fetch request with.
    var predicate: NSPredicate? { get set }
    
    /// The sort descriptors to execute the fetch request with.
    var sortDescriptors: [NSSortDescriptor]? { get set }

    /// Creates an `NSFetchRequest` from the receiver.
    ///
    /// - Returns: A fetch request configured using the receiver.
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
