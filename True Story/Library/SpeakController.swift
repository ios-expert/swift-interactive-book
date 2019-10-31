//
//  SpeakController.swift
//  True Story
//
//  Created by Maxim on 13.10.2019.
//  Copyright © 2019 big-lab.com. All rights reserved.
//

import UIKit
import AVFoundation

class SpeakController: NSObject {

    // Properties
    private static var sharedManager: SpeakController = {
        let speakController = SpeakController()
        return speakController
    }()
    
    // Initialization
    private override init() {
        
    }
    
    // Vars
    let synthesizer = AVSpeechSynthesizer()
    
    // Functions
    func speak(_ text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate
        if let lang = UserDefaults.standard.string(forKey: "AppLanguage") {
            switch lang {
            case "en":
                utterance.voice = AVSpeechSynthesisVoice.init(language: "en-US")
            default:
                utterance.voice = AVSpeechSynthesisVoice.init(language: "ru-RU")
            }
        }
        synthesizer.speak(utterance)
    }
    
    // Accessors
    class func shared() -> SpeakController {
        return sharedManager
    }
}

