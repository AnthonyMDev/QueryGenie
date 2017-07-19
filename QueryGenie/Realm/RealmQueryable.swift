//
//  RealmQueryable.swift
//
//  Created by Anthony Miller on 12/28/16.
//

import Foundation

import RealmSwift

/// A query that can be executed to retrieve Realm `Objects`.
public protocol RealmQueryable: Queryable where Element: Object {
    
    var realm: Realm? { get }
    
    func setValue(_ value: Any?, forKey key: String)
    
}

// MARK: - Enumerable

extension RealmQueryable {
    
    public func count() -> Int {
        return Int(objects().count)        
    }
    
    public func firstOrCreated(_ predicateClosure: (Self.Element.Type) -> NSComparisonPredicate) throws -> Self.Element {
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
    
    private func setValue<T>(_ value: T, for attribute: Attribute<T>) {
        setValue(value, forKey: attribute.___name)
    }
    
    public func setValue<T>(_ value: T, for attributeClosure: (Self.Element.Type) -> Attribute<T>) {
        setValue(value, for: attributeClosure(Self.Element.self))
    }
    
    private func setValue<T>(_ value: T?, for attribute: NullableAttribute<T>) {
        setValue(value, forKey: attribute.___name)
    }
    
    public func setValue<T>(_ value: T?, for attributeClosure: (Self.Element.Type) -> NullableAttribute<T>) {
        setValue(value, for: attributeClosure(Self.Element.self))
    }
    
}
