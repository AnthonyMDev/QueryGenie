//
//  SortedQueryable.swift
//
//  Created by Anthony Miller on 12/29/16.
//  Copyright © 2016 App-Order. All rights reserved.
//

import Foundation

// TODO: Document

public protocol SortedQueryable: Queryable {
    
    func sorted(byProperty: String, ascending: Bool) -> Self
    
}

extension SortedQueryable {
    
    public final func sorted<A: AttributeProtocol>(by attribute: A, ascending: Bool) -> Self {
        return sorted(byProperty: attribute.___name, ascending: ascending)
    }
    
}
