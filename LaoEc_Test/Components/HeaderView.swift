//
//  SectionDividedSupplymentaryView.swift
//  LaoEc_Test
//
//  Created by Chinh on 10/25/19.
//  Copyright © 2019 Chinh. All rights reserved.
//

import UIKit

class HeaderView: UICollectionReusableView {
    
    let lblHeader : UILabel = {
        let header = UILabel()
        header.textColor = UIColor(red: 70/255, green: 148/255, blue: 92/255, alpha: 1)
        header.font = UIFont.boldSystemFont(ofSize: 20)
        return header
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(lblHeader)
        backgroundColor = UIColor(red: 237/255, green: 237/255, blue: 237/255, alpha: 1)
        
        lblHeader.setAnchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 5, paddingLeft: 10, paddingBottom: 5, paddingRight: 0)

    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
