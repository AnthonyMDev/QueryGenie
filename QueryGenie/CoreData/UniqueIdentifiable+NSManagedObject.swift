//
//  UniqueIdentifiable+NSManagedObject.swift
//
//  Created by Anthony Miller on 2/9/17.
//

import Foundation

import CoreData

/// Provides a default implementation for `uniqueIdentifier` on an `NSManagedObject` that conforms
/// to `UniqueIdentifiable`.
extension UniqueIdentifiable where Self: NSManagedObject {
    
    var uniqueIdentifier: UniqueIdentifierType {
        get {
            return value(forKey: primaryKeyForKVC) as! UniqueIdentifierType
        }
        set {
            setValue(newValue, forKey: primaryKeyForKVC)
        }
    }
    
    private var primaryKeyForKVC: String { return type(of: self).primaryKey.___name }
    
}
