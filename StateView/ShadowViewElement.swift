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
    
    public func prop(forKey key: StateKey, is value: AnyObject) {
        containingView.setProp(self, toValue: value, forKey: key)
    }
    
    public func prop(forKey key: StateKey, isLinkedToKeyInState stateKey: String) {
        containingView.setProp(self, toStateKey: stateKey, forKey: key)
    }
    
    public func prop(forKey key: StateKey, isFunction function: ([String: AnyObject]->Void)) {
        containingView.setProp(self, forKey: key, toFunction: function)
    }
    
    func setProps(props: [StateViewProp]) {
        self.didReceiveProps(props)
    }
    
    func didReceiveProps(props: [StateViewProp]) {
        self.props = props
    }
}