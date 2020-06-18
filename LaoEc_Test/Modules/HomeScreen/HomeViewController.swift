//
//  HomeViewController.swift
//  LaoEc_Test
//
//  Created by Chinh on 10/17/19.
//  Copyright © 2019 Chinh. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    var categoryImageString = [String]()
    var limit = 10
    var loadMore = false
    var languadeCode = GetLanguageChanged()
    var footerView: RefreshFooterView?
    var isLoading:Bool = false
    var listOfProduct = [ProductDetail]()
    var register = Register.sharedInstance.home
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var homeCollectionView: UICollectionView!
    @IBOutlet var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutView()
        loading.startAnimating()
        waitForRequest()
        getRecentView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        languadeCode = GetLanguageChanged()
    }
    
    func waitForRequest(){
        let group = DispatchGroup()
        requestData(group: group)
        group.notify(queue: .main) { [weak self] in
            self?.homeCollectionView.reloadData()
            self?.loading.removeFromSuperview()
        }
    }
    
    //PULL TO REQUEST
    @objc lazy var refresher : UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .orange
        refreshControl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        return refreshControl
    }()
    
    @objc func reloadData() {
        let group = DispatchGroup()
        self.requestData(group: group)
        group.notify(queue: .main) { [weak self] in
            self?.homeCollectionView.reloadData()
            self?.refresher.endRefreshing()
        }
    }
    
}
extension HomeViewController { //LAYOUT
    func layoutView(){
        setupNavBack()
        view.backgroundColor = UIColor(red: 237/255, green: 237/255, blue: 237/255, alpha: 1)
        searchBar.barTintColor = UIColor(red: 70/255, green: 148/255, blue: 92/255, alpha: 1)
        if #available(iOS 13, *) {
            searchBar.searchTextField.backgroundColor = .white
        }
        
        setConstraints()
        
        homeCollectionView?.refreshControl = refresher
        register.register(collectionView: homeCollectionView)
        homeCollectionView.delegate = self
        homeCollectionView.dataSource = self
    }
    
    func setConstraints(){
        loading.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        loading.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        loading.translatesAutoresizingMaskIntoConstraints = false
    }
}
extension HomeViewController { //Request Data
    
    func requestData(group: DispatchGroup){
        group.enter()
        //Get list category
        getData(url: URLToRequest.urlCategory) {(category:CategoryData) in
            var level1 = [CategoryDetail]()
            for i in category.data {
                if i.level == 1 {
                    level1.append(i)
                }
            }
            CategoryGlobal.level1 = level1
            CategoryGlobal.category = category.data
        }
        
        //get list banner
        getData(url: URLToRequest.urlBanner) {(banner:BannerData) in
            var position1 = [BannerDetail]()
            for i in banner.data {
                if i.position == 1 {
                    position1.append(i)
                }
            }
            BannerGlobal.position1 = position1
            BannerGlobal.banner = banner.data
        }
        
        getData(url: URLToRequest.urlOptionProduct) {(product:ProductData) in
            ProductGlobal.optionProduct = product.data
            
        }
        
        getData(url: URLToRequest.init(string: "10").urlProductLimit) {(product:ProductData) in
            self.listOfProduct = product.data
        }
        
        getData(url: URLToRequest.urlProduct) {(product:ProductData) in
            ProductGlobal.product = product.data
            group.leave()
        }
    }
}

extension HomeViewController { //Load more
    //compute the scroll value and play witht the threshold to get desired effect
    func computeScroll() {
        
        let offsetY = homeCollectionView.contentOffset.y
        let contentHeight = homeCollectionView.contentSize.height
        let threshold   = 100.0
        let diffHeight = contentHeight - offsetY;
        let frameHeight = homeCollectionView.bounds.size.height;
        var triggerThreshold  = Float((diffHeight - frameHeight))/Float(threshold);
        triggerThreshold   =  min(triggerThreshold, 0.0)
        let pullRatio  = min(abs(triggerThreshold),1.0);
        self.footerView?.setTransform(inTransform: CGAffineTransform.identity, scaleFactor: CGFloat(pullRatio))
        if pullRatio > 0.0 {
            self.footerView?.animateFinal()
        }
    }
    //compute the offset and call the load method
    func computeOffset() {
        let offsetY = homeCollectionView.contentOffset.y;
        let contentHeight = homeCollectionView.contentSize.height;
        let diffHeight = round(contentHeight - offsetY);
        let frameHeight = homeCollectionView.bounds.height;
        let pullHeight  = abs(diffHeight - frameHeight);
        if pullHeight == 0
        {
            if (self.footerView?.isAnimatingFinal)! {
                beginLoadMore()
            }
        }
    }
    
    func beginLoadMore() {
        self.isLoading = true
        self.footerView?.startAnimate()
        
        //Load more item
        self.limit += 20
        let urlLoadmore = URLToRequest.init(string: String(describing: limit)).urlProductLimit
        getData(url: urlLoadmore) {(product:ProductData) in
            self.listOfProduct = product.data
            self.isLoading = false
        }
        self.homeCollectionView.reloadSections(IndexSet(integer: homeCollectionView.numberOfSections-1))
    }

}

