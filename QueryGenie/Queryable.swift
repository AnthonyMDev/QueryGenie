//
//  Queryable.swift
//
//  Created by Anthony Miller on 12/28/16.
//  Copyright © 2016 App-Order. All rights reserved.
//

import Foundation

// TODO: Document

public protocol Queryable: Sequence {
    
    func filter(_ predicate: NSPredicate) -> Self
    
    func count() -> Int
    
}

/*
 *  MARK: - Is Empty
 */

extension Queryable {
    
    public final var isEmpty: Bool {
        return count() == 0
    }
    
}

extension Queryable where Self: Enumerable {
    
    public final var isEmpty: Bool {
        return take(1).count() == 0
    }
    
}
