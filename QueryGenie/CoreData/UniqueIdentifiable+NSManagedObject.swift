//
//  UniqueIdentifiable+NSManagedObject.swift
//
//  Created by Anthony Miller on 2/9/17.
//  Copyright (c) 2017 App-Order, LLC. All rights reserved.
//

import Foundation

import CoreData

/*
 *  MARK: - NSManagedObject UniqueIdentifiable
 */

/// Provides default implementation for `primaryKey` on an `Object` that conforms to `UniqueIdentifiable`.
///
/// The value returned by the `Object` class function `primaryKey()` is used to derive the value.
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
