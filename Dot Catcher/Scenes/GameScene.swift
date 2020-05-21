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
    
    var growTime = 4.0
    var dotTime = 7.0
    var dotPeriod = 0.75
    var score = -1
    var buffer = true
    var dotsToBuffer = 25
    var dotsSinceBuffer = 0
    
    let defaults = UserDefaults.standard
    
    var CIRCLESPEED: TimeInterval = 4
    var SQUARESPEED: TimeInterval = 4
    var TRIANGLESPEED: TimeInterval = 4
    var STARSPEED: TimeInterval = 4
    let VARIANCE = 700
    
    let EASY = 0.85
    let NORMAL = 0.75
    let HARD = 0.6
    let EXPERT = 0.5
    let ABSURD = 0.4
    let DIFFICULTYBOXHEIGHT = 250
    
    var difficulty = 1
    
    var startPressed = false
    
    var gameLost = false
    
    var timer = Timer()
    
    override func didMove(to view: SKView) {
        
        self.backgroundColor = UIColor.black
        
        mainMenu()
        
    }
    
    func scheduledTimerWithTimeInterval(){
        // Scheduling timer to Call the function "spawnDots" with the interval of 1 seconds
        timer = Timer.scheduledTimer(timeInterval: dotPeriod, target: self, selector: #selector(self.spawnDots), userInfo: nil, repeats: true)
    }
    
    func mainMenu() {
        
        var highScore = 0
        var lastScore = 0
        
        switch difficulty {
        case 0:
            if score > 0 {
                defaults.set(score, forKey: "lastEasy")
            }
            highScore = defaults.integer(forKey: "easyHighScore")
            lastScore = defaults.integer(forKey: "lastEasy")
            
            if score > highScore {
                defaults.set(score, forKey: "easyHighScore")
                highScore = score
            }
        case 1:
            if score > 0 {
                defaults.set(score, forKey: "lastNormal")
            }
            highScore = defaults.integer(forKey: "normalHighScore")
            lastScore = defaults.integer(forKey: "lastNormal")
            
            if score > highScore {
                defaults.set(score, forKey: "normalHighScore")
                highScore = score
            }
        case 2:
            if score > 0 {
                defaults.set(score, forKey: "lastHard")
            }
            highScore = defaults.integer(forKey: "hardHighScore")
            lastScore = defaults.integer(forKey: "lastHard")
            
            if score > highScore {
                defaults.set(score, forKey: "hardHighScore")
                highScore = score
            }
        case 3:
            if score > 0 {
                defaults.set(score, forKey: "lastExpert")
            }
            highScore = defaults.integer(forKey: "expertHighScore")
            lastScore = defaults.integer(forKey: "lastExpert")
            
            if score > highScore {
                defaults.set(score, forKey: "expertHighScore")
                highScore = score
            }
        case 4:
            if score > 0 {
                defaults.set(score, forKey: "lastAbsurd")
            }
            highScore = defaults.integer(forKey: "absurdHighScore")
            lastScore = defaults.integer(forKey: "lastAbsurd")
            
            if score > highScore {
                defaults.set(score, forKey: "absurdHighScore")
                highScore = score
            }
        default:
            print("error: difficulty out of range.")
        }
        
        score = -1
        
        self.startPressed = false
        
        self.removeAllChildren()
        
        let easyLabel = SKLabelNode(text: "Easy")
        easyLabel.position = CGPoint(x: -280, y: DIFFICULTYBOXHEIGHT - 5)
        easyLabel.fontColor = (difficulty == 0 ? UIColor.green : UIColor.white)
        easyLabel.fontSize = 40
        easyLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        self.addChild(easyLabel)
        
        let easyBox = SKShapeNode(rectOf: CGSize(width: 140, height: 100))
        easyBox.position = CGPoint(x: -280, y: DIFFICULTYBOXHEIGHT)
        easyBox.strokeColor = (difficulty == 0 ? UIColor.green : UIColor.white)
        easyBox.zPosition = (difficulty == 0 ? 1 : 0)
        easyBox.name = "easyBox"
        self.addChild(easyBox)
        
        let normalLabel = SKLabelNode(text: "Normal")
        normalLabel.position = CGPoint(x: -140, y: DIFFICULTYBOXHEIGHT)
        normalLabel.fontColor = (difficulty == 1 ? UIColor.green : UIColor.white)
        normalLabel.fontSize = 40
        normalLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        self.addChild(normalLabel)
        
        let normalBox = SKShapeNode(rectOf: CGSize(width: 140, height: 100))
        normalBox.position = CGPoint(x: -140, y: DIFFICULTYBOXHEIGHT)
        normalBox.strokeColor = (difficulty == 1 ? UIColor.green : UIColor.white)
        normalBox.zPosition = (difficulty == 1 ? 1 : 0)
        normalBox.name = "normalBox"
        self.addChild(normalBox)
        
        let hardLabel = SKLabelNode(text: "Hard")
        hardLabel.position = CGPoint(x: 0, y: DIFFICULTYBOXHEIGHT)
        hardLabel.fontColor = (difficulty == 2 ? UIColor.green : UIColor.white)
        hardLabel.fontSize = 40
        hardLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        self.addChild(hardLabel)
        
        let hardBox = SKShapeNode(rectOf: CGSize(width: 140, height: 100))
        hardBox.position = CGPoint(x: 0, y: DIFFICULTYBOXHEIGHT)
        hardBox.strokeColor = (difficulty == 2 ? UIColor.green : UIColor.white)
        hardBox.zPosition = (difficulty == 2 ? 1 : 0)
        hardBox.name = "hardBox"
        self.addChild(hardBox)
        
        let expertLabel = SKLabelNode(text: "Expert")
        expertLabel.position = CGPoint(x: 140, y: DIFFICULTYBOXHEIGHT - 5)
        expertLabel.fontColor = (difficulty == 3 ? UIColor.green : UIColor.white)
        expertLabel.fontSize = 40
        expertLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        self.addChild(expertLabel)
        
        let expertBox = SKShapeNode(rectOf: CGSize(width: 140, height: 100))
        expertBox.position = CGPoint(x: 140, y: DIFFICULTYBOXHEIGHT)
        expertBox.strokeColor = (difficulty == 3 ? UIColor.green : UIColor.white)
        expertBox.zPosition = (difficulty == 3 ? 1 : 0)
        expertBox.name = "expertBox"
        self.addChild(expertBox)
        
        let absurdLabel = SKLabelNode(text: "Absurd")
        absurdLabel.position = CGPoint(x: 280, y: DIFFICULTYBOXHEIGHT)
        absurdLabel.fontColor = (difficulty == 4 ? UIColor.green : UIColor.white)
        absurdLabel.fontSize = 40
        absurdLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        self.addChild(absurdLabel)
        
        let absurdBox = SKShapeNode(rectOf: CGSize(width: 140, height: 100))
        absurdBox.position = CGPoint(x: 280, y: DIFFICULTYBOXHEIGHT)
        absurdBox.strokeColor = (difficulty == 4 ? UIColor.green : UIColor.white)
        absurdBox.zPosition = (difficulty == 4 ? 1 : 0)
        absurdBox.name = "absurdBox"
        self.addChild(absurdBox)
        
        let startButton = SKShapeNode(rectOf: CGSize(width: 500, height: 200))
        startButton.name = "startButton"
        self.addChild(startButton)
        
        let startButtonLabel = SKLabelNode(text: "Start!")
        startButtonLabel.fontSize = 100
        startButtonLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        self.addChild(startButtonLabel)
        
        /* THIS SECTION IS FOR MAKING ADJUSTMENTS TO SPEEDS AND TIMING
        
        let growTimeLabel = SKLabelNode(text:"Grow Time: " + String(growTime))
        growTimeLabel.position = CGPoint(x: -150, y: 500)
        growTimeLabel.fontSize = 70
        self.addChild(growTimeLabel)
        
        let growTimePlus = SKLabelNode(text:"+")
        growTimePlus.position = CGPoint(x: -150, y: 430)
        growTimePlus.fontSize = 70
        self.addChild(growTimePlus)
        
        let gtpAssist = SKShapeNode(rectOf: CGSize(width: 50, height: 80))
        gtpAssist.name = "growTimePlus"
        gtpAssist.position = CGPoint(x: -150, y: 450)
        self.addChild(gtpAssist)
        
        let growTimeMinus = SKLabelNode(text:"-")
        growTimeMinus.position = CGPoint(x: -280, y: 430)
        growTimeMinus.fontSize = 70
        self.addChild(growTimeMinus)
        
        let gtmAssist = SKShapeNode(rectOf: CGSize(width: 50, height: 80))
        gtmAssist.name = "growTimeMinus"
        gtmAssist.position = CGPoint(x: -280, y: 450)
        self.addChild(gtmAssist)
        
        let dotSpeedLabel = SKLabelNode(text:"Dot Time: " + String(dotTime))
        dotSpeedLabel.position = CGPoint(x: -170, y: 340)
        dotSpeedLabel.fontSize = 70
        self.addChild(dotSpeedLabel)
        
        let dotTimePlus = SKLabelNode(text:"+")
        dotTimePlus.position = CGPoint(x: -150, y: 270)
        dotTimePlus.fontSize = 70
        self.addChild(dotTimePlus)
        
        let dtpAssist = SKShapeNode(rectOf: CGSize(width: 50, height: 80))
        dtpAssist.name = "dotTimePlus"
        dtpAssist.position = CGPoint(x: -150, y: 290)
        self.addChild(dtpAssist)
        
        let dotTimeMinus = SKLabelNode(text:"-")
        dotTimeMinus.position = CGPoint(x: -280, y: 270)
        dotTimeMinus.fontSize = 70
        self.addChild(dotTimeMinus)
        
        let dtmAssist = SKShapeNode(rectOf: CGSize(width: 50, height: 80))
        dtmAssist.name = "dotTimeMinus"
        dtmAssist.position = CGPoint(x: -280, y: 290)
        self.addChild(dtmAssist)
        
        let dotFrequencyLabel = SKLabelNode(text:"Dot Frequency: " + String(dotFrequency))
        dotFrequencyLabel.position = CGPoint(x: -100, y: 200)
        dotFrequencyLabel.fontSize = 70
        self.addChild(dotFrequencyLabel)
        
        let dotFrequencyPlus = SKLabelNode(text:"+")
        dotFrequencyPlus.position = CGPoint(x: -150, y: 130)
        dotFrequencyPlus.fontSize = 70
        self.addChild(dotFrequencyPlus)
        
        let dfpAssist = SKShapeNode(rectOf: CGSize(width: 50, height: 80))
        dfpAssist.name = "dotFrequencyPlus"
        dfpAssist.position = CGPoint(x: -150, y: 150)
        self.addChild(dfpAssist)
        
        let dotFrequencyMinus = SKLabelNode(text:"-")
        dotFrequencyMinus.position = CGPoint(x: -280, y: 130)
        dotFrequencyMinus.fontSize = 70
        self.addChild(dotFrequencyMinus)
        
        let dfmAssist = SKShapeNode(rectOf: CGSize(width: 50, height: 80))
        dfmAssist.name = "dotFrequencyMinus"
        dfmAssist.position = CGPoint(x: -280, y: 150)
        self.addChild(dfmAssist)
 
 */
        
        let lastScoreLabel = SKLabelNode(text: "Last Score: " + String(lastScore))
        lastScoreLabel.fontSize = 80
        lastScoreLabel.position = CGPoint(x: 0, y: -250)
        self.addChild(lastScoreLabel)
        
        let highScoreLabel = SKLabelNode(text: "High Score: " + String(highScore))
        highScoreLabel.fontSize = 80
        highScoreLabel.position = CGPoint(x: 0, y: -400)
        self.addChild(highScoreLabel)
        
        CIRCLESPEED = TimeInterval(growTime)
        SQUARESPEED = TimeInterval(growTime)
        TRIANGLESPEED = TimeInterval(growTime * 0.9)
        STARSPEED = TimeInterval(growTime)
        
        switch difficulty {
        case 0 :
            dotPeriod = 0.85
        case 1:
            dotPeriod = 0.75
        case 2:
            dotPeriod = 0.6
        case 3:
            dotPeriod = 0.5
        case 4:
            dotPeriod = 0.4
        default:
            print("Error: difficulty out of range.")
        }
    }
    
    @objc func spawnDots() {
        if startPressed {
            let skip = false
            let dotType = Int.random(in: 0...2)
            let OUTERSTAR = 30.0 * 2
            let INNERSTAR = 12.50 * 2
            var dot = SKShapeNode()
            switch dotType {
            case 0:
                dot = SKShapeNode(circleOfRadius: 50)
                dot.name = "circle"
            case 1:
//                skip = true
                dot = SKShapeNode(rectOf: CGSize(width:90, height:90))
                dot.name = "square"
            case 2:
//                skip = true
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
            if !skip {
                dot.zRotation = CGFloat(Int.random(in: 0...360))
                self.addChild(dot)
                var move = SKAction()
                let coinFlip = Int.random(in: 0...1)
                if coinFlip == 0 {
                    let startX = UIScreen.main.bounds.width + 50
                    let startY = Int.random(in: -Int(UIScreen.main.bounds.height)...Int(UIScreen.main.bounds.height))
                    dot.position = CGPoint(x: startX, y: CGFloat(startY))
                    move = SKAction.move(to: CGPoint(x: -1 * UIScreen.main.bounds.width - 50, y: CGFloat(Int.random(in: startY * -1 - VARIANCE...startY * -1 + VARIANCE))), duration: dotTime)
                } else {
                    let startX = -1 * UIScreen.main.bounds.width - 50
                    let startY = Int.random(in: -Int(UIScreen.main.bounds.height)...Int(UIScreen.main.bounds.height))
                    dot.position = CGPoint(x: startX, y: CGFloat(startY))
                    move = SKAction.move(to: CGPoint(x: UIScreen.main.bounds.width + 50, y: CGFloat(Int.random(in: startY * -1 - VARIANCE...startY * -1 + VARIANCE))), duration: dotTime)
                }
                
                
                dot.run(move) {
                    dot.removeFromParent()
                    self.checkLoss()
                }
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
        Triangle.strokeColor = UIColor(displayP3Red: 0.5, green: 0.0, blue: 1.0, alpha: 1.0)
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
                    timer.invalidate()
                    scheduledTimerWithTimeInterval()
                    plusScore()
                    gameLost = false
                    buffer = true
                    updateBuffer()
                } else if name == "growTimePlus" {
                    growTime += 0.25
                    mainMenu()
                } else if name == "growTimeMinus" {
                    growTime -= 0.25
                    mainMenu()
                } else if name == "dotTimePlus" {
                    dotTime += 0.25
                    mainMenu()
                } else if name == "dotTimeMinus" {
                    dotTime -= 0.25
                    mainMenu()
                } else if name == "dotFrequencyPlus" {
                    dotPeriod += 0.05
                    mainMenu()
                } else if name == "dotFrequencyMinus" {
                    dotPeriod -= 0.05
                    mainMenu()
                } else if name == "easyBox" {
                    difficulty = 0
                    mainMenu()
                } else if name == "normalBox" {
                    difficulty = 1
                    mainMenu()
                } else if name == "hardBox" {
                    difficulty = 2
                    mainMenu()
                } else if name == "expertBox" {
                    difficulty = 3
                    mainMenu()
                } else if name == "absurdBox" {
                    difficulty = 4
                    mainMenu()
                }
            }
        }
        
        if touchedCircle {
            
            circle.removeFromParent()
            
            plusScore()
            
            for node in self.children {
                if let name = node.name {
                    if name == "circleSpread" {
                        if !circle.intersects(node) {
                            checkLoss()
                        }
                    }
                }
            }
            
            updateBuffer()
            
            for t in touches { self.touchCircle(atPoint: t.location(in: self)) }
        }
        if touchedSquare {
            
            square.removeFromParent()
            
            plusScore()
            
            for node in self.children {
                if let name = node.name {
                    if name == "squareSpread" {
                        if !square.intersects(node) {
                            checkLoss()
                        }
                    }
                }
            }
            
            updateBuffer()
            
            for t in touches { self.touchSquare(atPoint: t.location(in: self)) }
        }
        if touchedTriangle {
            
            triangle.removeFromParent()
            
            plusScore()
            
            for node in self.children {
                if let name = node.name {
                    if name == "triangleSpread" {
                        if !triangle.intersects(node) {
                            checkLoss()
                        }
                    }
                }
            }
            
            updateBuffer()
            
            for t in touches { self.touchTriangle(atPoint: t.location(in: self)) }
        }
        if touchedStar {
            
            star.removeFromParent()
            
            plusScore()
            
            for node in self.children {
                if let name = node.name {
                    if name == "starSpread" {
                        if !star.intersects(node) {
                            checkLoss()
                        }
                    }
                }
            }
            
            updateBuffer()
            
            for t in touches { self.touchStar(atPoint: t.location(in: self)) }
        }
        if touchedBomb {
            mainMenu()
        }
    }
    
    func checkLoss() {
        if buffer {
            buffer = false
            dotsSinceBuffer = 0
            updateBuffer()
            flashBackground()
        } else {
            gameLost = true
            flashBackground()
            mainMenu()
        }
    }
    
    func bufferActive() {
        buffer = true
        
        let flash = SKAction.colorize(with: UIColor.blue, colorBlendFactor: 1, duration: 0.05)
        let unflash = SKAction.colorize(with: UIColor.black, colorBlendFactor: 1, duration: 0.4)
        self.run(flash) {
            self.run(unflash)
        }
        dotsToBuffer *= 2
        
    }
    
    func updateBuffer() {
        if dotsToBuffer == dotsSinceBuffer {
            bufferActive()
        }
        
        if let currentBuffer = self.childNode(withName: "bufferNode") {
                   currentBuffer.removeFromParent()
               }
        
        if buffer {
            let bufferLabel = SKLabelNode(text: "Buffer Active")
            bufferLabel.position = CGPoint(x: -250, y: 550)
            bufferLabel.fontSize = 50
            bufferLabel.name = "bufferNode"
            self.addChild(bufferLabel)
        }
        
        if gameLost {
            if let badBufferNode = self.childNode(withName: "bufferNode") {
                badBufferNode.removeFromParent()
            }
        }
    }
    
    func plusScore() {
        score += 1

        if !buffer {
            dotsSinceBuffer += 1
        }
        
        updateBuffer()
        
        if let currentScore = self.childNode(withName: "scoreNode") {
            currentScore.removeFromParent()
        }
        let scoreLabel = SKLabelNode(text: String(score))
        scoreLabel.position = CGPoint(x: 300, y: 550)
        scoreLabel.fontSize = 50
        scoreLabel.name = "scoreNode"
        self.addChild(scoreLabel)
    }
    
    func flashBackground() {
        let flash = SKAction.colorize(with: UIColor.red, colorBlendFactor: 1, duration: 0.05)
        let unflash = SKAction.colorize(with: UIColor.black, colorBlendFactor: 1, duration: 0.4)
        self.run(flash) {
            self.run(unflash)
        }
    
        
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        
    }
}
