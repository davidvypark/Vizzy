//
//  GameScene.swift
//  Vizzy
//
//  Created by David Park on 6/10/16.
//  Copyright (c) 2016 David Park. All rights reserved.
//

import SpriteKit
import AVFoundation
import CoreMotion


struct PhysicsCategory {
    static let None             : UInt32 = 0
    static let All              : UInt32 = UInt32.max
    static let rectangleSprite  : UInt32 = 0b1              //1
}

let manager = CMMotionManager()

class GameScene: SKScene, SKPhysicsContactDelegate {
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        let myLabel = SKLabelNode(fontNamed:"BradleyHandITCTT-Bold")
        myLabel.text = "༼ つ ◕_◕ ༽つ Let's Jam ༼ つ ◕_◕ ༽つ"
        myLabel.fontSize = 25
        myLabel.fontColor = UIColor.cyanColor()
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        self.backgroundColor = UIColor.blackColor()
        
        self.addChild(myLabel)
        
        let demoMusic = SKAudioNode(fileNamed:"DemoSong")
        demoMusic.autoplayLooped = true
        addChild(demoMusic)
        
        self.addBeatPulse()
        
        //Continuous stream of particles. Need to scale the alpha opacity and frequency based off volume. No beats or peaks for this layer
        
        runAction(SKAction.repeatActionForever(SKAction.sequence([SKAction.runBlock({self.addRectangle(CGPoint(x: CGFloat(arc4random_uniform(700))
            ,y: 100.0))}), SKAction.waitForDuration(0.05)])))
        
        //create an algo with time as a variable to create a visualization. use volume as a scaler (probably exponential)
        //Implement Here
        
        if manager.deviceMotionAvailable {
            manager.deviceMotionUpdateInterval = 0.02
            manager.startDeviceMotionUpdatesToQueue(NSOperationQueue.mainQueue()) {
                [weak self] (data: CMDeviceMotion?, error: NSError?) in
                
                if data?.userAcceleration.x < -0.5 {
                    self!.backgroundColor = UIColor(
                        red: CGFloat(drand48()),
                        green:CGFloat(drand48()),
                        blue: CGFloat(drand48()), alpha: 1)
                    
                    myLabel.fontColor = UIColor(
                        red: CGFloat(drand48()),
                        green:CGFloat(drand48()),
                        blue: CGFloat(drand48()), alpha: 1)
                
                }
            }
        }
        
    }
    
    func addRectangle(location:CGPoint) {
        
        let length = 2 + arc4random_uniform(13)
        let width = 13 + arc4random_uniform(26)
        
        let rectangleSprite = SKSpriteNode(color:UIColor(
            red: CGFloat(drand48()),
            green:CGFloat(drand48()),
            blue: CGFloat(drand48()), alpha: 1),
                                           
                                           size:CGSizeMake(CGFloat(length), CGFloat(width)))
        
        rectangleSprite.position = location
        
        let spinAction = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
        let fadeAction = SKAction.fadeOutWithDuration(Double(2+arc4random_uniform(4)))
        let removeNode = SKAction.removeFromParent()
        let sequence = SKAction.sequence([fadeAction,removeNode])
        
        rectangleSprite.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(CGFloat(length), CGFloat(width)))
        rectangleSprite.physicsBody?.dynamic = true
        rectangleSprite.physicsBody?.categoryBitMask = PhysicsCategory.rectangleSprite
        rectangleSprite.physicsBody?.collisionBitMask = PhysicsCategory.rectangleSprite
        self.physicsWorld.gravity = CGVectorMake(CGFloat(drand48()), CGFloat(drand48()))
        
        rectangleSprite.runAction(SKAction.repeatActionForever(spinAction))
        rectangleSprite.runAction(sequence)
        
        addChild(rectangleSprite)
        
    }
    
    func addBeatPulse() {
        
        let pulseSprite = SKSpriteNode(imageNamed: "BeatPulse")                    //Work on this make it actually pulse by add grow shrink remove
        pulseSprite.zPosition = -1
        pulseSprite.position = CGPoint(x: 500.0, y: 400.0)
        
        let pulseUp = SKAction.scaleTo(1.5, duration: 0.08)                     //scale this based off volume
        let pulseDown = SKAction.scaleTo(1.0, duration: 0.601818)                //but keep it with the beat
        let pulse = SKAction.sequence([pulseUp, pulseDown])
        let repeatPulse = SKAction.repeatActionForever(pulse)
        pulseSprite.runAction(repeatPulse)
        
        addChild(pulseSprite)
        
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        for touch in touches {
            let location = touch.locationInNode(self)
            
            self.addRectangle(location)
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // Called when the finger drags
        for touch in touches {
            let location = touch.locationInNode(self)
        
            self.addRectangle(location)
        }
    }
    
//    override func motionBegan(motion: UIEventSubtype, withEvent event: UIEvent?) {
//        // Called when the device movoes
//        let panGesture = UIPanGestureRecognizer()
//        panGesture.userInteractionEnabled = true
//        
//        let location = CGPoint(x: 500.0, y: 340.0)
//        if motion == .MotionShake {
//            self.addRectangle(location)
//        }
//    }
    
}
