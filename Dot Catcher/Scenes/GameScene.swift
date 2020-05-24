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
import Foundation
import AVFoundation

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
    var videoTimer = Timer()
    
    var backgroundMusic: AVAudioPlayer?
    var circleNoise: AVAudioPlayer?
    var triangleNoise: AVAudioPlayer?
    var squareNoise: AVAudioPlayer?
    var badNoise: AVAudioPlayer?
    var bufferNoise: AVAudioPlayer?
    
    var soundsOn = true
    
    var rightSide: CGFloat?
    var topSide: CGFloat?
    
    var topConstant = 0
    var sideConstant = 0
    var tutorialFontSize = CGFloat(0)
    
    var gamePaused = false
    var tutorialCount = 0
    
    var video = ""
    
    override func didMove(to view: SKView) {
        
        iPhoneScreenSizes()
        
        topSide = UIScreen.main.bounds.height - CGFloat(topConstant)
        rightSide = UIScreen.main.bounds.width - CGFloat(sideConstant)
        
        self.backgroundColor = UIColor.black
        
        do {
            let badPath = Bundle.main.path(forResource: "bad.aif", ofType: nil)!
            let badUrl = URL(fileURLWithPath: badPath)
            badNoise = try AVAudioPlayer(contentsOf: badUrl)
            badNoise?.volume = 0.7
        } catch {
            print("AAAA")
        }
        
        let trianglePath = Bundle.main.path(forResource: "triangle.aif", ofType: nil)!
        let triangleUrl = URL(fileURLWithPath: trianglePath)
        do {
            triangleNoise = try AVAudioPlayer(contentsOf: triangleUrl)
            triangleNoise?.volume = 1.5
            
        } catch {
            print("AAAAA")
        }
        
        let circlePath = Bundle.main.path(forResource: "circle.aif", ofType: nil)!
        let circleUrl = URL(fileURLWithPath: circlePath)
        
        do {
            circleNoise = try AVAudioPlayer(contentsOf: circleUrl)
            circleNoise?.volume = 0.6
        } catch {
            print("AAAAA")
        }
        
        let squarePath = Bundle.main.path(forResource: "square.aif", ofType: nil)!
        let squareUrl = URL(fileURLWithPath: squarePath)
        
        do {
            squareNoise = try AVAudioPlayer(contentsOf: squareUrl)
            
        } catch {
            print("AAAAA")
        }
        
        let bufferPath = Bundle.main.path(forResource: "buffer.aif", ofType: nil)!
        let bufferUrl = URL(fileURLWithPath: bufferPath)
        
        do {
            bufferNoise = try AVAudioPlayer(contentsOf: bufferUrl)
            bufferNoise?.volume = 0.7
        } catch {
            print("AAAAA")
        }
        
        let path = Bundle.main.path(forResource: "music.mp3", ofType: nil)!
        let url = URL(fileURLWithPath: path)
        
        do {
            backgroundMusic = try AVAudioPlayer(contentsOf: url)
            backgroundMusic?.numberOfLoops = -1
            backgroundMusic?.volume = 0.5
            self.backgroundMusic?.play()
            
        } catch {
            print("AAAAA")
        }
        
        mainMenu()
        
    }
    
    func iPhoneScreenSizes() {
        let bounds = UIScreen.main.bounds
        let height = bounds.size.height

        switch height {
        case 480.0:
            fallthrough
        case 568.0:
            fallthrough
        case 667.0:
            fallthrough
        case 736.0:
            topConstant = 50
            sideConstant = 0
            tutorialFontSize = 40
        case 812.0:
            topConstant = 220
            sideConstant = 50
            tutorialFontSize = 35
        case 896.0:
            topConstant = 300
            sideConstant = 90
            tutorialFontSize = 35
        default:
            topConstant = 0

        }
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
        
        createDifficultyNodes()
        
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
        
        createMusicOptions()
        
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
        
        dotsToBuffer = 25
        dotsSinceBuffer = 0
        
        let tutorialButton = SKShapeNode(rectOf: CGSize(width: 200, height: 100))
        tutorialButton.position = CGPoint(x: 0, y: -525)
        tutorialButton.name = "tutorialButton"
        addChild(tutorialButton)
        
        let tutorialLabel = SKLabelNode(text: "Tutorial")
        tutorialLabel.position = tutorialButton.position
        tutorialLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        tutorialLabel.fontSize = 50
        addChild(tutorialLabel)
    }
    
    func createDifficultyNodes() {
        let easyLabel = SKLabelNode(text: "Easy")
        easyLabel.position = CGPoint(x: -70, y: DIFFICULTYBOXHEIGHT + 95)
        easyLabel.fontColor = (difficulty == 0 ? UIColor.green : UIColor.white)
        easyLabel.fontSize = 40
        easyLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        self.addChild(easyLabel)
        
        let easyBox = SKShapeNode(rectOf: CGSize(width: 140, height: 100))
        easyBox.position = CGPoint(x: -70, y: DIFFICULTYBOXHEIGHT + 100)
        easyBox.strokeColor = (difficulty == 0 ? UIColor.green : UIColor.white)
        easyBox.zPosition = (difficulty == 0 ? 1 : 0)
        easyBox.name = "easyBox"
        self.addChild(easyBox)
        
        let normalLabel = SKLabelNode(text: "Normal")
        normalLabel.position = CGPoint(x: 70, y: DIFFICULTYBOXHEIGHT + 100)
        normalLabel.fontColor = (difficulty == 1 ? UIColor.green : UIColor.white)
        normalLabel.fontSize = 40
        normalLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        self.addChild(normalLabel)
        
        let normalBox = SKShapeNode(rectOf: CGSize(width: 140, height: 100))
        normalBox.position = CGPoint(x: 70, y: DIFFICULTYBOXHEIGHT + 100)
        normalBox.strokeColor = (difficulty == 1 ? UIColor.green : UIColor.white)
        normalBox.zPosition = (difficulty == 1 ? 1 : 0)
        normalBox.name = "normalBox"
        self.addChild(normalBox)
        
        let hardLabel = SKLabelNode(text: "Hard")
        hardLabel.position = CGPoint(x: -140, y: DIFFICULTYBOXHEIGHT)
        hardLabel.fontColor = (difficulty == 2 ? UIColor.green : UIColor.white)
        hardLabel.fontSize = 40
        hardLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        self.addChild(hardLabel)
        
        let hardBox = SKShapeNode(rectOf: CGSize(width: 140, height: 100))
        hardBox.position = CGPoint(x: -140, y: DIFFICULTYBOXHEIGHT)
        hardBox.strokeColor = (difficulty == 2 ? UIColor.green : UIColor.white)
        hardBox.zPosition = (difficulty == 2 ? 1 : 0)
        hardBox.name = "hardBox"
        self.addChild(hardBox)
        
        let expertLabel = SKLabelNode(text: "Expert")
        expertLabel.position = CGPoint(x: 0, y: DIFFICULTYBOXHEIGHT - 5)
        expertLabel.fontColor = (difficulty == 3 ? UIColor.green : UIColor.white)
        expertLabel.fontSize = 40
        expertLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        self.addChild(expertLabel)
        
        let expertBox = SKShapeNode(rectOf: CGSize(width: 140, height: 100))
        expertBox.position = CGPoint(x: 0, y: DIFFICULTYBOXHEIGHT)
        expertBox.strokeColor = (difficulty == 3 ? UIColor.green : UIColor.white)
        expertBox.zPosition = (difficulty == 3 ? 1 : 0)
        expertBox.name = "expertBox"
        self.addChild(expertBox)
        
        let absurdLabel = SKLabelNode(text: "Absurd")
        absurdLabel.position = CGPoint(x: 140, y: DIFFICULTYBOXHEIGHT)
        absurdLabel.fontColor = (difficulty == 4 ? UIColor.green : UIColor.white)
        absurdLabel.fontSize = 40
        absurdLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        self.addChild(absurdLabel)
        
        let absurdBox = SKShapeNode(rectOf: CGSize(width: 140, height: 100))
        absurdBox.position = CGPoint(x: 140, y: DIFFICULTYBOXHEIGHT)
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
    }
    
    func createMusicOptions() {
        let musicNode = SKLabelNode(text: "Music: " + (backgroundMusic!.isPlaying ? "On" : "Off"))
        musicNode.position = CGPoint(x: -1 * rightSide! + 50, y: topSide! - 50)
        musicNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        musicNode.fontSize = 40
        addChild(musicNode)
        
        let musicNodeBox = SKShapeNode(rectOf: CGSize(width: 200, height: 100))
        musicNodeBox.position = CGPoint(x: -1 * rightSide! + 140, y: topSide! - 50)
        musicNodeBox.name = "musicBox"
        musicNodeBox.strokeColor = UIColor.clear
        addChild(musicNodeBox)
        
        let soundsNode = SKLabelNode(text: "Sounds: " + (soundsOn ? "On" : "Off" ))
        soundsNode.position = CGPoint(x: rightSide! - 50, y: topSide! - 50)
        soundsNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        soundsNode.fontSize = 40
        addChild(soundsNode)
        
        let soundsNodeBox = SKShapeNode(rectOf: CGSize(width: 240, height: 100))
        soundsNodeBox.position = CGPoint(x: rightSide! - 140, y: topSide! - 50)
        soundsNodeBox.name = "soundsBox"
        soundsNodeBox.strokeColor = UIColor.clear
        addChild(soundsNodeBox)
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
                    let startX = rightSide! + 50
                    let startY = Int.random(in: -Int(topSide!)...Int(topSide!))
                    dot.position = CGPoint(x: startX, y: CGFloat(startY))
                    move = SKAction.move(to: CGPoint(x: -1 * rightSide! - 50, y: CGFloat(Int.random(in: startY * -1 - VARIANCE...startY * -1 + VARIANCE))), duration: dotTime)
                } else {
                    let startX = -1 * rightSide! - 50
                    let startY = Int.random(in: -Int(topSide!)...Int(topSide!))
                    dot.position = CGPoint(x: startX, y: CGFloat(startY))
                    move = SKAction.move(to: CGPoint(x: rightSide! + 50, y: CGFloat(Int.random(in: startY * -1 - VARIANCE...startY * -1 + VARIANCE))), duration: dotTime)
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
                    addPauseButton()
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
                } else if name == "musicBox" {
                    if backgroundMusic!.isPlaying {
                        backgroundMusic?.pause()
                    } else {
                        backgroundMusic?.play()
                    }
                    mainMenu()
                } else if name == "soundsBox" {
                    if soundsOn {
                        soundsOn = false
                    } else {
                        soundsOn = true
                    }
                    mainMenu()
                } else if name == "dismissHomeBox" {
                    buffer = false
                    gamePaused = false
                    checkLoss()
                } else if name == "dismissBox" {
                    for thing in children {
                        if thing.name?.contains("info") ?? false || thing.name?.contains("dismiss") ?? false {
                            thing.removeFromParent()
                        }
                    }
                    unpauseGame()
                } else if name == "pauseButton" {
                    pauseGame()
                } else if name == "tutorialButton" {
                    tutorial()
                } else if name == "tutorialNext" {
                    self.removeAllChildren()
                    videoTimer.invalidate()
                    switch tutorialCount {
                    case 0: tutorial2()
                    case 1: tutorial3()
                    default:
                        tutorialCount = -1
                        mainMenu()
                    }
                    tutorialCount += 1
                }
            }
        }
        
        if !gamePaused {
        
            if touchedCircle {
                
                circle.removeFromParent()
                
                plusScore()
                
                if soundsOn {
                    DispatchQueue.global().async {
                        self.circleNoise?.currentTime = 0;
                        self.circleNoise?.play()
                   }
                }
                
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
               
                if soundsOn {
                    DispatchQueue.global().async {
                        self.squareNoise?.currentTime = 0
                        self.squareNoise?.play()
                    }
                }
                
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
                
                if soundsOn {
                    
                    DispatchQueue.global().async {
                        self.triangleNoise?.currentTime = 0
                        self.triangleNoise?.play()
                    }
                }
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
    }
    
    func pauseGame() {
        timer.invalidate()
        gamePaused = true
        for node in self.children {
            if node.name?.contains("pauseButton") ?? false {
                node.removeFromParent()
            }
            node.isPaused = true
        }
        
        spawnInfoBox(fillColor: UIColor.black, strokeColor: UIColor.white, text: "Paused", dismissText: "Resume")
        
    }
    
    func unpauseGame() {
        let three = SKLabelNode(text: "3")
        three.fontSize = 500
        three.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        self.addChild(three)
        
        let fade = SKAction.fadeOut(withDuration: 1)
        
        three.run(fade) {
            three.removeFromParent()
            let two = SKLabelNode(text: "2")
            two.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
            two.fontSize = 500
            self.addChild(two)
            two.run(fade) {
                two.removeFromParent()
                let one = SKLabelNode(text: "1")
                one.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
                one.fontSize = 500
                self.addChild(one)
                one.run(fade) {
                    one.removeFromParent()
                    self.addPauseButton()
                    self.scheduledTimerWithTimeInterval()
                    self.gamePaused = false
                    for node in self.children {
                        node.isPaused = false
                    }
                }
            }
        }
    }
    
    func addPauseButton() {
        let pauseButton = SKShapeNode(rectOf: CGSize(width: 100, height: 100))
        pauseButton.position = CGPoint(x: rightSide! - 100, y: topSide! * -1 + 50)
        pauseButton.name = "pauseButton"
        pauseButton.zPosition = 0
        self.addChild(pauseButton)
        
        let pauseButtonLabel1 = SKShapeNode(rectOf: CGSize(width: 30, height: 80))
        pauseButtonLabel1.position = CGPoint(x: rightSide! - 125, y: topSide! * -1 + 50)
        pauseButtonLabel1.fillColor = UIColor.white
        pauseButtonLabel1.name = "pauseButtonLabel"
        pauseButtonLabel1.zPosition = 1
        self.addChild(pauseButtonLabel1)
        
        let pauseButtonLabel2 = SKShapeNode(rectOf: CGSize(width: 30, height: 80))
        pauseButtonLabel2.position = CGPoint(x: rightSide! - 75, y: topSide! * -1 + 50)
        pauseButtonLabel2.fillColor = UIColor.white
        pauseButtonLabel2.name = "pauseButtonLabel"
        pauseButtonLabel2.zPosition = 1
        self.addChild(pauseButtonLabel2)
    }
    
    func spawnInfoBox(fillColor: UIColor, strokeColor: UIColor, text: String, dismissText: String) {
        
        let dismissBox = SKShapeNode(rectOf: CGSize(width: 300, height: 100))
        dismissBox.position = CGPoint(x: rightSide! - 200, y: -1 * topSide! + 250)
        dismissBox.strokeColor = UIColor.clear
        dismissBox.name = "dismissBox"
        dismissBox.zPosition = 2
        addChild(dismissBox)
        
        let backgroundBox = SKShapeNode(rectOf: CGSize(width: Int(rightSide!) * 2 - 50, height: Int(topSide!) * 2 - 300 ))
        backgroundBox.fillColor = fillColor
        backgroundBox.strokeColor = strokeColor
        backgroundBox.name = "infoBox"
        backgroundBox.zPosition = 2
        addChild(backgroundBox)
        
        let infoNode = SKLabelNode(text: text)
        infoNode.preferredMaxLayoutWidth = rightSide! * 2 - 100
        infoNode.fontSize = 100
        infoNode.name = "infoLabel"
        infoNode.zPosition = 3
        addChild(infoNode)
        
        let dismissNode = SKLabelNode(text: dismissText)
        dismissNode.position = CGPoint(x: rightSide! - 200, y: -1 * topSide! + 250)
        dismissNode.fontSize = 50
        dismissNode.name = "dismissLabel"
        dismissNode.zPosition = 3
        addChild(dismissNode)
        
        let homeNode = SKLabelNode(text: "Main Menu")
        homeNode.position = CGPoint(x: rightSide! * -1 + 200, y: -1 * topSide! + 250)
        homeNode.fontSize = 50
        homeNode.name = "dismissHome"
        homeNode.zPosition = 3
        addChild(homeNode)
        
        let homeBox = SKShapeNode(rectOf: CGSize(width: 300, height: 100))
        homeBox.position = CGPoint(x: -1 * rightSide! + 200, y: -1 * topSide! + 250)
        homeBox.strokeColor = UIColor.clear
        homeBox.name = "dismissHomeBox"
        homeBox.zPosition = 2
        addChild(homeBox)
        
    }
    
    func checkLoss() {
        if soundsOn {
            DispatchQueue.global().async {
                self.badNoise?.currentTime = 0
                self.badNoise?.play()
            }
        }
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
        
        if soundsOn {
            DispatchQueue.global().async {
                self.bufferNoise?.currentTime = 0
                self.bufferNoise?.play()
            }
        }
        
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
            bufferLabel.position = CGPoint(x: -1 * rightSide! + 50, y: topSide! - 50)
            bufferLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
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
        scoreLabel.position = CGPoint(x: rightSide! - 50, y: topSide! - 50)
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
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
    
    func tutorial() {
        removeAllChildren()

        video = "Dot Catcher.mov"
        
        let background1 = SKSpriteNode(imageNamed: "videoBG1.png")
        background1.xScale = 0.437 * 0.66
        background1.yScale = 0.437 * 0.66
        background1.position = CGPoint(x: 0, y: -10 + 100)
        background1.name = "background"
        background1.zPosition = -5
        addChild(background1)
        
        let video1 = SKVideoNode(fileNamed: video)
        video1.xScale = 0.5 * 0.66
        video1.yScale = 0.5 * 0.66
        video1.name = "video"
        video1.position = CGPoint(x: 0, y: 100)
        addChild(video1)
        video1.play()
        
        videoTimer = Timer.scheduledTimer(timeInterval: 2.3, target: self, selector: #selector(self.playVideo), userInfo: nil, repeats: true)
        
        tutorialInfoBox(position: CGPoint(x: 0, y: topSide! - 100), size: CGSize(width: rightSide! * 1.8, height: 100), text: "Tap a shape to make it expand", arrowPosition: nil, arrowRotation: nil)
        
        tutorialInfoBox(position: CGPoint(x: 0, y: -topSide! + 275), size: CGSize(width: rightSide! * 1.8, height: 200), text: "Only tap shapes when they're within all other expanding shapes of the same type. Do not allow any shapes to make it off-screen.", arrowPosition: nil, arrowRotation: nil)
        
        let nextButton = SKShapeNode(rectOf: CGSize(width: 140, height: 80))
        nextButton.name = "tutorialNext"
        nextButton.position = CGPoint(x: 0, y: -topSide! + 100)
        addChild(nextButton)
        
        let nextButtonLabel = SKLabelNode(text: "Next")
        nextButtonLabel.position = nextButton.position
        nextButtonLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        nextButtonLabel.fontSize = 50
        addChild(nextButtonLabel)
    }
    
    func tutorial2() {
        video = "Dot Catcher 2.mov"
        
        let background1 = SKSpriteNode(imageNamed: "videoBG2.png")
        background1.xScale = 0.437 * 0.66
        background1.yScale = 0.437 * 0.66
        background1.position = CGPoint(x: 0, y: -10 + 100)
        background1.name = "background"
        background1.zPosition = -5
        addChild(background1)
        
        let video1 = SKVideoNode(fileNamed: video)
        video1.xScale = 0.5 * 0.66
        video1.yScale = 0.5 * 0.66
        video1.name = "video"
        video1.position = CGPoint(x: 0, y: 100)
        addChild(video1)
        video1.play()
        
        videoTimer = Timer.scheduledTimer(timeInterval: 2.3, target: self, selector: #selector(self.playVideo), userInfo: nil, repeats: true)
        
        tutorialInfoBox(position: CGPoint(x: 0, y: topSide! - 80), size: CGSize(width: rightSide! * 1.8, height: 170), text: "If you tap a shape when it is outside of other expanding shapes, you'll lose your buffer. If you do it again, you'll lose.", arrowPosition: CGPoint(x: 130, y: 180), arrowRotation: CGFloat.pi / 4)
        
        tutorialInfoBox(position: CGPoint(x: 0, y: -topSide! + 275), size: CGSize(width: rightSide! * 1.8, height: 200), text: "The first time, your buffer will return after you gain 25 points. Each time you lose it, it will take twice as many points to regain it.", arrowPosition: nil, arrowRotation: nil)
        
        let nextButton = SKShapeNode(rectOf: CGSize(width: 140, height: 80))
        nextButton.name = "tutorialNext"
        nextButton.position = CGPoint(x: 0, y: -topSide! + 100)
        addChild(nextButton)
        
        let nextButtonLabel = SKLabelNode(text: "Next")
        nextButtonLabel.position = nextButton.position
        nextButtonLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        nextButtonLabel.fontSize = 50
        addChild(nextButtonLabel)
    }
    
    func tutorial3() {
        video = "Dot Catcher 3.mov"
        
        let background1 = SKSpriteNode(imageNamed: "videoBG3.png")
        background1.xScale = 0.437 * 0.66
        background1.yScale = 0.437 * 0.66
        background1.position = CGPoint(x: 0, y: -10 + 100)
        background1.name = "background"
        background1.zPosition = -5
        addChild(background1)
        
        let video1 = SKVideoNode(fileNamed: video)
        video1.xScale = 0.5 * 0.66
        video1.yScale = 0.5 * 0.66
        video1.name = "video"
        video1.position = CGPoint(x: 0, y: 100)
        addChild(video1)
        video1.play()
        
        videoTimer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(self.playVideo), userInfo: nil, repeats: true)
        
        tutorialInfoBox(position: CGPoint(x: 0, y: topSide! - 80), size: CGSize(width: rightSide! * 1.8, height: 170), text: "It's okay to tap shapes outside of the expanding shapes, as long as they're different shapes.", arrowPosition: CGPoint(x: 130, y: 350), arrowRotation: CGFloat.pi - CGFloat.pi / 4)
        
        tutorialInfoBox(position: CGPoint(x: 0, y: -topSide! + 275), size: CGSize(width: rightSide! * 1.4, height: 100), text: "You're ready to play now!", arrowPosition: nil, arrowRotation: nil)
        
        let nextButton = SKShapeNode(rectOf: CGSize(width: 140, height: 80))
        nextButton.name = "tutorialNext"
        nextButton.position = CGPoint(x: 0, y: -topSide! + 100)
        addChild(nextButton)
        
        let nextButtonLabel = SKLabelNode(text: "Done")
        nextButtonLabel.position = nextButton.position
        nextButtonLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        nextButtonLabel.fontSize = 50
        addChild(nextButtonLabel)
    }
    
    @objc func playVideo() {
        var stop = false
        
        let video1 = SKVideoNode(fileNamed: video)
        video1.xScale = 0.5 * 0.66
        video1.yScale = 0.5 * 0.66
        video1.name = "video"
        video1.position = CGPoint(x: 0, y: 100)
        addChild(video1)
        video1.play()
        
        for node in children {
            if node.name == "video" && !stop {
                node.removeFromParent()
                stop = true
            }
        }
    }
    
    func tutorialInfoBox(position: CGPoint, size: CGSize, text: String, arrowPosition: CGPoint?, arrowRotation: CGFloat?) {
    
        let infoBox = SKShapeNode(rectOf: size)
        infoBox.position = position
        infoBox.name = "infoBox"
        addChild(infoBox)
        
        let infoLabel = SKLabelNode(text: text)
        infoLabel.preferredMaxLayoutWidth = size.width - 20
        infoLabel.fontSize = tutorialFontSize
        infoLabel.numberOfLines = 2
        infoLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        infoLabel.position = position
        infoLabel.name = "infoLabel"
        addChild(infoLabel)
        
        if arrowPosition != nil {
            let arrow = SKShapeNode()
            let path = CGMutablePath()
            path.move(to: CGPoint(x: -25, y: -50))
            path.addLine(to: CGPoint(x: 25, y: -50))
            path.addLine(to: CGPoint(x: 25, y: 0))
            path.addLine(to: CGPoint(x: 50, y: 0))
            path.addLine(to: CGPoint(x: 0, y: 50))
            path.addLine(to: CGPoint(x: -50, y: 0))
            path.addLine(to: CGPoint(x: -25, y: 0))
            path.addLine(to: CGPoint(x: -25, y: -50))
            arrow.zPosition = 10
            arrow.path = path
            
            arrow.position = arrowPosition ?? CGPoint(x: 0, y: 0)
            arrow.zRotation = arrowRotation ?? CGFloat(0)
            arrow.fillColor = UIColor.white
            
            arrow.name = "infoArrow"
            
            addChild(arrow)
        }
    
    }
    
    override func update(_ currentTime: TimeInterval) {
        
    }
}
