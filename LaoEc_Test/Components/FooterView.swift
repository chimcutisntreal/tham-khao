//
//  FooterView.swift
//  LaoEc_Test
//
//  Created by Chinh on 10/25/19.
//  Copyright © 2019 Chinh. All rights reserved.
//

import UIKit

class FooterView: UICollectionReusableView {
    
    let footerButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 70/255, green: 148/255, blue: 92/255, alpha: 1)
        button.titleLabel?.textColor = .white
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(footerButton)
        footerButton.setAnchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 5, paddingBottom: 0, paddingRight: 5)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
