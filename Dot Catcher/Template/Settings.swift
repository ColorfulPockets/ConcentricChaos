//
//  Settings.swift
//  Dot Catcher
//
//  Created by Andrew Nathenson on 5/18/20.
//  Copyright © 2020 Andrew. All rights reserved.
//

import SpriteKit

enum PhysicsCategories {
    static let none: UInt32 = 0
    static let circleCategory: UInt32 = 0x1
    static let dotCategory:UInt32 = 0x1 << 1
}
