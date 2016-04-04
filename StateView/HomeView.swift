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
        return [
            "placeholder":"Is this working?",
            "nextButtonEnabled": false,
            "name": ""
        ]
    }
    
    override func render() {
        backgroundColor = UIColor.lightGrayColor()
        
        place(FieldLabelView.self, key: "label") { make in
            make.size.equalTo(self)
            make.center.equalTo(self)
        }
        setProp(forViewKey: "label", toStateKey: "placeholder", forKey: "placeholder")
        setProp(forViewKey: "label", toValue: self.state["name"] as! String , forKey: "name")
        setProp(forViewKey: "label", forKey: "didReceiveText") { values in
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
            place(NextButton.self, key: "nextButton") { make in
                make.width.equalTo(self)
                make.height.equalTo(44)
                make.bottom.equalTo(self)
                make.centerX.equalTo(self)
            }
            setProp(forViewKey: "nextButton", toStateKey: "nextButtonEnabled", forKey: "enabled")
        }
    }
}
