//
//  Results+ResultsProtocol.swift
//
//  Created by Anthony Miller on 12/29/16.
//  Copyright © 2016 App-Order. All rights reserved.
//

import Foundation

import RealmSwift

extension Results: ResultsProtocol {
    
    public func first() -> T? {
        return self.first
    }    
    
    /*
     *  MARK: - GenericQueryable
     */
    
    public final func objects() -> AnyCollection<Element> {
        return AnyCollection(self)
    }

}
