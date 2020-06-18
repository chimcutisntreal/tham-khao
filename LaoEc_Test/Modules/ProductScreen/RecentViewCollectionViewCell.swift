//
//  RecentViewCollectionViewCell.swift
//  LaoEc_Test
//
//  Created by Chinh on 10/28/19.
//  Copyright © 2019 Chinh. All rights reserved.
//

import UIKit

class RecentViewCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var lblRecent: UILabel!
    @IBOutlet weak var recentCollectionView: UICollectionView!
    weak var delegate: RowDelegate?
    let recentCellId = "recentCell"
    
    let languadeCode = GetLanguageChanged()
    var listOfRecent : [Int] = UserDefaults.standard.array(forKey: "recentview") as! [Int] {
        didSet {
            DispatchQueue.main.async {
                self.recentCollectionView.reloadData()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    func setup(){
        recentCollectionView.register(CustomRecentCell.self, forCellWithReuseIdentifier: recentCellId)
        lblRecent.text = "RECENT VIEW"
        lblRecent.textColor = UIColor(red: 70/255, green: 148/255, blue: 92/255, alpha: 1)
    }
}

extension RecentViewCollectionViewCell: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int{
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ProductGlobal.recentProduct.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let recentCell = collectionView.dequeueReusableCell(withReuseIdentifier: recentCellId, for: indexPath) as! CustomRecentCell
        let i = ProductGlobal.recentProduct[indexPath.row]
        recentCell.name.text = convertedByLanguage(handler: i.name)
        recentCell.detail.text = convertedByLanguage(handler: i.detail)
        recentCell.price.text = String(describing: i.price)
        
        let url = URL(string: "https://laosec-dev.grooo.xyz/files/\(i.thumb)")!
        ImageService.getImage(withURL: url) { image in
            recentCell.imageView.image = image ?? UIImage(named: "error_loading")
        }
        return recentCell
    }
}

extension RecentViewCollectionViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if delegate != nil {
            delegate?.cellTapped(id: ProductGlobal.recentProduct[indexPath.row].id, clientID: ProductGlobal.recentProduct[indexPath.row].member?.id ?? 0)
        }
    }
}

extension RecentViewCollectionViewCell: UICollectionViewDelegateFlowLayout {
    
    //LAYOUT
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (recentCollectionView.frame.width-10)/3, height: recentCollectionView.frame.width*((recentCollectionView.frame.height)/recentCollectionView.frame.width))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
