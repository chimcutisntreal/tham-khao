//
//  CustomSimilarCell.swift
//  LaoEc_Test
//
//  Created by MacOne on 11/5/19.
//  Copyright © 2019 Chinh. All rights reserved.
//

import UIKit

class CustomSimilarCell: UICollectionViewCell {
    
    
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleToFill
        return iv
    }()
    let name: UILabel = {
        let lb = UILabel()
        lb.font.withSize(10)
        return lb
    }()
    let detail: UILabel = {
        let lb = UILabel()
        lb.font.withSize(8)
        lb.textColor = .lightGray
        return lb
    }()
    let price: UILabel = {
        let lb = UILabel()
        lb.font.withSize(10)
        lb.textColor = .orange
        
        return lb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(){
        addSubview(imageView)
        addSubview(name)
        addSubview(detail)
        addSubview(price)
        
        imageView.setAnchor(top: topAnchor, left: leftAnchor, bottom: name.topAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 5, paddingRight: 0,width: contentView.frame.width,height: contentView.frame.width)
        name.setAnchor(top: imageView.bottomAnchor, left: leftAnchor, bottom: detail.topAnchor, right: rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        detail.setAnchor(top: name.bottomAnchor, left: leftAnchor, bottom: price.topAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        price.setAnchor(top: detail.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 5, paddingRight: 0)
    }
}

protocol RowDelegate:class {
    func cellTapped(id: Int, clientID: Int)

}
