//
//  RealmQueryable.swift
//  ZRModels
//
//  Created by Anthony Miller on 12/28/16.
//  Copyright © 2016 App-Order. All rights reserved.
//

import Foundation

import RealmSwift

// TODO: Document
public protocol RealmQueryable: GenericQueryable {
    
    associatedtype Element: Object
    
    var realm: Realm? { get }
    
}

// MARK: - Enumerable

extension RealmQueryable {
    
    public final func count() -> Int {
        // TODO: This is broken. wont respect filters
        return realm?.objects(Element.self).count ?? 0
    }
    
}
