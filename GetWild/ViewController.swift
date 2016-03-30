//
//  ViewController.swift
//  GetWild
//
//  Created by fujiwara.kota on 2016/03/30.
//  Copyright © 2016年 Moneyforward. All rights reserved.
//

import UIKit

import UIKit
import MediaPlayer

class ViewController: UIViewController {
    
    @IBOutlet var blightnessLabel: UILabel!
    var blightness: Float = 0.0
    
    @IBOutlet var thresholdSlider: UISlider!
    @IBOutlet var thresholdLabel: UILabel!
    var threshold: Float = 0.0
    
    var audio: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        blightness = Float(UIScreen.mainScreen().brightness)
        blightnessLabel.text = String(format: "%.1f", blightness)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(brightnessDidChange(_:)), name: UIScreenBrightnessDidChangeNotification, object: nil)
        
        threshold = thresholdSlider.value*0.1
        thresholdLabel.text = String(format: "%.1f", threshold)
        
        thresholdSlider.addTarget(self, action: #selector(thresholdSliderValueDidChange(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
        checkThreshold()
    }
    
    internal func brightnessDidChange(notification: NSNotification) {
        blightness = Float(UIScreen.mainScreen().brightness)
        blightnessLabel.text = String(format: "%.1f", blightness)
        checkThreshold()
    }
    
    internal func thresholdSliderValueDidChange(sender :UISlider) {
        threshold = thresholdSlider.value*0.1
        thresholdLabel.text = String(format: "%.1f", threshold)
        checkThreshold()
    }
    
    internal func checkThreshold() {
        if (blightness <= threshold) {
            getWildAndTough()
        }
    }
    
    internal func getWildAndTough() {
        let songName = "Get Wild"
        let item: MPMediaItem = getMediaItemBySongFreeword(songName)
        
        if let url: NSURL = item.valueForProperty(MPMediaItemPropertyAssetURL) as? NSURL {
            do {
                audio = try AVAudioPlayer(contentsOfURL: url, fileTypeHint: nil)
                audio!.play()
            } catch {
                // nothing to do
                print(error)
            }
        } else {
            let audioPlayer = MPMusicPlayerController.systemMusicPlayer()
            let query: MPMediaQuery = mediaItemQuery(songName)
            audioPlayer.setQueueWithQuery(query)
            audioPlayer.play()
        }
    }
    
    private func mediaItemQuery(songFreeword: NSString) -> MPMediaQuery {
        let property: MPMediaPropertyPredicate = MPMediaPropertyPredicate(value: songFreeword, forProperty: MPMediaItemPropertyTitle)
        let query: MPMediaQuery = MPMediaQuery()
        query.addFilterPredicate(property)
        return query
    }
    
    internal func getMediaItemBySongFreeword(songFreeword : NSString) -> MPMediaItem {
        let query = mediaItemQuery(songFreeword)
        let items: [MPMediaItem] = query.items! as [MPMediaItem]
        return items[items.count - 1]
    }
}
