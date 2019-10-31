//
//  MessageObject.swift
//  True Story
//
//  Created by Maxim on 13.10.2019.
//  Copyright © 2019 big-lab.com. All rights reserved.
//

import UIKit

class MessageObject: ChatObject {
    var answerID: Int!
    var text: String?
    
    init(answerID: Int, text: String?) {
        self.answerID = answerID
        self.text = text
    }
}
