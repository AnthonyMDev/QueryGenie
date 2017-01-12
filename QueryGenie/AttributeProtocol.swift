//
//  AttributeProtocol.swift
//
//  Created by Anthony Miller on 12/28/16.
//  Copyright (c) 2016 App-Order, LLC. All rights reserved.
//

import Foundation

/// An attribute that has a name.
public protocol NamedAttributeProtocol {
    
    // These properties have underscores as prefix to not conflict with entity property names.
    
    var ___name: String { get }
    var ___expression: NSExpression { get }
    
}

/// An attribute that has a name, an associated value type and that can not be compared to `nil`.
public protocol AttributeProtocol: NamedAttributeProtocol {
    
    /// The associated value type.
    associatedtype ValueType
    
}

/// An attribute that has a name, an associated value type and that can be compared to `nil`.
public protocol NullableAttributeProtocol: AttributeProtocol {
    
}

/*
 *  MARK: - Public Protocol Extensions - Default Implementations
 */

extension AttributeProtocol {
    
    public final var ___expression: NSExpression {
        return NSExpression(forKeyPath: self.___name)
    }
    
}

/*
 *  MARK: - Internal Protocol Extensions
 */

extension AttributeProtocol {
    
    internal final var ___comparisonPredicateOptions: NSComparisonPredicate.Options {
        if Self.ValueType.self is StringProtocol.Type {
            return [.caseInsensitive]
        }
        else {
            return NSComparisonPredicate.Options()
        }
    }
    
}

/*
 *  MARK: - Public Protocol Extensions
 */

extension AttributeProtocol {
    
    public final func isIn(_ values: [Self.ValueType]) -> NSComparisonPredicate {
        let rightExpressionConstantValue = values.map { toNSObject($0) }
        let rightExpression = NSExpression(forConstantValue: rightExpressionConstantValue)
        
        return NSComparisonPredicate(
            leftExpression: self.___expression,
            rightExpression: rightExpression,
            modifier: .direct,
            type: .in,
            options: self.___comparisonPredicateOptions
        )
    }
    
}

// MARK: Equatable

extension AttributeProtocol where Self.ValueType: Equatable {
    
    public final func isEqualTo(_ value: Self.ValueType) -> NSComparisonPredicate {
        return NSComparisonPredicate(
            leftExpression: self.___expression,
            rightExpression: NSExpression.expression(for: value),
            modifier: .direct,
            type: .equalTo,
            options: self.___comparisonPredicateOptions
        )
    }
    
    public final func isEqualTo<T: AttributeProtocol>(_ otherAttribute: T) -> NSComparisonPredicate where T.ValueType == Self.ValueType {
        return NSComparisonPredicate(
            leftExpression: self.___expression,
            rightExpression: otherAttribute.___expression,
            modifier: .direct,
            type: .equalTo,
            options: self.___comparisonPredicateOptions
        )
    }
    
    public final func isNotEqualTo(_ value: Self.ValueType) -> NSComparisonPredicate {
        return NSComparisonPredicate(
            leftExpression: self.___expression,
            rightExpression: NSExpression.expression(for: value),
            modifier: .direct,
            type: .notEqualTo,
            options: self.___comparisonPredicateOptions
        )
    }
    
    public final func isNotEqualTo<T: AttributeProtocol>(_ otherAttribute: T) -> NSComparisonPredicate where T.ValueType == Self.ValueType {
        return NSComparisonPredicate(
            leftExpression: self.___expression,
            rightExpression: otherAttribute.___expression,
            modifier: .direct,
            type: .notEqualTo,
            options: self.___comparisonPredicateOptions
        )
    }
    
}

extension NullableAttributeProtocol where Self.ValueType: Equatable {
    
    public final func isEqualTo(_ value: ValueType?) -> NSComparisonPredicate {
        return NSComparisonPredicate(
            leftExpression: self.___expression,
            rightExpression: NSExpression.expression(for: value),
            modifier: .direct,
            type: .equalTo,
            options: self.___comparisonPredicateOptions
        )
    }
    
