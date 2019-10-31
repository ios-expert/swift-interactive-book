//
//  GameLogicController.swift
//  True Story
//
//  Created by Maxim on 13.10.2019.
//  Copyright © 2019 big-lab.com. All rights reserved.
//

import UIKit
import AVFoundation

protocol GameLogicControllerProtocol: class {
    func setWaitingIndicatorVisible(_ visible: Bool)
    func addRowWithAnimation()
}

class GameLogicController: NSObject {

    var rawData: Data? = nil
    var messagesArray: NSMutableArray = NSMutableArray()
    var shownMessagesArray: NSMutableArray = NSMutableArray()
    var currentAnswerID: Int = 0
    var gameSpeed = 2.0
    var tickTimer = Timer()
    
    weak var presenter: GameLogicControllerProtocol!
    
    init(presenter: GameLogicControllerProtocol, rawData: Data?) {
        self.presenter = presenter
        self.rawData = rawData
    }

    func gameStart() {
        self.messagesArray = convertDataToMessages(rawData!)
    }
    
    func convertDataToMessages(_ data: Data) -> NSMutableArray {
        let dataString = String(data: data, encoding: .utf8)!
        let dataArray = NSMutableArray(array: dataString.components(separatedBy: .newlines))
        let messagesArray: NSMutableArray = NSMutableArray()
        var answerID: Int = 0
        for line in dataArray as! [String] {
            // Data parsing
            if line.count > 0 {
                var messageInLine: Bool = true
                // Command parsing
                if line.count >= 3 {
                    if String(Array(line)[0]) == "[" && String(Array(line)[2]) == "]" {
                        messageInLine = false
                        switch String(Array(line)[1]) {
                            case "F":
                                var imageName = String(line.dropFirst(3))
                                imageName = imageName.trimmingCharacters(in: .whitespaces)
                                let imageObject = ImageObject(image: UIImage(named: imageName))
                                imageObject.type = 1
                                imageObject.answerID = answerID
                                messagesArray.add(imageObject)
                            case "?":
                                var answersString = String(line.dropFirst(3))
                                answersString = answersString.replacingOccurrences(of: " | ", with: "|")
                                answersString = answersString.trimmingCharacters(in: .whitespaces)
                                let answersArray = NSArray(array: answersString.components(separatedBy: "|"))
                                let questionObject = QuestionObject(answersArray: answersArray)
                                questionObject.type = 2
                                messagesArray.add(questionObject)
                            default:
                                answerID = Int(String(Array(line)[1]))!
                        }
                    }
                }
                // Add text message
                if messageInLine {
                    let chatText = line.trimmingCharacters(in: .whitespaces)
                    let messageObject = MessageObject(answerID: answerID, text: chatText)
                    messageObject.type = 0
                    messagesArray.add(messageObject)
                }
            }
        }
        return messagesArray
    }
    
    // MARK: - TIMERS
    func startTimers() {
        tickTimer = Timer.scheduledTimer(timeInterval: self.gameSpeed, target: self, selector: #selector(timerStep), userInfo: nil, repeats: true)
    }

    func stopTimers() {
        tickTimer.invalidate()
    }
    
    @objc func timerStep() {
        if self.messagesArray.count > 0 {
            for chatObject in self.messagesArray as! [ChatObject] {
                // Object with message
                if chatObject.type == 0 {
                    let messageObject = chatObject as! MessageObject
                    if messageObject.answerID == 0 || messageObject.answerID == self.currentAnswerID {
                        AudioServicesPlaySystemSound(1003)
                        break
                    } else {
                        // Skip messages for unclicked buttons
                        self.messagesArray.removeObject(at: 0)
                    }
                }
                // Object with photo
                if chatObject.type == 1 {
                    let imageObject = chatObject as! ImageObject
                    if imageObject.answerID == 0 || imageObject.answerID == self.currentAnswerID {
                        AudioServicesPlaySystemSound(1108)
                        break
                    } else {
                        // Skip images for unclicked buttons
                        self.messagesArray.removeObject(at: 0)
                    }
                }
                // Object with question
                if chatObject.type == 2 {
                    // Pause timer in case of question in chat
                    self.presenter.setWaitingIndicatorVisible(false)
                    stopTimers()
                    break
                }
            }
            self.shownMessagesArray.add(self.messagesArray.object(at: 0))
            self.messagesArray.removeObject(at: 0)
            // Add new row to table with animation
            self.presenter.addRowWithAnimation()
        } else {
            self.presenter.setWaitingIndicatorVisible(false)
            stopTimers()
        }
    }
    
    func resumeGameWithAnswerID(answerID: Int, state: Int) {
        let questionObject = self.shownMessagesArray.object(at: state) as? QuestionObject
        questionObject?.answerID = answerID
        self.currentAnswerID = answerID
        self.startTimers()
        self.presenter.setWaitingIndicatorVisible(true)
    }
    
    func getChatObjectByIndexPath(_ indexPath: IndexPath) -> ChatObject {
        return self.shownMessagesArray.object(at: indexPath.row) as! ChatObject
    }
}
