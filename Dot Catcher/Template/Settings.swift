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
    static let triangleCategory:UInt32 = 0x1 << 1
    static let squareCategory:UInt32 = 0x1 << 2
    static let starCategory:UInt32 = 0x1 << 3
    static let detectorCategory:UInt32 = 0x1 << 4
    static let smallCircleCategory:UInt32 = 0x1 << 5
    static let smallTriangleCategory:UInt32 = 0x1 << 6
    static let smallSquareCategory:UInt32 = 0x1 << 7
    static let smallStarCategory:UInt32 = 0x1 << 8
    static let bombCategory:UInt32 = 0x1 << 9
}
