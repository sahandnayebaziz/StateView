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

    func place(element: ShadowGenericElement) {
        newViews.append(element)
    }
    
    func didPlaceAll(props: [StateViewProp]) {
//        views = views.flatMap { $0 as? ShadowStateViewElement }
        
        let diff = views.diff(newViews)
        if !diff.results.isEmpty {
            
            for deletion in diff.deletions {
                if let viewHash = deletion.value.viewHash, let view = renderedViews[viewHash] {
                    view.removeFromSuperview()
                    renderedViews.removeValueForKey(viewHash)
                }
            }
            
            guard let parentViewController = parentViewController else {
                fatalError("A state view must be initialized with a connection to its parent view controller to allow for it's subviews to have a view controller to call. Use a StateViewController to make this connection automatically, or call setRootStateView() on your root state view in any heirarchy")
            }
            
            for insertion in diff.insertions {
                let viewElement = insertion.value
                
                let initializedView = viewElement.getInitializedViewWithParentViewController(parentViewController)
                
                let hash = NSUUID().UUIDString
                viewElement.viewHash = hash
                renderedViews[hash] = initializedView
                
                paintView.addSubview(initializedView)
                initializedView.snp_makeConstraints(closure: viewElement.constraints)
            }
            
            // update view records
            views = views.apply(diff)
            newViews.removeAll(keepCapacity: true)
            
            // warn on error
            if views.count != renderedViews.keys.count {
                fatalError("Views cannot existing in a ShadowView without a matching entry in views and renderedViews.")
            }
            
            // render
            renderViewsWithProps(props)
        } else {
            
            // go ahead and render
            newViews.removeAll(keepCapacity: true)
            renderViewsWithProps(props)
        }
    }

    private func renderViewsWithProps(props: [StateViewProp]) {
        for viewElement in views {
            if let viewElement = viewElement as? ShadowStateViewElement {
                let propsToUse = props.filter { $0.viewKey == viewElement.key }
                viewElement.setProps(propsToUse)
                
                if let viewHash = viewElement.viewHash, let viewForHash = renderedViews[viewHash], let stateView = viewForHash as? StateView {
                    stateView.props = propsToUse
                    stateView.renderDeep()
                } else {
                    fatalError("Any recycled viewElement must keep a viewHash for it's corresponding view")
                }
            }
        }
    }
}