extension HomeViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0,1:
            return 1
        case 2:
            return ProductGlobal.optionProduct.count
        default:
            return listOfProduct.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.section {
        case 0:
            let categoryCell = collectionView.dequeueReusableCell(withReuseIdentifier: register.categoryCellId, for: indexPath) as! CategoryCollectionViewCell
            categoryCell.categorylevel1 = CategoryGlobal.level1
            return categoryCell
        case 1:
            let bannerCell = collectionView.dequeueReusableCell(withReuseIdentifier: register.bannerCellId, for: indexPath) as! BannerCollectionViewCell
            bannerCell.banner = BannerGlobal.position1
            return bannerCell
        case 2:
            let optionProductCell = collectionView.dequeueReusableCell(withReuseIdentifier: register.optionProductCellId, for: indexPath) as! OptionProductCollectionViewCell
            let i = ProductGlobal.optionProduct[indexPath.row]
            ImageService.getImage(withURL: URLToRequest.init(string: i.thumb).urlImage) { image in
                optionProductCell.imageView.image = image ?? UIImage(named: "error_loading")
            }
            optionProductCell.name.text = convertedByLanguage(handler: i.name)
            optionProductCell.detail.text = convertedByLanguage(handler: i.detail)
            optionProductCell.price.text = String(describing: i.price)
            return optionProductCell
        default:
            
            let productCell = collectionView.dequeueReusableCell(withReuseIdentifier: register.productCellId, for: indexPath) as! ProductCollectionViewCell
            let i = listOfProduct[indexPath.row]
   
            ImageService.getImage(withURL: URLToRequest.init(string: i.thumb).urlImage) { image in
                productCell.imageView.image = image ?? UIImage(named: "error_loading")
            }
            productCell.name.text = convertedByLanguage(handler: i.name)
            productCell.detail.text = convertedByLanguage(handler: i.detail)
            productCell.price.text = String(describing: i.price)
            return productCell
        }
    }
    
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let productStoryboard = UIStoryboard(name: "Product", bundle: nil)
        
        switch indexPath.section {
        case 2,3:
            let productDetailVC = productStoryboard.instantiateViewController(withIdentifier: "productVC") as! ProductDetailController
            
            let i = indexPath.section == 2 ? ProductGlobal.optionProduct[indexPath.row] : listOfProduct[indexPath.row]
            saveRecentView(id: i.id)
            ProductDetailValue.sharedInstance.productID = i.id
//            ProductDetailValue.sharedInstance.senderID = 7714
            ProductDetailValue.sharedInstance.senderID = i.member?.id ?? 0
            ProductDetailValue.sharedInstance.parentID = i.category.parentID 
            ProductDetailValue.sharedInstance.categoryID = i.category.id
            ProductDetailValue.sharedInstance.senderName = (i.member?.name).map { $0.rawValue }
            ProductDetailValue.sharedInstance.senderAvatar = i.member?.avatar
            
            self.navigationController?.pushViewController(productDetailVC, animated: true)
        default:
            return
        }
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            return CGSize(width: homeCollectionView.frame.width, height: homeCollectionView.frame.height/7)
        case 1:
            return CGSize(width: homeCollectionView.frame.width, height: homeCollectionView.frame.height/7)
        case 2:
            return CGSize(width: (homeCollectionView.frame.width-30)/2, height: homeCollectionView.frame.height/2)
        default:
            return CGSize(width: (homeCollectionView.frame.width-30)/2, height: homeCollectionView.frame.height/2)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch section {
        case 0,1:
            return UIEdgeInsets(top: 3, left: 0, bottom: 3, right: 0)
        default:
            return UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        }
    }
    //HEADER LAYOUT
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
                switch section {
        case 0:
            return CGSize(width: 0, height: 0)
        case 1:
            return CGSize(width: 0, height: 0)
        default:
            return CGSize(width: homeCollectionView.frame.width, height: 50)
        }
    }
    
    //FOOTER LAYOUT
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        switch section {
        case 0:
            return CGSize(width: 0, height: 0)
        case 1:
            return CGSize(width: 0, height: 0)
        case 2:
            if isLoading {
                return CGSize.zero
            }
            return CGSize(width: homeCollectionView.frame.width, height: 50)
        default:
            return CGSize(width: homeCollectionView.frame.width, height: 50)
        }
    }

    
    //HEADER-FOOTER IMPLEMENT
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if (kind == UICollectionView.elementKindSectionFooter) && (indexPath.section == 2) {
            let footer1 = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: register.footerId, for: indexPath) as! FooterView
            footer1.footerButton.setTitle(LanguageData.sharedInstance.productFooter["\(languadeCode)"], for: .normal)
            return footer1
        }
        if (kind == UICollectionView.elementKindSectionFooter) && (indexPath.section == 3) {
            let footer2 = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: register.refreshFooterId, for: indexPath) as! RefreshFooterView
            self.footerView = footer2
            self.footerView?.backgroundColor = UIColor(red: 237/255, green: 237/255, blue: 237/255, alpha: 1)
            return footer2
        }
        switch (indexPath.section) {
        case 2:
            let header1 = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: register.headerOptionId, for: indexPath) as! HeaderView
            header1.lblHeader.text = LanguageData.sharedInstance.optionHeader["\(languadeCode)"]
            return header1
        default:
            let header2 = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: register.headerToday, for: indexPath) as! HeaderView
            header2.lblHeader.text = LanguageData.sharedInstance.productHeader["\(languadeCode)"]
            return header2
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if (elementKind == UICollectionView.elementKindSectionFooter) {
            self.footerView?.prepareInitialAnimation()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        if (elementKind == UICollectionView.elementKindSectionFooter) {
            self.footerView?.stopAnimate()
        }
    }
}

extension HomeViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        computeScroll()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        computeOffset()
    }

}


