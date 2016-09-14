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

func propsAreEqual(_ prop: StateKey, otherProp: StateKey) -> Bool {
    return type(of: prop) == type(of: otherProp) && prop.hashValue == otherProp.hashValue
}
