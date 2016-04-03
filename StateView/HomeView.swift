//
//  HomeView.swift
//  StateView
//
//  Created by Sahand Nayebaziz on 4/3/16.
//  Copyright © 2016 Sahand Nayebaziz. All rights reserved.
//

import UIKit

class HomeView: StateView {
    
    override func getInitialState() -> [String : AnyObject] {
        return ["placeholder":"Is this working?"]
    }
    
    override func render() {
//        setProp(forViewKey: "label", toValue: "Type in me!", forKey: "placeholder")
        setProp(forViewKey: "label", toStateKey: "placeholder", forKey: "placeholder")
        place(FieldLabelView.self, key: "label") { make in
            make.size.equalTo(self)
            make.center.equalTo(self)
        }
        backgroundColor = UIColor.lightGrayColor()
    }
    

}