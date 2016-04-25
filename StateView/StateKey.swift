//
//  StateKey.swift
//  StateView
//
//  Created by Nayebaziz, Sahand on 4/20/16.
//  Copyright © 2016 Sahand Nayebaziz. All rights reserved.
//

import Foundation

public protocol StateKey {
    var hashValue: Int { get }
}

func propsAreEqual(prop: StateKey, otherProp: StateKey) -> Bool {
    return prop.dynamicType == otherProp.dynamicType && prop.hashValue == otherProp.hashValue
}
