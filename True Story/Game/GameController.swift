//
//  GameController.swift
//  True Story
//
//  Created by Maxim on 13/10/2019.
//  Copyright © 2019 big-lab.com. All rights reserved.
//

import UIKit

class GameController: UIViewController, UITableViewDelegate, UITableViewDataSource, AnswerCellDelegate, GameLogicControllerProtocol {
    
    @IBOutlet weak var gameTableView: UITableView!
    
    var rawData: Data? = nil
    var gameLogic: GameLogicController? = nil
    var isLoading: Bool = true
    let sideImageOffset: CGFloat = 48
    
    // MARK: - VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "big-lab.com".localized()
        
        // All game logic in GameLogicController
        self.gameLogic = GameLogicController(presenter: self, rawData: self.rawData)
        self.gameLogic!.gameStart()
        
        gameTableView.dataSource = self
        gameTableView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        gameLogic!.startTimers()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        gameLogic!.stopTimers()
    }
    
    // MARK: - BUTTONS
    func cellAnswerButton1Tapped(cell: AnswerCell) {
        gameLogic!.resumeGameWithAnswerID(answerID: 1, state: cell.tag)
    }
    
    func cellAnswerButton2Tapped(cell: AnswerCell) {
        gameLogic!.resumeGameWithAnswerID(answerID: 2, state: cell.tag)
    }
    
    func cellAnswerButton3Tapped(cell: AnswerCell) {
        gameLogic!.resumeGameWithAnswerID(answerID: 3, state: cell.tag)
    }
    
    func cellAnswerButton4Tapped(cell: AnswerCell) {
        gameLogic!.resumeGameWithAnswerID(answerID: 4, state: cell.tag)
    }
    
    // MARK: - CALLBACK FUNCTIONS FROM GAMELOGIC CONTROLLER
    func setWaitingIndicatorVisible(_ visible: Bool) {
        self.isLoading = visible
        let numberOfRows = self.gameTableView.numberOfRows(inSection: 0) - 1
        let lastIndexPath = IndexPath(row: numberOfRows, section: 0)
        self.gameTableView.reloadRows(at: [lastIndexPath], with: UITableView.RowAnimation.none)
    }

    func addRowWithAnimation() {
        let indexPath = IndexPath(row: self.gameLogic!.shownMessagesArray.count - 1, section: 0)
        self.gameTableView.insertRows(at: [indexPath], with: UITableView.RowAnimation.fade)
        if !self.gameTableView.isTracking  {
            let numberOfRows = self.gameTableView.numberOfRows(inSection: 0) - 1
            let lastIndexPath = IndexPath(row: numberOfRows, section: 0)
            self.gameTableView.scrollToRow(at: lastIndexPath, at: .bottom, animated: true)
        }
    }
    
    // MARK: - TABLE VIEW
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gameLogic!.shownMessagesArray.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let numberOfRows = self.gameTableView.numberOfRows(inSection: 0) - 1
        
        // Display rows in table
        if indexPath.row < numberOfRows {
            let chatObject = gameLogic!.getChatObjectByIndexPath(indexPath)
            switch chatObject.type {
                case 0:
                    let cellIdentifier = "ChatCell"
                    let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ChatCell
                    let messageObject = chatObject as! MessageObject
                    cell.messageText.text = messageObject.text
                    return cell
                case 1:
                    let cellIdentifier = "ImageCell"
                    let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ImageCell
                    let imageObject = chatObject as! ImageObject
                    cell.mainImage.image = imageObject.image
                    let ratio = (UIScreen.main.bounds.size.width - sideImageOffset) / imageObject.image!.size.width
                    cell.imageHeight.constant = imageObject.image!.size.height * ratio
                    return cell
                default:
                    let questionObject = chatObject as! QuestionObject
                    var cellIdentifier = "SmallAnswerCell"
                    if questionObject.answersArray?.count == 4 {
                        cellIdentifier = "BigAnswerCell"
                    }
                    let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! AnswerCell
                    let textAnswer1 = questionObject.answersArray?.object(at: 0) as! String
                    cell.answerLabel1.text = textAnswer1
                    let textAnswer2 = questionObject.answersArray?.object(at: 1) as! String
                    cell.answerLabel2.text = textAnswer2
                    if questionObject.answersArray?.count == 4 {
                        let textAnswer3 = questionObject.answersArray?.object(at: 2) as! String
                        cell.answerLabel3.text = textAnswer3
                        let textAnswer4 = questionObject.answersArray?.object(at: 3) as! String
                        cell.answerLabel4.text = textAnswer4
                    }
                    cell.delegate = self
                    cell.tag = indexPath.row
                    cell.setDefaultStyle(gameState: gameLogic!.shownMessagesArray.count - 1)
                    return cell
            }
        } else {
            // Last row in table
            let cell = tableView.dequeueReusableCell(withIdentifier: "LoadingCell", for: indexPath) as! LoadingCell
            if self.isLoading {
                cell.loadingIndicator.startAnimating()
            } else {
                cell.loadingIndicator.stopAnimating()
            }
            return cell
        }
    }
}




