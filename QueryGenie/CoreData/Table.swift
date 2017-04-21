//
//  Table.swift
//
//  Created by Anthony Miller on 1/4/17.
//

import Foundation
import CoreData

// A concrete query that can be executed to fetch a collection of core data objects.
public final struct Table<T: NSManagedObject>: TableProtocol {
  
  public typealias Element = T
  
  public let context: NSManagedObjectContext
  public let entityDescription: NSEntityDescription
  
  public var offset: Int = 0
  public var limit: Int = 0
  public var batchSize: Int = 20
  
  public var predicate: NSPredicate? = nil
  public var sortDescriptors: [NSSortDescriptor]? = nil
  
  public init(context: NSManagedObjectContext) {
    self.context = context
    self.entityDescription = context.persistentStoreCoordinator!
      .cachedEntityDescription(for: context, managedObjectType: T.self)
  }
  
}

// MARK: - CachedEntityDescriptions

extension NSPersistentStoreCoordinator {
  
  private struct AssociatedKeys {
    static var CachedEntityDescriptions = "QueryGenie_cachedEntityDescriptions"
  }
  
  private var cachedEntityDescriptions: [String : NSEntityDescription] {
    get {
      return objc_getAssociatedObject(self, &AssociatedKeys.CachedEntityDescriptions)
        as? [String : NSEntityDescription] ?? [:]
    }
    set {
      objc_setAssociatedObject(
        self,
        &AssociatedKeys.CachedEntityDescriptions,
        newValue as NSDictionary?,
        .OBJC_ASSOCIATION_RETAIN_NONATOMIC
      )
    }
  }
  
  fileprivate func cachedEntityDescription(for context: NSManagedObjectContext, managedObjectType: NSManagedObject.Type) -> NSEntityDescription {
    let dataContextClassName = String(describing: type(of: context))
    let managedObjectClassName = String(describing: managedObjectType)
    let cacheKey = "\(dataContextClassName)|\(managedObjectClassName)"
    
    let entityDescription: NSEntityDescription
    
    if let cachedEntityDescription = cachedEntityDescriptions[cacheKey] {
      entityDescription = cachedEntityDescription
    }
    else {
      
      entityDescription =
        managedObjectModel.entities
          .filter({
            $0.managedObjectClassName.components(separatedBy: ".").last! == managedObjectClassName
          })
          .first!
      
      cachedEntityDescriptions[cacheKey] = entityDescription
    }
    
    return entityDescription
  }
  
}