    public final func isNotEqualTo(_ value: ValueType?) -> NSComparisonPredicate {
        return NSComparisonPredicate(
            leftExpression: self.___expression,
            rightExpression: NSExpression.expression(for: value),
            modifier: .direct,
            type: .notEqualTo,
            options: self.___comparisonPredicateOptions
        )
    }
    
}

// MARK: Comparable

extension AttributeProtocol where Self.ValueType: Comparable {
    
    public final func isGreaterThan(_ value: Self.ValueType) -> NSComparisonPredicate {
        return NSComparisonPredicate(
            leftExpression: self.___expression,
            rightExpression: NSExpression.expression(for: value),
            modifier: .direct,
            type: .greaterThan,
            options: self.___comparisonPredicateOptions
        )
    }
    
    public final func isGreaterThan<T: AttributeProtocol>(_ otherAttribute: T) -> NSComparisonPredicate where T.ValueType == Self.ValueType {
        return NSComparisonPredicate(
            leftExpression: self.___expression,
            rightExpression: otherAttribute.___expression,
            modifier: .direct,
            type: .greaterThan,
            options: self.___comparisonPredicateOptions
        )
    }
    
    public final func isGreaterThanOrEqualTo(_ value: Self.ValueType) -> NSComparisonPredicate {
        return NSComparisonPredicate(
            leftExpression: self.___expression,
            rightExpression: NSExpression.expression(for: value),
            modifier: .direct,
            type: .greaterThanOrEqualTo,
            options: self.___comparisonPredicateOptions
        )
    }
    
    public final func isGreaterThanOrEqualTo<T: AttributeProtocol>(_ otherAttribute: T) -> NSComparisonPredicate where T.ValueType == Self.ValueType {
        return NSComparisonPredicate(
            leftExpression: self.___expression,
            rightExpression: otherAttribute.___expression,
            modifier: .direct,
            type: .greaterThanOrEqualTo,
            options: self.___comparisonPredicateOptions
        )
    }
    
    public final func isLessThan(_ value: Self.ValueType) -> NSComparisonPredicate {
        return NSComparisonPredicate(
            leftExpression: self.___expression,
            rightExpression: NSExpression.expression(for: value),
            modifier: .direct,
            type: .lessThan,
            options: self.___comparisonPredicateOptions
        )
    }
    
    public final func isLessThan<T: AttributeProtocol>(_ otherAttribute: T) -> NSComparisonPredicate where T.ValueType == Self.ValueType {
        return NSComparisonPredicate(
            leftExpression: self.___expression,
            rightExpression: otherAttribute.___expression,
            modifier: .direct,
            type: .lessThan,
            options: self.___comparisonPredicateOptions
        )
    }
    
    public final func isLessThanOrEqualTo(_ value: Self.ValueType) -> NSComparisonPredicate {
        return NSComparisonPredicate(
            leftExpression: self.___expression,
            rightExpression: NSExpression.expression(for: value),
            modifier: .direct,
            type: .lessThanOrEqualTo,
            options: self.___comparisonPredicateOptions
        )
    }
    
    public final func isLessThanOrEqualTo<T: AttributeProtocol>(_ otherAttribute: T) -> NSComparisonPredicate where T.ValueType == Self.ValueType {
        return NSComparisonPredicate(
            leftExpression: self.___expression,
            rightExpression: otherAttribute.___expression,
            modifier: .direct,
            type: .lessThanOrEqualTo,
            options: self.___comparisonPredicateOptions
        )
    }
    
    public final func isBetween(_ range: Range<ValueType>) -> NSComparisonPredicate {
        let rightExpressionConstantValue = [toNSObject(range.lowerBound), toNSObject(range.upperBound)] as NSArray
        let rightExpression = NSExpression(forConstantValue: rightExpressionConstantValue)
        
        return NSComparisonPredicate(
            leftExpression: self.___expression,
            rightExpression: rightExpression,
            modifier: .direct,
            type: .between,
            options: self.___comparisonPredicateOptions
        )
    }
    
}

// MARK: String

extension AttributeProtocol where Self.ValueType: StringProtocol {
    
