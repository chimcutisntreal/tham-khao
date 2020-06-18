//
//  ActionCollectionViewCell.swift
//  LaoEc_Test
//
//  Created by Chinh on 10/28/19.
//  Copyright © 2019 Chinh. All rights reserved.
//

import UIKit

class ActionCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var btnReport: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        btnLike.setupRadius()
        btnShare.setupRadius()
        btnReport.setupRadius()
    }
    
}
