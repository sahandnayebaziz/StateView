//
//  StateViewProp.swift
//  StateView
//
//  Created by Nayebaziz, Sahand on 4/20/16.
//  Copyright © 2016 Sahand Nayebaziz. All rights reserved.
//

import Foundation

// Protocol for a StateViewProp
public protocol StateViewProp {
    var viewKey: String { get set }
    var key: StateKey { get set }
}

struct StateViewPropWithValue: StateViewProp, Equatable {
    var viewKey: String
    var key: StateKey
    var value: AnyObject?
}

func ==(lhs: StateViewPropWithValue, rhs: StateViewPropWithValue) -> Bool {
    return lhs.viewKey == rhs.viewKey && propsAreEqual(lhs.key, otherProp: rhs.key) && lhs.value === rhs.value
}

struct StateViewPropWithStateLink: StateViewProp, Equatable {
    var viewKey: String
    var key: StateKey
    var value: AnyObject?
    var stateKey: String
}

func ==(lhs: StateViewPropWithStateLink, rhs: StateViewPropWithStateLink) -> Bool {
    return lhs.viewKey == rhs.viewKey && propsAreEqual(lhs.key, otherProp: rhs.key) && lhs.stateKey == rhs.stateKey
}

struct StateViewPropWithFunction: StateViewProp, Equatable {
    var viewKey: String
    var key: StateKey
    var function: ([String: AnyObject] -> Void)
}

func ==(lhs: StateViewPropWithFunction, rhs: StateViewPropWithFunction) -> Bool {
    return lhs.viewKey == rhs.viewKey && propsAreEqual(lhs.key, otherProp: rhs.key)
}