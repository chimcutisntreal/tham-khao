//
//  DetailCollectionViewCell.swift
//  LaoEc_Test
//
//  Created by Chinh on 10/28/19.
//  Copyright © 2019 Chinh. All rights reserved.
//

import UIKit

class ProductClassifyInfoCell: UICollectionViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var displayDetail = String()
    var displayCategoryName = String()
    var displayParentCategory = String()
    var condition = Int()
    let classifyCellId = "classifyCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
        autoSizing()
    }
   
    func setup(){
        collectionView.register(CustomClassifyCell.self, forCellWithReuseIdentifier: classifyCellId)

    }
    func autoSizing(){
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.estimatedItemSize = CGSize(width: collectionView.frame.width-16, height: 50)
    }
}

extension ProductClassifyInfoCell: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
           return 3
       }
       func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           switch section {
           case 0,2:
               return 1
           case 1:
               return 4
           default:
               return 0
           }
       }
       
       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           let classifyCell = collectionView.dequeueReusableCell(withReuseIdentifier: classifyCellId, for: indexPath) as! CustomClassifyCell
           classifyCell.layer.borderColor = UIColor(red: 237/255, green: 237/255, blue: 237/255, alpha: 1).cgColor
           classifyCell.layer.borderWidth = 1.0
           switch indexPath.section {
           case 0:
               classifyCell.lblTitle.text = "Product Details"
               return classifyCell
           case 1:
               switch indexPath.row {
               case 0:
                   classifyCell.lblCategory.text = "Category"
               case 1:
                   classifyCell.divideCategory.text = "<"
                   classifyCell.parentButton.setTitle(displayParentCategory, for: .normal)
                   classifyCell.categoryButton.setTitle(displayCategoryName, for: .normal)
               case 2:
                   classifyCell.lblCondition.text = "Condition"
               default:
                   if (condition == 0) {
                       classifyCell.inputCondition.text = "New"
                   } else {
                       classifyCell.inputCondition.text = "Used"
                   }
                   return classifyCell
               }
               return classifyCell
           case 2:
               classifyCell.lblDescribe.text = displayDetail
               return classifyCell
           default:
               return classifyCell
           }
       }
}

extension ProductClassifyInfoCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Section:\(indexPath.section) | indexpath:\(indexPath.row)")
    }
}

extension ProductClassifyInfoCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           switch indexPath.section {
           case 0,2:
               return CGSize(width: collectionView.frame.width, height: 50)
           case 1:
               switch indexPath.row {
               case 0,2:
                   return CGSize(width: collectionView.frame.width/3, height: 50)
               case 1,3:
                   return CGSize(width: collectionView.frame.width*2/3, height: 50)
               default:
                   return CGSize(width: collectionView.frame.width, height: 50)
               }
           default:
               return CGSize.zero
           }
       }
       
       //Layout
       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
           return 0
       }
       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
           return 0
       }
       override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
           let autoLayoutAttributes = super.preferredLayoutAttributesFitting(layoutAttributes)

           // Specify you want _full width_
           let targetSize = CGSize(width: layoutAttributes.frame.width, height: 0)

           // Calculate the size (height) using Auto Layout
           let autoLayoutSize = contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: UILayoutPriority.required, verticalFittingPriority: UILayoutPriority.defaultLow)
           let autoLayoutFrame = CGRect(origin: autoLayoutAttributes.frame.origin, size: autoLayoutSize)

           // Assign the new size to the layout attributes
           autoLayoutAttributes.frame = autoLayoutFrame
           return autoLayoutAttributes
       }
}


