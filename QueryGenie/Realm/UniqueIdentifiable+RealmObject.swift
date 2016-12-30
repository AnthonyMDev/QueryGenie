//
//  UniqueIdentifiable+RealmObject.swift
//
//  Created by Anthony Miller on 12/29/16.
//  Copyright (c) 2016 App-Order, LLC. All rights reserved.
//

import Foundation
import RealmSwift

/*
 *  MARK: - Realm Object UniqueIdentifiable
 */

/// Provides default implementation for `primaryKey` on an `Object` that conforms to `UniqueIdentifiable`.
///
/// The value returned by the `Object` class function `primaryKey()` is used to derive the value.
extension UniqueIdentifiable where Self: Object {
    
    public static var primaryKey: String {
        return Self.primaryKey() ?? ""
    }
    
}
