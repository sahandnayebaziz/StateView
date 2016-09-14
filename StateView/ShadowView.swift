//
//  ShadowView.swift
//  StateView
//
//  Created by Sahand Nayebaziz on 4/2/16.
//  Copyright © 2016 Sahand Nayebaziz. All rights reserved.
//

import UIKit
import SnapKit

// knows which views are in the view
class ShadowView: UIView {
    var views: [ShadowGenericElement] = []
    var newViews: [ShadowGenericElement] = []
    
    var renderedViews: [String: UIView] = [:]
    var paintView: UIView!
    
    var parentViewController: UIViewController? = nil

    func place(_ element: ShadowGenericElement) {
        newViews.append(element)
    }
    
    func didPlaceAll(_ props: [StateViewProp]) {
        let diff = views.diff(newViews)
        if !diff.results.isEmpty {
            
            for deletion in diff.deletions {
                if let viewHash = deletion.value.viewHash, let view = renderedViews[viewHash] {
                    view.removeFromSuperview()
                    renderedViews.removeValue(forKey: viewHash)
                }
            }
            
            guard let parentViewController = parentViewController else {
                fatalError("A state view must be initialized with a connection to its parent view controller to allow for it's subviews to have a view controller to call. Use a StateViewController to make this connection automatically, or call setRootStateView() on your root state view in any heirarchy")
            }
            
            for insertion in diff.insertions {
                let viewElement = insertion.value
                
                let initializedView = viewElement.getInitializedViewWithParentViewController(parentViewController)
                
                let hash = UUID().uuidString
                viewElement.viewHash = hash
                renderedViews[hash] = initializedView
                
                paintView.addSubview(initializedView)
                initializedView.snp.makeConstraints(viewElement.constraints)
            }
            
            // update view records
            views = views.apply(diff)
            
            // warn on error
            if views.count != renderedViews.keys.count {
                fatalError("Views cannot existing in a ShadowView without a matching entry in views and renderedViews.")
            }
        }
        
        // force update all constraints
        for newPlacement in newViews {
            let possibleMatchingViews = views.filter { $0.key == newPlacement.key && $0.containingView == newPlacement.containingView }
            if !possibleMatchingViews.isEmpty {
                if possibleMatchingViews.count == 1 {
                    guard let hash = possibleMatchingViews[0].viewHash else {
                        fatalError("All views in shadow.views must have a viewHash.")
                    }
                    
                    guard let view = renderedViews[hash] else {
                        fatalError("All views in shadow.views given a viewHash must have an item in shadow.renderedViews.")
                    }
                    
                    view.snp.remakeConstraints(newPlacement.constraints)
                } else {
                    fatalError("All immediate children of a StateView must be given unique keys.")
                }
            }
        }
        
        // render
        renderViewsWithProps(props)
        
        // flush new views
        newViews.removeAll(keepingCapacity: true)
    }

    fileprivate func renderViewsWithProps(_ props: [StateViewProp]) {
        for viewElement in views {
            if let viewElement = viewElement as? ShadowStateViewElement {
                let propsToUse = props.filter { $0.viewKey == viewElement.key }
                viewElement.setProps(propsToUse)
                
                if let viewHash = viewElement.viewHash, let viewForHash = renderedViews[viewHash], let stateView = viewForHash as? StateView {
                    
                    if (!viewElement.firstTimeReceivingProps) {
                        stateView.viewWillUpdate(stateView.state, newProps: propsToUse)
                    }
                    
                    
                    stateView.props = propsToUse
                    
                    if (viewElement.firstTimeReceivingProps) {
                        stateView.viewDidInitialize()
                    }
                    
                    
                    stateView.renderDeep()
                    
                    if (!viewElement.firstTimeReceivingProps) {
                        stateView.viewDidUpdate()
                    }
                    
                    
                    if (viewElement.firstTimeReceivingProps) {
                        viewElement.firstTimeReceivingProps = false
                    }
                    
                } else {
                    fatalError("Any recycled viewElement must keep a viewHash for it's corresponding view")
                }
            }
        }
    }
}


