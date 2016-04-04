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
class StateView: UIView {
    var shadow = ShadowView()
    var props: [StateViewProp] = []
    var state: [String: AnyObject] = [:] {
        didSet {
            props.removeAll()
            renderDeep()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        shadow.paintView = self
        self.state = getInitialState()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getInitialState() -> [String: AnyObject] {
        return [:]
    }
    
    func renderDeep() {
        render()
        shadow.didPlaceAll(resolveProps(self.props))
    }
    
    func render() {
        
    }
    
    private func resolveProps(props: [StateViewProp]) -> [StateViewProp] {
        var propsToUse: [StateViewProp] = []

        for prop in props {
            if let prop = prop as? StateViewPropWithStateLink {
                let newProp = StateViewPropWithValue(viewKey: prop.viewKey, key: prop.key, value: self.state[prop.stateKey]!)
                propsToUse.append(newProp)
            } else {
                propsToUse.append(prop)
            }
        }
        return propsToUse
    }
    
    func place(elementType: StateView.Type, key: String, constraints constraintsMaker: ((make: ConstraintMaker) -> Void)) -> ShadowViewElement {
        let element = ShadowViewElement(key: key, elementType: elementType, constraints: constraintsMaker)
        shadow.place(element)
        return element
    }
    
    func setProp(forViewKey viewKey: String, toValue value: AnyObject, forKey key: String) {
        props = props.filter { $0.key != key && $0.viewKey != key }
        props.append(StateViewPropWithValue(viewKey: viewKey, key: key, value: value))
    }
    
    func setProp(forViewKey viewKey: String, toStateKey stateKey: String, forKey key: String) {
        props = props.filter { $0.key != key && $0.viewKey != key }
        props.append(StateViewPropWithStateLink(viewKey: viewKey, key: key, value: "unset", stateKey: stateKey))
        
    }
    
    func setProp(forViewKey viewKey: String, forKey key: String, toFunction function: (([String: AnyObject]->Void))) {
        props = props.filter { $0.key != key && $0.viewKey != key }
        props.append(StateViewPropWithFunction(viewKey: viewKey, key: key, function: function))
    }
    
    func prop(withValueForKey key: String) -> AnyObject? {
        let possibleProp = props.filter { prop in
            guard let _ = prop as? StateViewPropWithValue else {
                return false
            }
            
            return prop.key == key
        }
        
        guard let prop = possibleProp.first as? StateViewPropWithValue else {
            return nil
        }
        
        return prop.value
    }
    
    func prop(withFunctionForKey key: String) -> (([String: AnyObject] ->Void))? {
        let possibleProp = props.filter { prop in
            guard let _ = prop as? StateViewPropWithFunction else {
                return false
            }
            
            return prop.key == key
        }
        
        guard let prop = possibleProp.first as? StateViewPropWithFunction else {
            return nil
        }
        
        return prop.function
    }
}

