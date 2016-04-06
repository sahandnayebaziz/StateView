//
//  FieldLabelView.swift
//  StateView
//
//  Created by Sahand Nayebaziz on 4/3/16.
//  Copyright © 2016 Sahand Nayebaziz. All rights reserved.
//

import UIKit

class FieldLabelView: StateView {

    var label: UILabel?
    var textField: UITextField?
    
    override func getInitialState() -> [String : AnyObject] {
        return ["text": "hello"]
    }
    
    override func render() {
        if label == nil {
            let newLabel = UILabel()
            newLabel.textAlignment = .Center
            addSubview(newLabel)
            newLabel.snp_makeConstraints { make in
                make.size.equalTo(self)
                make.center.equalTo(self)
            }
            label = newLabel
        }
        
        if textField == nil {
            let newTextField = UITextField()
            addSubview(newTextField)
            newTextField.snp_makeConstraints { make in
                make.width.equalTo(self)
                make.top.equalTo(self)
                make.height.equalTo(44)
                make.centerX.equalTo(self)
            }
            textField = newTextField
            textField?.placeholder = prop(withValueForKey: "placeholder") as? String
            textField!.addTarget(self, action: #selector(FieldLabelView.didReceiveText(_:)), forControlEvents: .EditingChanged)
            newTextField.backgroundColor = UIColor.cyanColor()
        }
        
        if let label = label {
            label.text = prop(withValueForKey: "name") as? String
        }
        
        if let textField = textField {
            textField.text = prop(withValueForKey: "name") as? String
        }
        
        let nameToUse = prop(withValueForKey: "name") as? String
        if nameToUse != nil {
            if (nameToUse == "sahand") {
                let label = place(Label.self, key: "label") { make in
                    make.width.equalTo(self)
                    make.top.equalTo(self.textField!.snp_bottom)
                    make.height.equalTo(50)
                    make.centerX.equalTo(self)
                }
                label.prop(forKey: "text", is: "It's working!")
            }
        }
    }
    
    func didReceiveText(sender: UITextField) {
        if let propDidReceiveText = prop(withFunctionForKey: "didReceiveText") {
            let values = ["text": sender.text!]
            propDidReceiveText(values)
        }
    }
}