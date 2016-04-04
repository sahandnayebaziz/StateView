//
//  Label.swift
//  StateView
//
//  Created by Sahand Nayebaziz on 4/3/16.
//  Copyright © 2016 Sahand Nayebaziz. All rights reserved.
//

import UIKit

class Label: StateView {
    var label: UILabel? = nil
    
    override func render() {
        if label == nil {
            let newLabel = UILabel()
            addSubview(newLabel)
            newLabel.snp_makeConstraints { make in
                make.size.equalTo(self)
                make.center.equalTo(self)
            }
            label = newLabel
        }
        
        guard let label = label else { return }
        
        label.text = prop(withValueForKey: "text") as? String
    }

}
