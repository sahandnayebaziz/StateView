//
//  NextButton.swift
//  StateView
//
//  Created by Sahand Nayebaziz on 4/3/16.
//  Copyright © 2016 Sahand Nayebaziz. All rights reserved.
//

import UIKit

class NextButton: StateView {

    override func render() {
        if let enabled = prop(withValueForKey: "enabled") as? Bool {
            if (enabled) {
                backgroundColor = UIColor.greenColor()
            } else {
                backgroundColor = UIColor.redColor()
            }
        } else {
            NSLog(" did not receive prop ")
        }
    }

}
