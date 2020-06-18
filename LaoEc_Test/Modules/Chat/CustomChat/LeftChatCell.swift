//
//  LeftChatCell.swift
//  LaoEc_Test
//
//  Created by MacOne on 12/5/19.
//  Copyright © 2019 Chinh. All rights reserved.
//

import UIKit

import UIKit

class LeftChatCell: UITableViewCell {
    @IBOutlet weak var message: UITextView!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var time: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = UIColor(red: 237/255, green: 237/255, blue: 237/255, alpha: 1)
        message.setupMessage()
    }
}
