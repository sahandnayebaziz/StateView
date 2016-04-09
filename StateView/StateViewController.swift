//
//  StateViewController.swift
//  StateView
//
//  Created by Sahand Nayebaziz on 4/9/16.
//  Copyright © 2016 Sahand Nayebaziz. All rights reserved.
//

import UIKit

public class StateViewController: UIViewController {
    
    public var rootView: StateView? = nil
    
    override public func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override public func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let rootView = self.rootView else {
            fatalError("A state view controller's rootView property must be set with a StateView in viewDidLoad.")
        }
        
        view.addSubview(rootView)
        rootView.snp_makeConstraints { make in
            make.size.equalTo(self.view)
            make.center.equalTo(self.view)
        }
        rootView.renderDeep()
    }
    
}

