//
//  Protocls.swift
//  StateView
//
//  Created by Sahand Nayebaziz on 4/2/16.
//  Copyright © 2016 Sahand Nayebaziz. All rights reserved.
//

import Foundation
import UIKit
import Dwifft
import SnapKit

// knows which views are in the view
class ShadowView: UIView {
    var views: [ShadowViewElement] = []
    var newViews: [ShadowViewElement] = []
    
    var renderedViews: [StateView] = []
    var paintView: UIView!

    func place(elementType: StateView.Type, key: String, constraints constraintsMaker: ((make: ConstraintMaker) -> Void)) {
        newViews.append(ShadowViewElement(key: key, elementType: elementType, constraints: constraintsMaker))
    }
    
    func didPlaceAll(props: [StateViewProp]) {
//        let diff = views.diff(newViews)
//        if !diff.results.isEmpty {
//            views = newViews
//        } else {
//            
//        }
        
        views = newViews
        newViews.removeAll(keepCapacity: true)
        
        for viewElement in views {
            let propsToUse = props.filter { $0.viewKey == viewElement.key }
            viewElement.setProps(propsToUse)
        }
        
        for staleRenderedView in renderedViews {
            staleRenderedView.removeFromSuperview()
        }
        renderedViews.removeAll(keepCapacity: true)
        
        for viewElement in views {
            let initializedView = viewElement.elementType.init()
            initializedView.props = viewElement.props
            initializedView.render()
            renderedViews.append(initializedView)
            paintView.addSubview(initializedView)
            initializedView.snp_makeConstraints(closure: viewElement.constraints)
        }
    }
    
//    func sendPropsToPlaced(props: [StateViewProp]) {
////        for view in renderedViews {
////            view.removeFromSuperview()
////            renderedViews.removeAll()
////        }
//        
////        for view in views {
////            // initialize them empty into renderedviews
////            let propsToUse = props.filter { $0.viewKey == view.key }
////            let initializedView = view.elementType.init()
////            initializedView.renderWithProps(propsToUse)
////            renderedViews.append(initializedView)
////        }
////        
//        
//        
//        
//        for view in renderedViews {
//            paintView.addSubview(view)
//            view.snp_makeConstraints { make in
//                make.size.equalTo(paintView)
//                make.center.equalTo(paintView)
//            }
//        }
//    }
    
}

// a single record for a view
class ShadowViewElement: Equatable {
    var key: String
    var elementType: StateView.Type
    var constraints: ((make: ConstraintMaker) -> Void)
    var props: [StateViewProp] = []
    
    init(key: String, elementType: StateView.Type, constraints: ((make: ConstraintMaker) -> Void)) {
        self.key = key
        self.elementType = elementType
        props = []
        self.constraints = constraints
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
    var value: AnyObject { get set }
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