    public final func isLike(_ value: Self.ValueType) -> NSComparisonPredicate {
        return NSComparisonPredicate(
            leftExpression: self.___expression,
            rightExpression: NSExpression.expression(for: value),
            modifier: .direct,
            type: .like,
            options: self.___comparisonPredicateOptions
        )
    }
    
    public final func isIn(_ value: Self.ValueType) -> NSComparisonPredicate {
        return NSComparisonPredicate(
            leftExpression: self.___expression,
            rightExpression: NSExpression.expression(for: value),
            modifier: .direct,
            type: .in,
            options: self.___comparisonPredicateOptions
        )
    }
    
    public final func contains(_ value: Self.ValueType) -> NSComparisonPredicate {
        return NSComparisonPredicate(
            leftExpression: self.___expression,
            rightExpression: NSExpression.expression(for: value),
            modifier: .direct,
            type: .contains,
            options: self.___comparisonPredicateOptions
        )
    }
    
    public final func contains<T: AttributeProtocol>(_ otherAttribute: T) -> NSComparisonPredicate where T.ValueType == Self.ValueType {
        return NSComparisonPredicate(
            leftExpression: self.___expression,
            rightExpression: otherAttribute.___expression,
            modifier: .direct,
            type: .contains,
            options: self.___comparisonPredicateOptions
        )
    }
    
    public final func beginsWith(_ value: Self.ValueType) -> NSComparisonPredicate {
        return NSComparisonPredicate(
            leftExpression: self.___expression,
            rightExpression: NSExpression.expression(for: value),
            modifier: .direct,
            type: .beginsWith,
            options: self.___comparisonPredicateOptions
        )
    }
    
    public final func beginsWith<T: AttributeProtocol>(_ otherAttribute: T) -> NSComparisonPredicate where T.ValueType == Self.ValueType {
        return NSComparisonPredicate(
            leftExpression: self.___expression,
            rightExpression: otherAttribute.___expression,
            modifier: .direct,
            type: .beginsWith,
            options: self.___comparisonPredicateOptions
        )
    }
    
    public final func endsWith(_ value: Self.ValueType) -> NSComparisonPredicate {
        return NSComparisonPredicate(
            leftExpression: self.___expression,
            rightExpression: NSExpression.expression(for: value),
            modifier: .direct,
            type: .endsWith,
            options: self.___comparisonPredicateOptions
        )
    }
    
    public final func endsWith<T: AttributeProtocol>(_ otherAttribute: T) -> NSComparisonPredicate where T.ValueType == Self.ValueType {
        return NSComparisonPredicate(
            leftExpression: self.___expression,
            rightExpression: otherAttribute.___expression,
            modifier: .direct,
            type: .endsWith,
            options: self.___comparisonPredicateOptions
        )
    }
    
    public final func matches(_ regularExpressionString: String) -> NSComparisonPredicate {
        return NSComparisonPredicate(
            leftExpression: self.___expression,
            rightExpression: NSExpression(forConstantValue: regularExpressionString),
            modifier: .direct,
            type: .matches,
            options: self.___comparisonPredicateOptions
        )
    }
    
}

// MARK: Boolean

extension AttributeProtocol where Self.ValueType: ExpressibleByBooleanLiteral {
    
    public final func not() -> NSComparisonPredicate {
        return NSComparisonPredicate(
            leftExpression: self.___expression,
            rightExpression: NSExpression(forConstantValue: NSNumber(value: false)),
            modifier: .direct,
            type: .equalTo,
            options: self.___comparisonPredicateOptions
        )
    }
    
}

// MARK: Collection

extension AttributeProtocol where Self.ValueType: Collection {
    
    public final func any(_ predicateClosure: (Self.ValueType.Iterator.Element.Type) -> NSComparisonPredicate) -> NSComparisonPredicate {
        let p = predicateClosure(Self.ValueType.Iterator.Element.self)
        
        var leftExpression = p.leftExpression
        if leftExpression.expressionType == .keyPath {
            leftExpression = NSExpression(forKeyPath: "\(self.___name).\(leftExpression.keyPath)")
        }
        
        var rightExpression = p.rightExpression
        if rightExpression.expressionType == .keyPath {
            rightExpression = NSExpression(forKeyPath: "\(self.___name).\(rightExpression.keyPath)")
        }
        
        return NSComparisonPredicate(
            leftExpression: leftExpression,
            rightExpression: rightExpression,
            modifier: .any,
            type: p.predicateOperatorType,
            options: p.options
        )
    }
    
