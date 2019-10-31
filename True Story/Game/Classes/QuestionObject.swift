//
//  QuestionObject.swift
//  True Story
//
//  Created by Maxim on 13.10.2019.
//  Copyright © 2019 big-lab.com. All rights reserved.
//

import UIKit

class QuestionObject: ChatObject {
    var answerID: Int!
    var answersArray: NSArray? = nil
    
    init(answersArray: NSArray?) {
        self.answersArray = answersArray        
    }
}
