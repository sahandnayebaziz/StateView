//
//  ViewController.swift
//  StateView
//
//  Created by Sahand Nayebaziz on 4/2/16.
//  Copyright © 2016 Sahand Nayebaziz. All rights reserved.
//

import UIKit
import SnapKit
import Dwifft

class ViewController: StateViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        rootView = HomeView()
    }
    
}

class StateViewController: UIViewController {
    
    var rootView: StateView? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
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