    public final func all(_ predicateClosure: (Self.ValueType.Iterator.Element.Type) -> NSComparisonPredicate) -> NSComparisonPredicate {
        let p = predicateClosure(Self.ValueType.Iterator.Element.self)
        
        var leftExpression = p.leftExpression
        if leftExpression.expressionType == .keyPath {
            leftExpression = NSExpression(forKeyPath: "\(self.___name).\(leftExpression.keyPath)")
        }
        
        var rightExpression = p.rightExpression
        if rightExpression.expressionType == .keyPath {
            rightExpression = NSExpression(forKeyPath: "\(self.___name).\(rightExpression.keyPath)")
        }
        
        return NSComparisonPredicate(
            leftExpression: leftExpression,
            rightExpression: rightExpression,
            modifier: .all,
            type: p.predicateOperatorType,
            options: p.options
        )
    }
    
    public final func none(_ predicateClosure: (Self.ValueType.Iterator.Element.Type) -> NSComparisonPredicate) -> NSPredicate {
        let p = predicateClosure(Self.ValueType.Iterator.Element.self)
        
        var leftExpression = p.leftExpression
        if leftExpression.expressionType == .keyPath {
            leftExpression = NSExpression(forKeyPath: "\(self.___name).\(leftExpression.keyPath)")
        }
        
        var rightExpression = p.rightExpression
        if rightExpression.expressionType == .keyPath {
            rightExpression = NSExpression(forKeyPath: "\(self.___name).\(rightExpression.keyPath)")
        }
        
        let allPredicate = NSComparisonPredicate(
            leftExpression: leftExpression,
            rightExpression: rightExpression,
            modifier: .all,
            type: p.predicateOperatorType,
            options: p.options
        )
                
        let format = "NONE" + (allPredicate.description as NSString).substring(from: 3)
        
        return NSPredicate(format: format)
    }
    
}

// MARK: UniqueIdentifiable

public extension AttributeProtocol where ValueType: UniqueIdentifiable {
    
    /// An `Attribute` for accessing the `primaryKey` of the `ValueType` of the receiver.
    public var primaryKey: Attribute<ValueType.UniqueIdentifierType> {
        return Attribute<ValueType.UniqueIdentifierType>(type(of: self).ValueType.primaryKey.___name, self)
    }
    
}

/*
 *  MARK: - Convenience Operators
 */

public func == <A: AttributeProtocol, V>(left: A, right: V) -> NSComparisonPredicate where A.ValueType: Equatable, A.ValueType == V {
    return left.isEqualTo(right)
}

public func == <L: AttributeProtocol, R: AttributeProtocol>(left: L, right: R) -> NSComparisonPredicate where L.ValueType: Equatable, L.ValueType == R.ValueType {
    return left.isEqualTo(right)
}

public func == <A: NullableAttributeProtocol, V>(left: A, right: V?) -> NSComparisonPredicate where A.ValueType: Equatable, A.ValueType == V {
    return left.isEqualTo(right)
}

public func == <A:AttributeProtocol, V: UniqueIdentifiable>(left: A, right: V) -> NSComparisonPredicate where A.ValueType: UniqueIdentifiable, A.ValueType.UniqueIdentifierType == V.UniqueIdentifierType {
    return left.primaryKey.isEqualTo(right.uniqueIdentifier)
}

public func == <A:AttributeProtocol>(left: A, right: A) -> NSComparisonPredicate where A.ValueType: UniqueIdentifiable {
    return left.primaryKey.isEqualTo(right.primaryKey)
}

