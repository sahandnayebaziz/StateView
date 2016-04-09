    //
//  HomeView.swift
//  StateView
//
//  Created by Sahand Nayebaziz on 4/3/16.
//  Copyright © 2016 Sahand Nayebaziz. All rights reserved.
//

import UIKit

class HomeView: StateView {
    
    override func getInitialState() -> [String : AnyObject?] {
        return [
            "placeholder":"Is this working?",
            "nextButtonEnabled": false,
            "name": ""
        ]
    }
    
    override func render() {
        backgroundColor = UIColor.lightGrayColor()
        
        let genderField = place(FieldLabelView.self, key: "label") { make in
            make.size.equalTo(self)
            make.center.equalTo(self)
        }
        genderField.prop(forKey: "name", is: self.state["name"] as! String)
        genderField.prop(forKey: "placeholder", isLinkedToKeyInState: "placeholder")
        genderField.prop(forKey: "didReceiveText") { values in
            if let text = values["text"] as? String {
                self.state["name"] = text
                
                if text.characters.count > 1 {
                    self.state["nextButtonEnabled"] = true
                } else if text.characters.count == 1 {
                    self.state["nextButtonEnabled"] = false
                } else {
                    self.state["nextButtonEnabled"] = nil
                }
                
            }
        }
        
        if self.state["nextButtonEnabled"] != nil {
            let nextButton = place(NextButton.self, key: "nextButton") { make in
                make.width.equalTo(self)
                make.height.equalTo(44)
                make.bottom.equalTo(self)
                make.centerX.equalTo(self)
            }
            nextButton.prop(forKey: "enabled", isLinkedToKeyInState: "nextButtonEnabled")
        }
    }
}
