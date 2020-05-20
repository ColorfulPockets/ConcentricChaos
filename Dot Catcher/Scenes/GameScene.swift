//
//  GameScene.swift
//  Dot Catcher
//
//  Created by Andrew Nathenson on 5/18/20.
//  Copyright © 2020 Andrew. All rights reserved.
//

import SpriteKit
import GameplayKit
import UIKit

class GameScene: SKScene {
    
    var Circles: [SKShapeNode] = []
    var Triangles: [SKShapeNode] = []
    var Squares: [SKShapeNode] = []
    var Stars: [SKShapeNode] = []
    
    let CIRCLESPEED: TimeInterval = 4
    let SQUARESPEED: TimeInterval = 4
    let TRIANGLESPEED: TimeInterval = 4
    let STARSPEED: TimeInterval = 4
    let VARIANCE = 700
    
    var startPressed = false
    
    var timer = Timer()
    
    override func didMove(to view: SKView) {
        
        mainMenu()
        scheduledTimerWithTimeInterval()
    }
    
    func scheduledTimerWithTimeInterval(){
        // Scheduling timer to Call the function "spawnDots" with the interval of 1 seconds
        timer = Timer.scheduledTimer(timeInterval: 0.6, target: self, selector: #selector(self.spawnDots), userInfo: nil, repeats: true)
    }
    
    func mainMenu() {
        self.startPressed = false
        
        self.removeAllChildren()
        
        let startButton = SKShapeNode(rectOf: CGSize(width: 500, height: 200))
        startButton.name = "startButton"
        self.addChild(startButton)
        
        let startButtonLabel = SKLabelNode(text: "Start!")
        startButtonLabel.fontSize = 100
        startButtonLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        self.addChild(startButtonLabel)
    }
    
    @objc func spawnDots() {
        if startPressed {
            let dotType = Int.random(in: 0...2)
            let OUTERSTAR = 30.0 * 2
            let INNERSTAR = 12.50 * 2
            var dot = SKShapeNode()
            switch dotType {
            case 0:
                dot = SKShapeNode(circleOfRadius: 50)
                dot.name = "circle"
            case 1:
                dot = SKShapeNode(rectOf: CGSize(width:90, height:90))
                dot.name = "square"
            case 2:
                let path = CGMutablePath()
                path.move(to: CGPoint(x: -200 / 3, y: -123 / 3))
                path.addLine(to: CGPoint(x: 0.0, y: 223.4 / 3))
                path.addLine(to: CGPoint(x: 200.0 / 3, y: -123.0 / 3))
                path.addLine(to: CGPoint(x: -200.0 / 3, y: -123.0 / 3))
                dot = SKShapeNode()
                dot.path = path
                dot.name = "triangle"
            default:
                let path = CGMutablePath()
                path.move(to: CGPoint(x: OUTERSTAR * cosDegs(18), y: OUTERSTAR * sinDegs(18)))
                path.addLine(to: CGPoint(x: INNERSTAR * cosDegs(54), y: INNERSTAR * sinDegs(54)))
                
                path.addLine(to: CGPoint(x: OUTERSTAR * cosDegs(90), y: OUTERSTAR * sinDegs(90)))
                path.addLine(to: CGPoint(x: INNERSTAR * cosDegs(126), y: INNERSTAR * sinDegs(126)))
                
                path.addLine(to: CGPoint(x: OUTERSTAR * cosDegs(162), y: OUTERSTAR * sinDegs(162)))
                path.addLine(to: CGPoint(x: INNERSTAR * cosDegs(198), y: INNERSTAR * sinDegs(198)))
                
                path.addLine(to: CGPoint(x: OUTERSTAR * cosDegs(234), y: OUTERSTAR * sinDegs(234)))
                path.addLine(to: CGPoint(x: cosDegs(252), y: INNERSTAR * sinDegs(252)))
                
                path.addLine(to: CGPoint(x: OUTERSTAR * cosDegs(306), y: OUTERSTAR * sinDegs(306)))
                path.addLine(to: CGPoint(x: INNERSTAR * cosDegs(342), y: INNERSTAR * sinDegs(342)))
                
                path.addLine(to: CGPoint(x: OUTERSTAR * cosDegs(18), y: OUTERSTAR * sinDegs(18)))
                dot.path = path
                dot.name = "star"
            }
        
            dot.zRotation = CGFloat(Int.random(in: 0...360))
            self.addChild(dot)
            var move = SKAction()
            let coinFlip = Int.random(in: 0...1)
            if coinFlip == 0 {
                let startX = UIScreen.main.bounds.width + 50
                let startY = Int.random(in: -Int(UIScreen.main.bounds.height)...Int(UIScreen.main.bounds.height))
                dot.position = CGPoint(x: startX, y: CGFloat(startY))
                move = SKAction.move(to: CGPoint(x: -1 * UIScreen.main.bounds.width - 50, y: CGFloat(Int.random(in: startY * -1 - VARIANCE...startY * -1 + VARIANCE))), duration: 5)
            } else {
                let startX = -1 * UIScreen.main.bounds.width - 50
                let startY = Int.random(in: -Int(UIScreen.main.bounds.height)...Int(UIScreen.main.bounds.height))
                dot.position = CGPoint(x: startX, y: CGFloat(startY))
                move = SKAction.move(to: CGPoint(x: UIScreen.main.bounds.width + 50, y: CGFloat(Int.random(in: startY * -1 - VARIANCE...startY * -1 + VARIANCE))), duration: 5)
            }
            
            
            dot.run(move) {
                dot.removeFromParent()
                self.mainMenu()
            }
        }
    }
    
    func touchCircle(atPoint pos : CGPoint) {
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
        //print(self.Circles.count - 1)
        let scale = SKAction.scale(to: 1, duration: self.CIRCLESPEED)
        Circle.run(scale) {
            Circle.removeFromParent()
            if let index = self.Circles.firstIndex(of: Circle) {
                self.Circles.remove(at:index)
            }
        }
    }
    
    func touchSquare(atPoint pos : CGPoint) {
        let Square = SKShapeNode(rectOf: CGSize(width: 3000, height: 3000))
        Square.xScale = 0.001
        Square.yScale = 0.001
        Square.position = pos
        Square.zRotation = CGFloat(Int.random(in: 0...360))
        Square.name = "squareSpread"
        Square.strokeColor = SKColor.yellow
        Square.glowWidth = 30.0
        Square.fillColor = SKColor.clear
        
        self.addChild(Square)
        self.Squares.append(Square)

        let scale = SKAction.scale(to: 1, duration: self.SQUARESPEED)
        Square.run(scale) {
            Square.removeFromParent()
            if let index = self.Squares.firstIndex(of: Square) {
                self.Squares.remove(at:index)
            }
        }
    }
    
    func touchTriangle(atPoint pos : CGPoint) {
        let Triangle = SKShapeNode()
        let path = CGMutablePath()
        path.move(to: CGPoint(x: -2000, y: -1230))
        path.addLine(to: CGPoint(x: 0.0, y: 2234))
        path.addLine(to: CGPoint(x: 2000, y: -1230))
        path.addLine(to: CGPoint(x: -2000, y: -1230))
        Triangle.xScale = 0.001
        Triangle.yScale = 0.001
        Triangle.path = path
        Triangle.position = pos
        Triangle.name = "triangleSpread"
        Triangle.zRotation = CGFloat(Int.random(in: 0...360))
        Triangle.strokeColor = SKColor.blue
        Triangle.glowWidth = 30
        Triangle.fillColor = SKColor.clear
        
        self.addChild(Triangle)
        self.Triangles.append(Triangle)

        let scale = SKAction.scale(to: 1, duration: self.TRIANGLESPEED)
        Triangle.run(scale) {
            Triangle.removeFromParent()
            if let index = self.Triangles.firstIndex(of: Triangle) {
                self.Triangles.remove(at:index)
            }
        }
    }
    
    func sinDegs(_ deg: Double) -> Double {
        return sin(deg * .pi / 180)
    }
    
    func cosDegs(_ deg: Double) -> Double {
        return cos(deg * .pi / 180)
    }
    
    func touchStar(atPoint pos : CGPoint) {
        let Star = SKShapeNode()
        let path = CGMutablePath()
        let OUTERSTAR = 3000.0
        let INNERSTAR = 1250.0
        
        path.move(to: CGPoint(x: OUTERSTAR * cosDegs(18), y: OUTERSTAR * sinDegs(18)))
        path.addLine(to: CGPoint(x: INNERSTAR * cosDegs(54), y: INNERSTAR * sinDegs(54)))
        
        path.addLine(to: CGPoint(x: OUTERSTAR * cosDegs(90), y: OUTERSTAR * sinDegs(90)))
        path.addLine(to: CGPoint(x: INNERSTAR * cosDegs(126), y: INNERSTAR * sinDegs(126)))
        
        path.addLine(to: CGPoint(x: OUTERSTAR * cosDegs(162), y: OUTERSTAR * sinDegs(162)))
        path.addLine(to: CGPoint(x: INNERSTAR * cosDegs(198), y: INNERSTAR * sinDegs(198)))
        
        path.addLine(to: CGPoint(x: OUTERSTAR * cosDegs(234), y: OUTERSTAR * sinDegs(234)))
        path.addLine(to: CGPoint(x: cosDegs(252), y: INNERSTAR * sinDegs(252)))
        
        path.addLine(to: CGPoint(x: OUTERSTAR * cosDegs(306), y: OUTERSTAR * sinDegs(306)))
        path.addLine(to: CGPoint(x: INNERSTAR * cosDegs(342), y: INNERSTAR * sinDegs(342)))
        
        path.addLine(to: CGPoint(x: OUTERSTAR * cosDegs(18), y: OUTERSTAR * sinDegs(18)))
        
        Star.path = path
        
        Star.position = pos
        Star.xScale = 0.001
        Star.yScale = 0.001
        Star.name = "starSpread"
        //Star.zRotation = CGFloat(Int.random(in: 0...360))
        
        Star.strokeColor = SKColor.green
        Star.fillColor = SKColor.clear
        Star.glowWidth = 30.0
        
        self.addChild(Star)
        self.Stars.append(Star)

        let scale = SKAction.scale(to: 1, duration: self.STARSPEED)
        Star.run(scale) {
            Star.removeFromParent()
            if let index = self.Stars.firstIndex(of: Star) {
                self.Stars.remove(at:index)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch:UITouch = touches.first! as UITouch
        let positionInScene = touch.location(in: self)
        let touchedNodes = self.nodes(at: positionInScene)
        
        var isInsideOfCircles: Int = 0
        var isInsideOfSquares: Int = 0
        var isInsideOfTriangles: Int = 0
        var isInsideOfStars: Int = 0
        
        var touchedCircle: Bool = false
        var touchedSquare: Bool = false
        var touchedTriangle: Bool = false
        var touchedStar: Bool = false
        var touchedBomb: Bool = false
        
        var square = SKShapeNode()
        var triangle = SKShapeNode()
        var circle = SKShapeNode()
        var star = SKShapeNode()
        
        for node in touchedNodes {
            if let name = node.name {
                if name == "circleSpread" {
                    isInsideOfCircles += 1
                } else if name == "squareSpread" {
                    isInsideOfSquares += 1
                } else if name == "triangleSpread" {
                    isInsideOfTriangles += 1
                } else if name == "starSpread" {
                    isInsideOfStars += 1
                } else if name == "circle" {
                    touchedCircle = true
                    circle = node as! SKShapeNode
                } else if name == "square" {
                    touchedSquare = true
                    square = node as! SKShapeNode
                } else if name == "triangle" {
                    touchedTriangle = true
                    triangle = node as! SKShapeNode
                } else if name == "star" {
                    touchedStar = true
                    star = node as! SKShapeNode
                } else if name == "bomb" {
                    touchedBomb = true
                } else if name == "startButton" {
                    startPressed = true
                    node.removeFromParent()
                    self.removeAllChildren()
                }
            }
        }
        
        print(isInsideOfSquares)
        
        if touchedCircle {
            for node in self.children {
                if let name = node.name {
                    if name == "circleSpread" {
                        if !circle.intersects(node) {
                            mainMenu()
                        }
                    }
                }
            }
            
            circle.removeFromParent()
            
            for t in touches { self.touchCircle(atPoint: t.location(in: self)) }
        }
        if touchedSquare {
            for node in self.children {
                if let name = node.name {
                    if name == "squareSpread" {
                        if !square.intersects(node) {
                            mainMenu()
                        }
                    }
                }
            }
            
            square.removeFromParent()
            
            for t in touches { self.touchSquare(atPoint: t.location(in: self)) }
        }
        if touchedTriangle {
            for node in self.children {
                if let name = node.name {
                    if name == "triangleSpread" {
                        if !triangle.intersects(node) {
                            mainMenu()
                        }
                    }
                }
            }
            
            triangle.removeFromParent()
            
            
            for t in touches { self.touchTriangle(atPoint: t.location(in: self)) }
        }
        if touchedStar {
            for node in self.children {
                if let name = node.name {
                    if name == "starSpread" {
                        if !star.intersects(node) {
                            mainMenu()
                        }
                    }
                }
            }
            
            star.removeFromParent()
            
            
            for t in touches { self.touchStar(atPoint: t.location(in: self)) }
        }
        if touchedBomb {
            mainMenu()
        }
    }
    
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
