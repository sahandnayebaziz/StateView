//
//  ShadowViewElement.swift
//  StateView
//
//  Created by Sahand Nayebaziz on 4/3/16.
//  Copyright © 2016 Sahand Nayebaziz. All rights reserved.
//

import UIKit
import SnapKit

protocol ShadowElement: Equatable {
    var key: String { get set }
    var viewHash: String? { get set }
    var containingView: StateView { get set }
    var constraints: ((make: ConstraintMaker) -> Void) { get set }
    
    var getInitializedViewWithParentViewController: ((UIViewController) -> UIView) { get set }
}

// a generic class used to Super-connect ShadowViewElement and ShadowStateViewElement
public class ShadowGenericElement: ShadowElement {
    var key: String
    var viewHash: String?
    var containingView: StateView
    var constraints: ((make: ConstraintMaker) -> Void)
    
    var getInitializedViewWithParentViewController: ((UIViewController) -> UIView)
    
    init(key: String, containingView: StateView, constraints: ((make: ConstraintMaker) -> Void)) {
        self.key = key
        self.viewHash = nil
        self.containingView = containingView
        self.constraints = constraints
        
        self.getInitializedViewWithParentViewController = { _ in
            return UIView()
        }
    }
}

public func ==(lhs: ShadowGenericElement, rhs: ShadowGenericElement) -> Bool {
    if let lhsState = lhs as? ShadowStateViewElement, let rhsState = rhs as? ShadowStateViewElement {
        return lhsState.key == rhsState.key && lhsState.containingView == rhsState.containingView && lhsState.type == rhsState.type
    } else if let lhsView = lhs as? ShadowViewElement, let rhsView = rhs as? ShadowViewElement {
        return lhsView.key == rhsView.key && lhsView.containingView == rhsView.containingView && lhsView.view == rhsView.view
    } else {
        return lhs.key == rhs.key && lhs.containingView == rhs.containingView
    }
}

public class ShadowViewElement: ShadowGenericElement {
    var view: UIView
    
    init(key: String, containingView: StateView, constraints: ((make: ConstraintMaker) -> Void), view: UIView) {
        self.view = view
        
        super.init(key: key, containingView: containingView, constraints: constraints)
        self.getInitializedViewWithParentViewController = { _ in
            return view
        }
    }
}

public class ShadowStateViewElement: ShadowGenericElement {
    var type: StateView.Type
    var props: [StateViewProp]
    
    init(key: String, containingView: StateView, constraints: ((make: ConstraintMaker) -> Void), type: StateView.Type) {
        self.type = type
        self.props = []
        
        super.init(key: key, containingView: containingView, constraints: constraints)
        self.getInitializedViewWithParentViewController = { parentViewController in
            return type.init(parentViewController: parentViewController)
        }
    }
    
    public func prop(forKey key: String, is value: AnyObject) {
        containingView.setProp(self, toValue: value, forKey: key)
    }
    
    public func prop(forKey key: String, isLinkedToKeyInState stateKey: String) {
        containingView.setProp(self, toStateKey: stateKey, forKey: key)
    }
    
    public func prop(forKey key: String, isFunction function: ([String: AnyObject]->Void)) {
        containingView.setProp(self, forKey: key, toFunction: function)
    }
    
    func setProps(props: [StateViewProp]) {
        self.didReceiveProps(props)
    }
    
    func didReceiveProps(props: [StateViewProp]) {
        self.props = props
    }
}


// a prop
public protocol StateViewProp {
    var viewKey: String { get set }
    var key: String { get set }
}

struct StateViewPropWithValue: StateViewProp, Equatable {
    var viewKey: String
    var key: String
    var value: AnyObject?
}

func ==(lhs: StateViewPropWithValue, rhs: StateViewPropWithValue) -> Bool {
    return lhs.viewKey == rhs.viewKey && lhs.key == rhs.key && lhs.value === rhs.value
}

struct StateViewPropWithStateLink: StateViewProp, Equatable {
    var viewKey: String
    var key: String
    var value: AnyObject?
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