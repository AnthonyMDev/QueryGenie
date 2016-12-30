//
//  Enumerable.swift
//
//  Created by Anthony Miller on 12/28/16.
//  Copyright © 2016 App-Order. All rights reserved.
//

import Foundation

// TODO: Document

public protocol Enumerable {
    
    var offset: Int { get set }
    var limit: Int { get set }
    
}

extension Enumerable {
    
    public final func skip(_ count: Int) -> Self {
        var clone = self
        clone.offset = count
        
        return clone
    }
    
    public final func take(_ count: Int) -> Self {
        var clone = self
        clone.limit = count
        
        return clone
    }
    
}
