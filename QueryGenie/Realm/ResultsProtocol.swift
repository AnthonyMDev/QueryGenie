//
//  ResultsProtocol.swift
//
//  Created by Anthony Miller on 12/28/16.
//  Copyright © 2016 App-Order. All rights reserved.
//

import Foundation
import RealmSwift

// TODO: Document
public protocol ResultsProtocol: RealmQueryable, SortedQueryable {
    
    func sum<U: AddableType>(ofProperty: String) -> U
    
    func min<U: MinMaxType>(ofProperty: String) -> U?
    
    func max<U: MinMaxType>(ofProperty: String) -> U?
    
    func average<U: AddableType>(ofProperty: String) -> U?
    
}

/*
 *  MARK: - Aggregate
 */

extension ResultsProtocol {
    
    public final func sum<U: AddableType>(_ closure: (Self.Element.Type) -> Attribute<U>) -> U {
        let attribute = closure(Self.Element.self)
        return sum(ofProperty: attribute.___name)
    }
    
    public final func min<U: MinMaxType>(_ closure: (Self.Element.Type) -> Attribute<U>) -> U? {
        let attribute = closure(Self.Element.self)
        return min(ofProperty: attribute.___name)
    }
    
    public final func max<U: MinMaxType>(_ closure: (Self.Element.Type) -> Attribute<U>) -> U? {
        let attribute = closure(Self.Element.self)
        return max(ofProperty: attribute.___name)
    }
    
    public final func average<U: AddableType>(_ closure: (Self.Element.Type) -> Attribute<U>) -> U? {
        let attribute = closure(Self.Element.self)
        return average(ofProperty: attribute.___name)
    }
    
}