public func == <A:NullableAttributeProtocol, V: UniqueIdentifiable>(left: A, right: V) -> NSComparisonPredicate where A.ValueType: UniqueIdentifiable, A.ValueType.UniqueIdentifierType == V.UniqueIdentifierType {
    return left.primaryKey.isEqualTo(right.uniqueIdentifier)
}

public func == <A:NullableAttributeProtocol>(left: A, right: A) -> NSComparisonPredicate where A.ValueType: UniqueIdentifiable {
    return left.primaryKey.isEqualTo(right.primaryKey)
}

public func != <A: AttributeProtocol, V>(left: A, right: V) -> NSComparisonPredicate where A.ValueType: Equatable, A.ValueType == V {
    return left.isNotEqualTo(right)
}

public func != <L: AttributeProtocol, R: AttributeProtocol>(left: L, right: R) -> NSComparisonPredicate where L.ValueType: Equatable, L.ValueType == R.ValueType {
    return left.isNotEqualTo(right)
}

public func != <A: NullableAttributeProtocol, V>(left: A, right: V?) -> NSComparisonPredicate where A.ValueType: Equatable, A.ValueType == V {
    return left.isNotEqualTo(right)
}

public func > <A: AttributeProtocol, V>(left: A, right: V) -> NSComparisonPredicate where A.ValueType: Comparable, A.ValueType == V {
    return left.isGreaterThan(right)
}

public func > <L: AttributeProtocol, R: AttributeProtocol>(left: L, right: R) -> NSComparisonPredicate where L.ValueType: Comparable, L.ValueType == R.ValueType {
    return left.isGreaterThan(right)
}

public func >= <A: AttributeProtocol, V>(left: A, right: V) -> NSComparisonPredicate where A.ValueType: Comparable, A.ValueType == V {
    return left.isGreaterThanOrEqualTo(right)
}

public func >= <L: AttributeProtocol, R: AttributeProtocol>(left: L, right: R) -> NSComparisonPredicate where L.ValueType: Comparable, L.ValueType == R.ValueType {
    return left.isGreaterThanOrEqualTo(right)
}

public func < <A: AttributeProtocol, V>(left: A, right: V) -> NSComparisonPredicate where A.ValueType: Comparable, A.ValueType == V {
    return left.isLessThan(right)
}

public func < <L: AttributeProtocol, R: AttributeProtocol>(left: L, right: R) -> NSComparisonPredicate where L.ValueType: Comparable, L.ValueType == R.ValueType {
    return left.isLessThan(right)
}

public func <= <A: AttributeProtocol, V>(left: A, right: V) -> NSComparisonPredicate where A.ValueType: Comparable, A.ValueType == V {
    return left.isLessThanOrEqualTo(right)
}

public func <= <L: AttributeProtocol, R: AttributeProtocol>(left: L, right: R) -> NSComparisonPredicate where L.ValueType: Comparable, L.ValueType == R.ValueType {
    return left.isLessThanOrEqualTo(right)
}

public func ~= <A: AttributeProtocol, V>(left: A, right: V) -> NSComparisonPredicate where A.ValueType: StringProtocol, A.ValueType == V {
    return left.isLike(right)
}

public func << <A: AttributeProtocol, V>(left: A, right: V) -> NSComparisonPredicate where A.ValueType: StringProtocol, A.ValueType == V {
    return left.isIn(right)
}

public func << <A: AttributeProtocol, V>(left: A, right: [V]) -> NSComparisonPredicate where A.ValueType == V {
    return left.isIn(right)
}

public func << <A: AttributeProtocol, V: Comparable>(left: A, right: Range<V>) -> NSComparisonPredicate where A.ValueType == V {
    return left.isBetween(right)
}

prefix public func ! <A: AttributeProtocol>(left: A) -> NSComparisonPredicate where A.ValueType: ExpressibleByBooleanLiteral {
    return left.not()
}

/*
 *  MARK: - Helper Protocols
 */

public protocol StringProtocol {}
extension String: StringProtocol {}
extension NSString: StringProtocol {}

/*
 *  MARK: - NSExpression Extensions
 */

fileprivate extension NSExpression {
    
    class func expression<T>(for value: T) -> NSExpression {
        let object: NSObject = toNSObject(value)
        return NSExpression(forConstantValue: (object is NSNull ? nil : object))
    }
    
}

