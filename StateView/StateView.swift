//
//  StateViewController.swift
//  StateView
//
//  Created by Sahand Nayebaziz on 4/3/16.
//  Copyright © 2016 Sahand Nayebaziz. All rights reserved.
//

import UIKit
import SnapKit

// similar to component
public class StateView: UIView {
    let shadow = ShadowView()
    var props: [StateViewProp] = []
    var propsForChildren: [StateViewProp] = []
    public var state: [String: Any?] = [:] {
        willSet { viewWillUpdate(newValue, newProps: props) }
        didSet {
            propsForChildren.removeAll()
            renderDeep()
            
            viewDidUpdate()
        }
    }
    
    public var parentViewController: UIViewController
    
    public required init(parentViewController: UIViewController) {
        self.parentViewController = parentViewController
        shadow.parentViewController = parentViewController
        
        super.init(frame: CGRectZero)
        shadow.paintView = self
        self.state = getInitialState()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func getInitialState() -> [String: Any?] {
        return [:]
    }
    
    public func setRootView() {
        renderDeep()
        viewDidInitialize()
    }
    
    func renderDeep() {
        render()
        shadow.didPlaceAll(resolveProps(self.propsForChildren))
    }
    
    public func render() {}
    
    public func viewDidInitialize() {}
    public func viewWillUpdate(newState: [String: Any?], newProps: [StateViewProp]) {}
    public func viewDidUpdate() {}
    
    private func resolveProps(props: [StateViewProp]) -> [StateViewProp] {
        var propsToUse: [StateViewProp] = []

        for prop in props {
            if let prop = prop as? StateViewPropWithStateLink {
                if let valueInState = self.state[prop.stateKey] {
                    let newProp = StateViewPropWithValue(viewKey: prop.viewKey, key: prop.key, value: valueInState)
                    propsToUse.append(newProp)
                }
                
            } else {
                propsToUse.append(prop)
            }
        }
        return propsToUse
    }
    
    public func place(type: StateView.Type, key: String, constraints: ((make: ConstraintMaker) -> Void)) -> ShadowStateViewElement {
        let shadowElement = ShadowStateViewElement(key: key, containingView: self, constraints: constraints, type: type)
        shadow.place(shadowElement)
        return shadowElement
    }
    
    public func place(view: UIView, key: String, constraints: ((make: ConstraintMaker) -> Void)) -> ShadowViewElement {
        let shadowElement = ShadowViewElement(key: key, containingView: self, constraints: constraints, view: view)
        shadow.place(shadowElement)
        return shadowElement
    }

    func setProp(forView: ShadowStateViewElement, toValue value: Any?, forKey key: StateKey) {
        propsForChildren = propsForChildren.filter { !(propsAreEqual($0.key, otherProp: key) && $0.viewKey == forView.key) }
        propsForChildren.append(StateViewPropWithValue(viewKey: forView.key, key: key, value: value))
    }
    
    func setProp(forView: ShadowStateViewElement, toStateKey stateKey: String, forKey key: StateKey) {
        propsForChildren = propsForChildren.filter { !(propsAreEqual($0.key, otherProp: key) && $0.viewKey == forView.key) }
        propsForChildren.append(StateViewPropWithStateLink(viewKey: forView.key, key: key, value: "unset", stateKey: stateKey))
    }
    
    func setProp(forView: ShadowStateViewElement, forKey key: StateKey, toFunction function: (([String: Any]->Void))) {
        propsForChildren = propsForChildren.filter { !(propsAreEqual($0.key, otherProp: key) && $0.viewKey == forView.key) }
        propsForChildren.append(StateViewPropWithFunction(viewKey: forView.key, key: key, function: function))
    }
    
    public func prop(withValueForKey key: StateKey) -> Any? {
        let possibleProp = props.filter { prop in
            guard let _ = prop as? StateViewPropWithValue else {
                return false
            }
            
            return propsAreEqual(prop.key, otherProp: key)
        }
        
        guard let prop = possibleProp.first as? StateViewPropWithValue else {
            return nil
        }
        
        return prop.value
    }
    
    public func prop(withFunctionForKey key: StateKey) -> (([String: Any] ->Void))? {
        let possibleProp = props.filter { prop in
            guard let _ = prop as? StateViewPropWithFunction else {
                return false
            }
            
            return propsAreEqual(prop.key, otherProp: key)
        }
        
        guard let prop = possibleProp.first as? StateViewPropWithFunction else {
            return nil
        }
        
        return prop.function
    }
    
}

// This extension makes prop(withValueForKey) and prop(withFunctionForKey) available on the newProps array that is passed into viewWillUpdate.
extension _ArrayType where Generator.Element == StateViewProp {
    
    public func prop(withValueForKey key: StateKey) -> Any? {
        let possibleProp = self.filter { prop in
            guard let _ = prop as? StateViewPropWithValue else {
                return false
            }
            
            return propsAreEqual(prop.key, otherProp: key)
        }
        
        guard let prop = possibleProp.first as? StateViewPropWithValue else {
            return nil
        }
        
        return prop.value
    }
    
    public func prop(withFunctionForKey key: StateKey) -> (([String: Any] ->Void))? {
        let possibleProp = self.filter { prop in
            guard let _ = prop as? StateViewPropWithFunction else {
                return false
            }
            
            return propsAreEqual(prop.key, otherProp: key)
        }
        
        guard let prop = possibleProp.first as? StateViewPropWithFunction else {
            return nil
        }
        
        return prop.function
    }
    
}
