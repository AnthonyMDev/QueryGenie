//
//  UniqueIdentifiable+RealmObject.swift
//
//  Created by Anthony Miller on 12/29/16.
//

import Foundation
import RealmSwift

/*
 *  MARK: - Realm Object UniqueIdentifiable
 */

/// Provides default implementation for `primaryKey` on an `Object` that conforms to `UniqueIdentifiable`.
///
/// The value returned by the `Object` class function `primaryKey()` is used to derive the value.
extension UniqueIdentifiable where Self: Object, Self.UniqueIdentifierType == String {
    
    public static var primaryKey: Attribute<String> {
        return Attribute(Self.primaryKey() ?? "")
    }
    
}

extension UniqueIdentifiable where Self: Object, Self.UniqueIdentifierType == Int {
    
    public static var primaryKey: Attribute<Int> {
        return Attribute(Self.primaryKey() ?? "")
    }
    
}

/// Provides default implementation for `uniqueIdentifier` on an `Object` that conforms 
/// to `UniqueIdentifiable`.
extension UniqueIdentifiable where Self: Object {
    
    fileprivate var primaryKeyForKVC: String { return type(of: self).primaryKey.___name }
    
    public var uniqueIdentifier: UniqueIdentifierType {
        get {
            return value(forKey: primaryKeyForKVC) as! UniqueIdentifierType
        }
        set {
            setValue(newValue, forKey: primaryKeyForKVC)
        }
    }
    
}
