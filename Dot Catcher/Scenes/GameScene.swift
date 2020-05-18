//
//  GameScene.swift
//  Dot Catcher
//
//  Created by Andrew Nathenson on 5/18/20.
//  Copyright © 2020 Andrew. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var Circles: [SKShapeNode] = []
    
    let SCALESPEED: TimeInterval = 8
    
    override func didMove(to view: SKView) {
        
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        let Circle = SKShapeNode(circleOfRadius: 1500)
        Circle.xScale = 0.001
        Circle.yScale = 0.001
        Circle.position = pos
        Circle.name = "circleSpread"
        Circle.strokeColor = SKColor.red
        Circle.glowWidth = 30.0
        Circle.fillColor = SKColor.clear
        
        self.addChild(Circle)
        self.Circles.append(Circle)
        print(self.Circles.count)
        let scale = SKAction.scale(to: 1, duration: self.SCALESPEED)
        Circle.run(scale) {
            Circle.removeFromParent()
            if let index = self.Circles.firstIndex(of: Circle) {
                self.Circles.remove(at:index)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
