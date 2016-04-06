//
//  ShadowViewElement.swift
//  StateView
//
//  Created by Sahand Nayebaziz on 4/3/16.
//  Copyright © 2016 Sahand Nayebaziz. All rights reserved.
//

import UIKit
import SnapKit

// a single record for a view
class ShadowViewElement: Equatable {
    var key: String
    var elementType: StateView.Type
    var constraints: ((make: ConstraintMaker) -> Void)
    var props: [StateViewProp] = []
    var viewHash: String? = nil
    var containingView: StateView
    
    init(key: String, elementType: StateView.Type, constraints: ((make: ConstraintMaker) -> Void), containingView: StateView) {
        self.key = key
        self.elementType = elementType
        self.constraints = constraints
        self.containingView = containingView
        props = []
    }
    
    func prop(forKey key: String, is value: AnyObject) {
        containingView.setProp(self, toValue: value, forKey: key)
    }
    
    func prop(forKey key: String, isLinkedToKeyInState stateKey: String) {
        containingView.setProp(self, toStateKey: stateKey, forKey: key)
    }
    
    func setValue(toFunction: ([String:AnyObject]->Void), forKey: String) {
        containingView.setProp(self, forKey: forKey, toFunction: toFunction)
    }
    
    func setProps(props: [StateViewProp]) {
        self.didReceiveProps(props)
    }
    
    func didReceiveProps(props: [StateViewProp]) {
        self.props = props
    }
}

func ==(lhs: ShadowViewElement, rhs: ShadowViewElement) -> Bool {
    return lhs.key == rhs.key && lhs.elementType == rhs.elementType
}


// a prop
protocol StateViewProp {
    var viewKey: String { get set }
    var key: String { get set }
}

struct StateViewPropWithValue: StateViewProp, Equatable {
    var viewKey: String
    var key: String
    var value: AnyObject
}

func ==(lhs: StateViewPropWithValue, rhs: StateViewPropWithValue) -> Bool {
    return lhs.viewKey == rhs.viewKey && lhs.key == rhs.key && lhs.value === rhs.value
}

struct StateViewPropWithStateLink: StateViewProp, Equatable {
    var viewKey: String
    var key: String
    var value: AnyObject
    var stateKey: String
}

func ==(lhs: StateViewPropWithStateLink, rhs: StateViewPropWithStateLink) -> Bool {
    return lhs.viewKey == rhs.viewKey && lhs.key == rhs.key && lhs.stateKey == rhs.stateKey
}

struct StateViewPropWithFunction: StateViewProp, Equatable {
    var viewKey: String
    var key: String
    var function: ([String: AnyObject] -> Void)
}

func ==(lhs: StateViewPropWithFunction, rhs: StateViewPropWithFunction) -> Bool {
    return lhs.viewKey == rhs.viewKey && lhs.key == rhs.key
}