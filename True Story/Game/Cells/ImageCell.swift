//
//  ImageCell.swift
//  True Story
//
//  Created by Maxim on 13.10.2019.
//  Copyright © 2019 big-lab.com. All rights reserved.
//

import UIKit

class ImageCell: UITableViewCell {

    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
