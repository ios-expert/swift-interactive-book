//
//  ImageObject.swift
//  True Story
//
//  Created by Maxim on 13.10.2019.
//  Copyright © 2019 big-lab.com. All rights reserved.
//

import UIKit

class ImageObject: ChatObject {
    var answerID: Int!
    var image: UIImage? = nil
    
    init(image: UIImage?) {
        self.image = image
    }
}
