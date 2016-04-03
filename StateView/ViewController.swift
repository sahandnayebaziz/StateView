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

class ViewController: UIViewController {
    
    var stateView = StateView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rootView = HomeView()
        view.addSubview(rootView)
        rootView.snp_makeConstraints { make in
            make.size.equalTo(300)
            make.center.equalTo(self.view)
        }
        rootView.startRender()
    }
    
}

class HomeView: StateView {
    
    override func render() {
        shadow.place(LabelView.self, key: "label") { make in
            make.size.equalTo(200)
            make.center.equalTo(self)
        }
        setProp(forViewKey: "label", toValue: "Hello World", forKey: "text")
        backgroundColor = UIColor.lightGrayColor()
        
    }
    
    
    
}