/*
 *  MARK: - Value Conversion
 */

private func toNSObject<T>(_ value: T) -> NSObject {
    //
    if let v = value as? NSObject {
        return v
    }
    else if let v = value as? Int {
        return NSNumber(value: v)
    }
    else if let v = value as? Int64 {
        return NSNumber(value: v)
    }
    else if let v = value as? Int32 {
        return NSNumber(value: v)
    }
    else if let v = value as? Int16 {
        return NSNumber(value: v)
    }
    else if let v = value as? Int8 {
        return NSNumber(value: v)
    }
    else if let v = value as? Double {
        return NSNumber(value: v)
    }
    else if let v = value as? Float {
        return NSNumber(value: v)
    }
    else if let v = value as? Bool {
        return NSNumber(value: v)
    }
    else if let v = value as? String {
        return v as NSString
    }
    else if let v = value as? Date {
        return v as NSDate
    }
    else if let v = value as? Data {
        return v as NSData
    }
    else {
        // The value may be an optional, so we have to test the optional object type, one by one
        let mirror = Mirror(reflecting: value)
        if mirror.displayStyle == .optional {
            let dt = type(of: value)
            
            // Reference Types
            if dt is NSObject?.Type {
                if let v = unsafeBitCast(value, to: Optional<NSObject>.self) {
                    return v
                }
            }
            else if dt is NSDecimalNumber?.Type {
                if let v = unsafeBitCast(value, to: Optional<NSDecimalNumber>.self) {
                    return v
                }
            }
            else if dt is NSNumber?.Type {
                if let v = unsafeBitCast(value, to: Optional<NSNumber>.self) {
                    return v
                }
            }
            else if dt is NSString?.Type {
                if let v = unsafeBitCast(value, to: Optional<NSString>.self) {
                    return v
                }
            }
            else if dt is NSDate?.Type {
                if let v = unsafeBitCast(value, to: Optional<NSDate>.self) {
                    return v
                }
            }
            else if dt is NSData?.Type {
                if let v = unsafeBitCast(value, to: Optional<NSData>.self) {
                    return v
                }
            }
            
            // Value Types
            if dt is Int?.Type {
                if let v = unsafeBitCast(value, to: Optional<Int>.self) {
                    return NSNumber(value: v)
                }
            }
            else if dt is Int64?.Type {
                if let v = unsafeBitCast(value, to: Optional<Int64>.self) {
                    return NSNumber(value: v)
                }
            }
            else if dt is Int32?.Type {
                if let v = unsafeBitCast(value, to: Optional<Int32>.self) {
                    return NSNumber(value: v)
                }
            }
            else if dt is Int16?.Type {
                if let v = unsafeBitCast(value, to: Optional<Int16>.self) {
                    return NSNumber(value: v)
                }
            }
            else if dt is Int8?.Type {
                if let v = unsafeBitCast(value, to: Optional<Int8>.self) {
                    return NSNumber(value: v)
                }
            }
            else if dt is Double?.Type {
                if let v = unsafeBitCast(value, to: Optional<Double>.self) {
                    return NSNumber(value: v)
                }
            }
            else if dt is Float?.Type {
                if let v = unsafeBitCast(value, to: Optional<Float>.self) {
                    return NSNumber(value: v)
                }
            }
            else if dt is Bool?.Type {
                if let v = unsafeBitCast(value, to: Optional<Bool>.self) {
                    return NSNumber(value: v)
                }
            }
            else if dt is String?.Type {
                if let v = unsafeBitCast(value, to: Optional<String>.self) {
                    return v as NSString
                }
            }
            else if dt is Date?.Type {
                if let v = unsafeBitCast(value, to: Optional<Date>.self) {
                    return v as NSDate
                }
            }
            else if dt is Data?.Type {
                if let v = unsafeBitCast(value, to: Optional<Data>.self) {
                    return v as NSData
                }
            }
        }
    }
    
    // The value is `nil` or not compatible with `AttributeProtocol`.
    return NSNull()
}
