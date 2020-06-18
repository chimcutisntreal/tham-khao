//
//  SimilarProductCollectionViewCell.swift
//  LaoEc_Test
//
//  Created by Chinh on 10/28/19.
//  Copyright © 2019 Chinh. All rights reserved.
//

import UIKit

class SimilarProductCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var similarCollectionView: UICollectionView!
    weak var delegate: RowDelegate?
    @IBOutlet weak var lblSimilar: UILabel!
    @IBOutlet weak var btnSeeAll: UIButton!
    
    var categoryId = Int()
    let similarCellId = "similarCell"
    let productVc = ProductDetailController()
    let languadeCode = GetLanguageChanged()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    func setup(){
        similarCollectionView.register(CustomSimilarCell.self, forCellWithReuseIdentifier: similarCellId)
        lblSimilar.text = "SIMILAR PRODUCTS"
        lblSimilar.textColor = UIColor(red: 70/255, green: 148/255, blue: 92/255, alpha: 1)
        btnSeeAll.setTitle("See All", for: .normal)
    }
}

extension SimilarProductCollectionViewCell: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int{
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ProductGlobal.similarProduct.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let similarCell = collectionView.dequeueReusableCell(withReuseIdentifier: similarCellId, for: indexPath) as! CustomSimilarCell
        let i = ProductGlobal.similarProduct[indexPath.row]
        similarCell.name.text = convertedByLanguage(handler: i.name)
        similarCell.detail.text = convertedByLanguage(handler: i.detail)
        similarCell.price.text = String(describing: i.price)
        let url = URL(string: "https://laosec-dev.grooo.xyz/files/\(i.thumb)")!
        ImageService.getImage(withURL: url) { image in
            similarCell.imageView.image = image ?? UIImage(named: "error_loading")
        }
        return similarCell
    }
}

extension SimilarProductCollectionViewCell: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if delegate != nil {
            delegate?.cellTapped(id: ProductGlobal.similarProduct[indexPath.row].id, clientID: ProductGlobal.similarProduct[indexPath.row].member?.id ?? 0)
        }
    }
}

extension SimilarProductCollectionViewCell: UICollectionViewDelegateFlowLayout {
    
    //LAYOUT
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (similarCollectionView.frame.width-10)/3, height: similarCollectionView.frame.width*((similarCollectionView.frame.height)/similarCollectionView.frame.width))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

