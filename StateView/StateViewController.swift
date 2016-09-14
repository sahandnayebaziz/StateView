//
//  StateViewController.swift
//  StateView
//
//  Created by Sahand Nayebaziz on 4/9/16.
//  Copyright © 2016 Sahand Nayebaziz. All rights reserved.
//

import UIKit

open class StateViewController: UIViewController {
    
    open var rootView: StateView? = nil {
        didSet {
            if let rootView = rootView {
                view.addSubview(rootView)
                rootView.snp.makeConstraints { make in
                    make.size.equalTo(self.view)
                    make.center.equalTo(self.view)
                }
                rootView.setRootView()
            }
        }
    }
    
}

