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
        return Int(objects().count)        
    }
    
    public final func firstOrCreated(_ predicateClosure: (Self.Element.Type) -> NSComparisonPredicate) throws -> Self.Element {
        let predicate = predicateClosure(Self.Element.self)
        
        if let entity = self.filter(predicate).first() {
            return entity
            
        } else {
            guard let realm = realm else { throw RealmError.noRealm }
            
            let attributeName = predicate.leftExpression.keyPath
            let value: Any = predicate.rightExpression.constantValue!
            
            let entity = realm.create(Element.self, value: [attributeName: value], update: true)
            
            return entity
        }
    }
    
}
