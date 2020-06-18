//
//  Register.swift
//  LaoEc_Test
//
//  Created by MacOne on 12/13/19.
//  Copyright © 2019 Chinh. All rights reserved.
//

import Foundation
import UIKit

struct Register {
    static var sharedInstance = Register()
    var home = HomeRegister()
    var productDetail = ProductDetailRegister()
    
}

struct HomeRegister {
    var categoryCellId = "categoryCell"
    var bannerCellId = "bannerCell"
    var optionProductCellId = "optionCell"
    var productCellId = "productCell"
    var footerId = "footer"
    var refreshFooterId = "refreshFooter"
    var headerOptionId = "headerOption"
    var headerToday = "headerToday"
    
    func register(collectionView: UICollectionView){
        collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: categoryCellId)
        collectionView.register(BannerCollectionViewCell.self, forCellWithReuseIdentifier: bannerCellId)
        collectionView.register(OptionProductCollectionViewCell.self, forCellWithReuseIdentifier: optionProductCellId)
        collectionView.register(ProductCollectionViewCell.self, forCellWithReuseIdentifier: productCellId)
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerOptionId)
        collectionView.register(UINib(nibName: "CustomBanner", bundle: nil), forCellWithReuseIdentifier: bannerCellId)
        collectionView.register(FooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerId)
        collectionView.register(UINib(nibName: "CustomRefreshFooterView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: refreshFooterId)
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerToday)
    }
}

struct ProductDetailRegister {
    var productInfoId = "productInfoCell"
    var actionId = "actionCell"
    var productClassifyId = "productClassifyCell"
    var similarProductId = "similarProductCell"
    var recentViewId = "recentViewCell"
    
    func register(collectionView: UICollectionView){
        collectionView.register(ProductInfoCollectionViewCell.self, forCellWithReuseIdentifier: productInfoId)
        collectionView.register(ActionCollectionViewCell.self, forCellWithReuseIdentifier: actionId)
        collectionView.register(ProductClassifyInfoCell.self, forCellWithReuseIdentifier: productClassifyId)
        collectionView.register(SimilarProductCollectionViewCell.self, forCellWithReuseIdentifier: similarProductId)
        collectionView.register(RecentViewCollectionViewCell.self, forCellWithReuseIdentifier: recentViewId)
        
        collectionView.register(UINib(nibName: "CustomProductInfo", bundle: nil), forCellWithReuseIdentifier: productInfoId)
        collectionView.register(UINib(nibName: "CustomAction", bundle: nil), forCellWithReuseIdentifier: actionId)
        collectionView.register(UINib(nibName: "CustomProductClassify", bundle: nil), forCellWithReuseIdentifier: productClassifyId)
        collectionView.register(UINib(nibName: "CustomSimilar", bundle: nil), forCellWithReuseIdentifier: similarProductId)
        collectionView.register(UINib(nibName: "CustomRecent", bundle: nil), forCellWithReuseIdentifier: recentViewId)
    }
}
