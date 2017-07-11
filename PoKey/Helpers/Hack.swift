//
//  Hack.swift
//  PoKey
//
//  Created by Vladimir Spasov on 11/7/17.
//  Copyright © 2017 Vladimir. All rights reserved.
//

import Foundation
import UIKit

struct ConstraintInfo {
    var attribute: NSLayoutAttribute = .left
    var secondAttribute: NSLayoutAttribute = .notAnAttribute
    var constant: CGFloat = 0
    var identifier: String?
    var relation: NSLayoutRelation = .equal
}

precedencegroup ConstOp {
    associativity: left
    higherThan: AssignmentPrecedence
}


infix operator >>>- : ConstOp

@discardableResult
func >>>- <T: UIView> (left: (T, T), block: (inout ConstraintInfo) -> Void) -> NSLayoutConstraint {
    var info = ConstraintInfo()
    block(&info)
    info.secondAttribute = info.secondAttribute == .notAnAttribute ? info.attribute : info.secondAttribute

    let constraint = NSLayoutConstraint(item: left.1,
                                        attribute: info.attribute,
                                        relatedBy: info.relation,
                                        toItem: left.0,
                                        attribute: info.secondAttribute,
                                        multiplier: 1,
                                        constant: info.constant)
    constraint.identifier = info.identifier
    left.0.addConstraint(constraint)
    return constraint
}

@discardableResult
func >>>- <T: UIView> (left: T, block: (inout ConstraintInfo) -> Void) -> NSLayoutConstraint {
    var info = ConstraintInfo()
    block(&info)

    let constraint = NSLayoutConstraint(item: left,
                                        attribute: info.attribute,
                                        relatedBy: info.relation,
                                        toItem: nil,
                                        attribute: info.attribute,
                                        multiplier: 1,
                                        constant: info.constant)
    constraint.identifier = info.identifier
    left.addConstraint(constraint)
    return constraint
}

@discardableResult
func >>>- <T: UIView> (left: (T, T, T), block: (inout ConstraintInfo) -> Void) -> NSLayoutConstraint {
    var info = ConstraintInfo()
    block(&info)
    info.secondAttribute = info.secondAttribute == .notAnAttribute ? info.attribute : info.secondAttribute

    let constraint = NSLayoutConstraint(item: left.1,
                                        attribute: info.attribute,
                                        relatedBy: info.relation,
                                        toItem: left.2,
                                        attribute: info.secondAttribute,
                                        multiplier: 1,
                                        constant: info.constant)
    constraint.identifier = info.identifier
    left.0.addConstraint(constraint)
    return constraint
}

internal func Init<Type>(_ value : Type, block: (_ object: Type) -> Void) -> Type
{
    block(value)
    return value
}
