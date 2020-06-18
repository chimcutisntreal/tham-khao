//
//  CustomClassifyCell.swift
//  LaoEc_Test
//
//  Created by MacOne on 11/1/19.
//  Copyright © 2019 Chinh. All rights reserved.
//

import UIKit

class CustomClassifyCell: UICollectionViewCell {
    let lblTitle : UILabel = {
        let lb = UILabel()
        lb.font = UIFont.boldSystemFont(ofSize: 14)
        return lb
    }()
    
    let lblCategory : UILabel = {
        let lb = UILabel()
        return lb
    }()
    
    let lblCondition : UILabel = {
        let lb = UILabel()
        return lb
    }()
    
    let lblDescribe : UILabel = {
        let lb = UILabel()
        lb.numberOfLines = 0
        return lb
    }()
    
    let inputCondition : UILabel = {
        let lb = UILabel()
        lb.textColor = UIColor(red: 70/255, green: 148/255, blue: 92/255, alpha: 1)
        return lb
    }()
    
    var divideCategory : UILabel = {
        var lb = UILabel()
        lb.font.withSize(20)
        lb.adjustsFontSizeToFitWidth = true
        return lb
    }()
    
    let parentButton : UIButton = {
        var btn = UIButton()
        btn.setTitleColor(UIColor(red: 70/255, green: 148/255, blue: 92/255, alpha: 1), for: .normal)
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.titleLabel?.adjustsFontForContentSizeCategory = true
        return btn
    }()
    
    let categoryButton : UIButton = {
        var btn = UIButton()
        btn.setTitleColor(UIColor(red: 70/255, green: 148/255, blue: 92/255, alpha: 1), for: .normal)
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.titleLabel?.adjustsFontForContentSizeCategory = true
        btn.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        return btn
    }()
    func setup(){
        addSubview(lblTitle)
        addSubview(lblCategory)
        addSubview(lblCondition)
        addSubview(lblDescribe)
        addSubview(divideCategory)
        addSubview(parentButton)
        addSubview(categoryButton)
        addSubview(inputCondition)
        lblTitle.setAnchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 16, paddingBottom: 0, paddingRight: 0)
        lblCategory.setAnchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 16, paddingBottom: 0, paddingRight: 0)
        lblCondition.setAnchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 16, paddingBottom: 0, paddingRight: 0)
        lblDescribe.setAnchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 16, paddingBottom: 0, paddingRight: 0)
        divideCategory.setAnchor(top: topAnchor, left: parentButton.rightAnchor, bottom: bottomAnchor, right: categoryButton.leftAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        parentButton.setAnchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: divideCategory.leftAnchor, paddingTop: 0, paddingLeft: 5, paddingBottom: 0, paddingRight: 0)
        categoryButton.setAnchor(top: topAnchor, left: divideCategory.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        inputCondition.setAnchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 5, paddingBottom: 0, paddingRight: 0)
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
