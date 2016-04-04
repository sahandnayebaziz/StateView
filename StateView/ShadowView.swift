//
//  ShadowView.swift
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
            
            for deletion in diff.deletions {
                if let viewHash = deletion.value.viewHash, let view = renderedViews[viewHash] {
                    view.removeFromSuperview()
                    renderedViews.removeValueForKey(viewHash)
                }
            }
            
            for insertion in diff.insertions {
                let viewElement = insertion.value
                let initializedView = viewElement.elementType.init()
                
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
            let propsToUse = props.filter { $0.viewKey == viewElement.key }
            viewElement.setProps(propsToUse)
            
            if let viewHash = viewElement.viewHash, let viewForHash = renderedViews[viewHash] {
                viewForHash.props = propsToUse
                viewForHash.renderDeep()
            } else {
                fatalError("Any recycled viewElement must keep a viewHash for it's corresponding view")
            }
        }
    }
}


