//
//  AudioManager.swift
//  LearnSwift
//
//  Created by perfay on 2018/9/13.
//  Copyright © 2018年 luck. All rights reserved.
//

import UIKit
import AVFoundation
class AudioManager: NSObject {

    static let defaultManager = AudioManager()
    var player:AVAudioPlayer?
    
    override init() {
        super.init()
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayback, with: [AVAudioSessionCategoryOptions.mixWithOthers,AVAudioSessionCategoryOptions.duckOthers])
        try! session.setActive(true)
        NotificationCenter.default.addObserver(self, selector: #selector(handleInterreption(sender:)), name: .AVAudioSessionInterruption, object: AVAudioSession.sharedInstance())
    }
    @objc func handleInterreption(sender:NSNotification) -> Void {
        
    }
    func play(path:String?) -> Void {
        
        guard path != nil else {
            if self.player != nil{
                self.player!.stop();
            }
            return
        }
        self.player = try! AVAudioPlayer.init(contentsOf: URL.init(fileURLWithPath: path!))
        self.player!.prepareToPlay()
        self.player!.play()
    }
    
}
