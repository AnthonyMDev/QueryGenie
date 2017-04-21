//
//  Error.swift
//
//  Created by Anthony Miller on 12/28/16.
//

import Foundation

/// An error that can be thrown by a query.
///
/// - unexpectedValue: The type of the resulting value from a query was not the expected type.
public enum Error: Swift.Error {
    case unexpectedValue(Any)
}
