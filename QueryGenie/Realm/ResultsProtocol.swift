//
//  ResultsProtocol.swift
//
//  Created by Anthony Miller on 12/28/16.
//

import Foundation
import RealmSwift

/// A query that is backed by a Realm `Results` object.
public protocol ResultsProtocol: RealmQueryable {
    
    func sum<U: AddableType>(ofProperty: String) -> U
    
    func min<U: MinMaxType>(ofProperty: String) -> U?
    
    func max<U: MinMaxType>(ofProperty: String) -> U?
    
    func average<U: AddableType>(ofProperty: String) -> U?
    
}

/*
 *  MARK: - Aggregate
 */

extension ResultsProtocol {
    
    public func sum<U: AddableType>(_ closure: (Self.Element.Type) -> Attribute<U>) -> U {
        let attribute = closure(Self.Element.self)
        return sum(ofProperty: attribute.___name)
    }
    
    public func min<U: MinMaxType>(_ closure: (Self.Element.Type) -> Attribute<U>) -> U? {
        let attribute = closure(Self.Element.self)
        return min(ofProperty: attribute.___name)
    }
    
    public func max<U: MinMaxType>(_ closure: (Self.Element.Type) -> Attribute<U>) -> U? {
        let attribute = closure(Self.Element.self)
        return max(ofProperty: attribute.___name)
    }
    
    public func average<U: AddableType>(_ closure: (Self.Element.Type) -> Attribute<U>) -> U? {
        let attribute = closure(Self.Element.self)
        return average(ofProperty: attribute.___name)
    }
    
}
