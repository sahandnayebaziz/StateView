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
            startRender()
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
    
    func renderWithProps(props: [StateViewProp]) {
        
    }
    
    func startRender() {
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
    
    func place(elementType: StateView.Type, key: String, constraints constraintsMaker: ((make: ConstraintMaker) -> Void)) {
        shadow.place(elementType, key: key, constraints: constraintsMaker)
    }
    
    func setProp(forViewKey viewKey: String, toValue value: AnyObject, forKey key: String) {
        props = props.filter { $0.key != key && $0.viewKey != key }
        props.append(StateViewPropWithValue(viewKey: viewKey, key: key, value: value))
    }
    
    func setProp(forViewKey viewKey: String, toStateKey stateKey: String, forKey key: String) {
        props = props.filter { $0.key != key && $0.viewKey != key }
        props.append(StateViewPropWithStateLink(viewKey: viewKey, key: key, value: "unset", stateKey: stateKey))
        
    }
    
    func getProp(forKey key: String) -> AnyObject? {
        let possibleProp = props.filter { $0.key == key }
        
        if possibleProp.isEmpty {
            return nil
        } else {
            return possibleProp.first!.value
        }
    }

}

