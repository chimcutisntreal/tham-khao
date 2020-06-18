//
//  CategoryCollectionViewCell.swift
//  LaoEc_Test
//
//  Created by Chinh on 10/15/19.
//  Copyright © 2019 Chinh. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell,UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    let cellId = "categoryItemCell"
    
    let categoryCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .clear
        return cv
    }()
    
    var languageCode = GetLanguageChanged()
    
    var categorylevel1: [CategoryDetail]!{
        didSet {
            categoryCollectionView.reloadData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell(){
        addSubview(categoryCollectionView)
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        categoryCollectionView.register(categoryCell.self, forCellWithReuseIdentifier: cellId)
        categoryCollectionView.setAnchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categorylevel1.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! categoryCell
        //Category image URL with level = 1
        let i = categorylevel1[indexPath.row]
        
        ImageService.getImage(withURL: URLToRequest.init(string: i.thumb).urlImage) { image in
            cell.imageView.image = image
        }
        
        //Category name with level = 1
        cell.title.text = convertedByLanguage(handler: i.name)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/4, height: collectionView.frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    private class categoryCell: UICollectionViewCell {
        
        let imageView: UIImageView = {
            let iv = UIImageView()
            iv.contentMode = .scaleAspectFill
            return iv
        }()
        
        let title: UILabel = {
            let lb = UILabel()
            lb.numberOfLines = 2
            lb.textAlignment = .center
            lb.font = UIFont.boldSystemFont(ofSize: 12)
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
            addSubview(title)

            imageView.setAnchor(top: topAnchor, left: leftAnchor, bottom: title.topAnchor, right: rightAnchor, paddingTop: 5, paddingLeft: 25, paddingBottom: 5, paddingRight: 25)
            title.setAnchor(top: imageView.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 5, paddingLeft: 2, paddingBottom: 0, paddingRight: 2,height: 35)
        }
    }
}
