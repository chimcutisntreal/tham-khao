//
//  ProductDetailController.swift
//  LaoEc_Test
//
//  Created by Chinh on 10/28/19.
//  Copyright © 2019 Chinh. All rights reserved.
//

import UIKit

class ProductDetailController: UIViewController,RowDelegate  {
    
    @IBOutlet weak var productDetailCV: UICollectionView!
    @IBOutlet weak var btnChat: UIButton!
    
    var register = Register.sharedInstance.productDetail
    var images = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productDetailCV.dataSource = self
        productDetailCV.delegate = self
        register.register(collectionView: productDetailCV)
        productDetailCV.backgroundColor = UIColor(red: 237/255, green: 237/255, blue: 237/255, alpha: 1)
        self.navigationController?.isNavigationBarHidden = false
        SocketValue.senderID = ProductDetailValue.sharedInstance.senderID
    }
    
    @IBAction func pressOnChat(_ sender: Any) {
        SocketIOManager.sharedInstance.establishConnection()
        checkSession()
    }
    
    func cellTapped(id: Int, clientID: Int) {
        let productStoryboard = UIStoryboard(name: "Product", bundle: nil)
        let navProductDetailVC = productStoryboard.instantiateViewController(withIdentifier: "productVC") as! ProductDetailController
        
        for i in ProductGlobal.product {
            if (i.id == id) {
                saveRecentView(id: i.id)
                ProductDetailValue.sharedInstance.productID = i.id
                ProductDetailValue.sharedInstance.senderID = i.member?.id ?? 0
                ProductDetailValue.sharedInstance.parentID = i.category.parentID 
                ProductDetailValue.sharedInstance.categoryID = i.category.id
                ProductDetailValue.sharedInstance.senderName = (i.member?.name).map { $0.rawValue }
                ProductDetailValue.sharedInstance.senderAvatar = i.member?.avatar
                
            }
        }
        navigationController?.pushViewController(navProductDetailVC, animated: true)
    }
    func checkSession() {
        if UserDefaults.standard.string(forKey: "token") == nil {
            navigateToLogin()
        } else {
            SocketIOManager.sharedInstance.emitConnectChannel(client_id: ProductDetailValue.sharedInstance.senderID)
            let storyboard = UIStoryboard(name: "Chat", bundle: nil)
            let chatVC = storyboard.instantiateViewController(withIdentifier: "chatvc") as! ChatViewController
            navigationController?.pushViewController(chatVC, animated: true)
        }
    }
    func navigateToLogin(){
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let loginVC = storyboard.instantiateViewController(withIdentifier: "loginVC") as! LoginViewController
        loginVC.isRootView = false
        navigationController?.pushViewController(loginVC, animated: true)
    }
}

extension ProductDetailController {
    func loadInfoCell(urlImage:[String]?,name:String,price:Int,cell:ProductInfoCollectionViewCell){
        var imageString = urlImage
        var imageURL = "https://laosec-dev.grooo.xyz/files/"
        if (imageString == []) {
            imageString = [""]
        }
        for i in imageString! {
            imageURL = imageURL + i
            guard let url = URL(string: imageURL) else { return }
            ImageService.getImage(withURL: url) { image in
                self.images.append(image!)
                if self.images.count > imageString!.count{
                    self.images.removeLast()
                }
                cell.configure(with: self.images)
            }
        }

        self.navigationItem.title = convertedByLanguage(handler: name)
        cell.lblName.text = convertedByLanguage(handler: name)
        cell.lblPrice.text = String(describing: price)
        cell.backgroundColor = .white
    }
}
extension ProductDetailController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0,1,2,3,4:
            return 1
        default:
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let productInfoCell = collectionView.dequeueReusableCell(withReuseIdentifier: register.productInfoId, for: indexPath) as! ProductInfoCollectionViewCell
            for i in ProductGlobal.product {
                if (i.id == ProductDetailValue.sharedInstance.productID) {
                    loadInfoCell(urlImage: i.images, name: i.name, price: i.price, cell: productInfoCell)
                }
            }
            return productInfoCell
            
        case 1:
            let ActionCell = collectionView.dequeueReusableCell(withReuseIdentifier: register.actionId, for: indexPath) as! ActionCollectionViewCell
            return ActionCell
            
        case 2:
            let productClassifyCell = collectionView.dequeueReusableCell(withReuseIdentifier: register.productClassifyId, for: indexPath) as! ProductClassifyInfoCell
            
            for i in CategoryGlobal.category {
                if i.id == ProductDetailValue.sharedInstance.parentID {
                    let convertedParent = convertJsonToDictionary(data: i.name)["\(ProductDetailValue.sharedInstance.languadeCode)"]
                    productClassifyCell.displayParentCategory = convertedParent as? String ?? "Updating"
                }
            }
            for i in ProductGlobal.product {
                if i.id == ProductDetailValue.sharedInstance.productID {
                    productClassifyCell.displayCategoryName = convertedByLanguage(handler: i.category.name)
                    productClassifyCell.condition = i.type
                }
            }
            
            return productClassifyCell
            
        case 3:
            let similarProductCell = collectionView.dequeueReusableCell(withReuseIdentifier: register.similarProductId, for: indexPath) as! SimilarProductCollectionViewCell
            similarProductCell.delegate = self
            var similar = [ProductDetail]()
            for i in ProductGlobal.product {
                if (i.category.id == ProductDetailValue.sharedInstance.categoryID) && (i.id != ProductDetailValue.sharedInstance.productID) {
                    similar.append(i)
                }
            }
            ProductGlobal.similarProduct = similar
            return similarProductCell
            
        default:
            let recentViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: register.recentViewId, for: indexPath) as! RecentViewCollectionViewCell
            recentViewCell.delegate = self
            guard let listOfRecent = UserDefaults.standard.array(forKey: "recentview") as? [Int] else {
                return recentViewCell
            }
            var recent = [ProductDetail]()
            for i in listOfRecent {
                for j in ProductGlobal.product {
                    if (i == j.id) && (i != ProductDetailValue.sharedInstance.productID) {
                        recent.append(j)
                    }
                }
            }
            ProductGlobal.recentProduct = recent
            return recentViewCell
        }
    }
}

extension ProductDetailController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            return CGSize(width: view.frame.width, height: productDetailCV.frame.height*3/4)
        case 1:
            return CGSize(width: view.frame.width, height: 60)
        case 2:
            return CGSize(width: view.frame.width, height: 200)
        case 3:
            return CGSize(width: view.frame.width, height: 280)
        default:
            return CGSize(width: view.frame.width, height: 280)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0)
    }
}
