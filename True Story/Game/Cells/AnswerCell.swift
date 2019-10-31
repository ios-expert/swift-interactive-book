//
//  AnswerCell.swift
//  True Story
//
//  Created by Maxim on 13.10.2019.
//  Copyright © 2019 big-lab.com. All rights reserved.
//

import UIKit

protocol AnswerCellDelegate {
    func cellAnswerButton1Tapped(cell: AnswerCell)
    func cellAnswerButton2Tapped(cell: AnswerCell)
    func cellAnswerButton3Tapped(cell: AnswerCell)
    func cellAnswerButton4Tapped(cell: AnswerCell)
}

class AnswerCell: UITableViewCell {

    @IBOutlet weak var answerLabel1: UILabel!
    @IBOutlet weak var answerLabel2: UILabel!
    @IBOutlet weak var answerLabel3: UILabel!
    @IBOutlet weak var answerLabel4: UILabel!
    
    @IBOutlet weak var answerView1: UIView!
    @IBOutlet weak var answerView2: UIView!
    @IBOutlet weak var answerView3: UIView!
    @IBOutlet weak var answerView4: UIView!
    
    @IBOutlet weak var answerButton1: UIButton!
    @IBOutlet weak var answerButton2: UIButton!
    @IBOutlet weak var answerButton3: UIButton!
    @IBOutlet weak var answerButton4: UIButton!
    
    var delegate: AnswerCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
   
    @IBAction func answerButton1Clicked(_ sender: Any) {
        delegate?.cellAnswerButton1Tapped(cell: self)
        disableButtons()
        answerView1.backgroundColor = .red
    }
    
    @IBAction func answerButton2Clicked(_ sender: Any) {
        delegate?.cellAnswerButton2Tapped(cell: self)
        disableButtons()
        answerView2.backgroundColor = .red
    }
    
    @IBAction func answerButton3Clicked(_ sender: Any) {
        delegate?.cellAnswerButton3Tapped(cell: self)
        disableButtons()
        answerView3.backgroundColor = .red
    }
    
    @IBAction func answerButton4Clicked(_ sender: Any) {
        delegate?.cellAnswerButton4Tapped(cell: self)
        disableButtons()
        answerView4.backgroundColor = .red
    }
    
    func setDefaultStyle(gameState: Int) {
        if self.tag >= gameState {
            let defaultColor = UIColor(red: 88/255, green: 86/255, blue: 214/255, alpha: 1.0)
            if answerView1 != nil {
                answerView1.backgroundColor = defaultColor
                answerButton1.isEnabled = true
            }
            if answerView2 != nil {
                answerView2.backgroundColor = defaultColor
                answerButton2.isEnabled = true
            }
            if answerView3 != nil {
                answerView3.backgroundColor = defaultColor
                answerButton3.isEnabled = true
            }
            if answerView4 != nil {
                answerView4.backgroundColor = defaultColor
                answerButton4.isEnabled = true
            }
        }
    }
    
    func disableButtons() {
        if answerView1 != nil {
            answerView1.backgroundColor = .gray
            answerButton1.isEnabled = false
        }
        if answerView2 != nil {
            answerView2.backgroundColor = .gray
            answerButton2.isEnabled = false
        }
        if answerView3 != nil {
            answerView3.backgroundColor = .gray
            answerButton3.isEnabled = false
        }
        if answerView4 != nil {
            answerView4.backgroundColor = .gray
            answerButton4.isEnabled = false
        }
        self.delegate = nil
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
