//
//  Attribute.swift
//
//  Created by Anthony Miller on 12/28/16.
//

import Foundation

/*
 *  MARK: - Non-Nullable Attribute
 */

/// An attribute whose value is not nullable.
public struct Attribute<T>: AttributeProtocol {
    
    public typealias ValueType = T
    
    public let ___name: String
    
    public init(_ name: String) {
        self.___name = name
    }
    
    public init(_ name: String, _ parentAttribute: NamedAttributeProtocol) {
        self.___name = parentAttribute.___name + "." + name
    }
    
    public init<T>(_ attribute: Attribute<T>, _ parentAttribute: NamedAttributeProtocol) {
        self.init(attribute.___name, parentAttribute)
    }
    
}

/*
 *  MARK: - Nullable Attribute
 */

/// An attribute whose value is nullable (comparable to `nil`).
public struct NullableAttribute<T>: NullableAttributeProtocol {
    
    public typealias ValueType = T
    
    public let ___name: String
    
    public init(_ name: String) {
        self.___name = name
    }
    
    public init(_ name: String, _ parentAttribute: NamedAttributeProtocol) {
        self.___name = parentAttribute.___name + "." + name
    }
    
    public init<T>(_ attribute: NullableAttribute<T>, _ parentAttribute: NamedAttributeProtocol) {
        self.init(attribute.___name, parentAttribute)
    }
    
}

/*
 *  MARK: -  Attribute Extensions - Collection
 */

extension Attribute where T: Collection {
    
    public func count() -> Attribute<Int> {
        return Attribute<Int>("@count", self)
    }
    
    public func max<U>(_ closure: (T.Iterator.Element.Type) -> Attribute<U>) -> Attribute<U> {
        let innerAttribute = closure(T.Iterator.Element.self)
        return Attribute<U>("@max." + innerAttribute.___name, self)
    }
    
    public func min<U>(_ closure: (T.Iterator.Element.Type) -> Attribute<U>) -> Attribute<U> {
        let innerAttribute = closure(T.Iterator.Element.self)
        return Attribute<U>("@min." + innerAttribute.___name, self)
    }
    
    public func average<U>(_ closure: (T.Iterator.Element.Type) -> Attribute<U>) -> Attribute<U> {
        let innerAttribute = closure(T.Iterator.Element.self)
        return Attribute<U>("@avg." + innerAttribute.___name, self)
    }
    
    public func sum<U>(_ closure: (T.Iterator.Element.Type) -> Attribute<U>) -> Attribute<U> {
        let innerAttribute = closure(T.Iterator.Element.self)
        return Attribute<U>("@sum." + innerAttribute.___name, self)
    }
    
}
