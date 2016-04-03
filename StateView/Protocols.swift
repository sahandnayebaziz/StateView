//
//  Protocols.swift
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
    
    var renderedViews: [String: StateView] = [:]
    var paintView: UIView!

    func place(element: ShadowViewElement) {
        newViews.append(element)
    }
    
    func didPlaceAll(props: [StateViewProp]) {
        let diff = views.diff(newViews)
        if !diff.results.isEmpty {
            views = newViews
            newViews.removeAll(keepCapacity: true)
            
            for viewElement in views {
                let propsToUse = props.filter { $0.viewKey == viewElement.key }
                viewElement.setProps(propsToUse)
            }
            
            for staleRenderedView in renderedViews.values {
                staleRenderedView.removeFromSuperview()
            }
            renderedViews.removeAll(keepCapacity: true)
            
            for viewElement in views {
                let initializedView = viewElement.elementType.init()
                
                initializedView.props = viewElement.props
                initializedView.render()
                
                let hash = NSUUID().UUIDString
                viewElement.viewHash = hash
                renderedViews[hash] = initializedView
                
                paintView.addSubview(initializedView)
                initializedView.snp_makeConstraints(closure: viewElement.constraints)
            }
            NSLog("mounted new views")
        } else {
            newViews.removeAll(keepCapacity: true)
            for viewElement in views {
                let propsToUse = props.filter { $0.viewKey == viewElement.key }
                viewElement.setProps(propsToUse)
                
                if let viewHash = viewElement.viewHash, let viewForHash = renderedViews[viewHash] {
                    viewForHash.props = propsToUse
                    viewForHash.render()
                } else {
                    fatalError("Any recycled viewElement must keep a viewHash for it's corresponding view")
                }
            }
            NSLog("updated existing views by hash!")
        }
    }
}


