//
//  GameViewController.swift
//  Vizzy
//
//  Created by David Park on 6/10/16.
//  Copyright (c) 2016 David Park. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation
import MediaPlayer

class GameViewController: UIViewController {
    let audioPlayer = AVAudioPlayer()

    override func viewDidLoad() {
        super.viewDidLoad()

        if let scene = GameScene(fileNamed:"GameScene") {
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            

            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            
            skView.presentScene(scene)
        }
    }
    
    @IBAction func pickSongButton(sender: AnyObject) {
        
        let mediaPicker = MPMediaPickerController(mediaTypes: .Music)
        //mediaPicker.delegate = self
        mediaPicker.allowsPickingMultipleItems = false
        mediaPicker.showsCloudItems = true
        presentViewController(mediaPicker, animated: true, completion: {})
    
    }
    
//    func mediaPicker(mediaPicker:MPMediaPickerController, mediaItemCollection: MPMediaItemCollection) {
//        
//        myPlayer.setQueueWithItemCollection(mediaCollection)
//        var itemsFromGenericQuery: [AnyObject] = mediaItemCollection.items
//        self.pickedMediaItemSong = itemsFromGenericQuery[0]
//        curePickerController.dismissViewControllerAnimated(false, completion: nil)
//        
//    }
    
    
    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
}
