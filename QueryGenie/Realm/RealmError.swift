//
//  RealmError.swift
//
//  Created by Anthony Miller on 12/29/16.
//

import Foundation

/// Errors that can be thrown when executing a query on a `RealmQueryable` entity.
///
/// - noRealm: The entity is not in a `Realm`.
public enum RealmError: Swift.Error {
    
    case noRealm
    
}
