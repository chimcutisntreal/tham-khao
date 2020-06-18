//
//  Model.swift
//  LaoEc_Test
//
//  Created by MacOne on 11/13/19.
//  Copyright © 2019 Chinh. All rights reserved.
//

import Foundation
import UIKit
//REUSED
struct ProductGlobal {
    static var product = [ProductDetail]()
    static var optionProduct = [ProductDetail]()
    static var similarProduct = [ProductDetail]()
    static var recentProduct = [ProductDetail]()
}
struct CategoryGlobal {
    static var category = [CategoryDetail]()
    static var level1 = [CategoryDetail]()
}
struct BannerGlobal {
    static var banner = [BannerDetail]()
    static var position1 = [BannerDetail]()
}


struct ProductDetailValue {
    static var sharedInstance = ProductDetailValue()
    let languadeCode = GetLanguageChanged()
    var senderID = Int()
    var productID = Int()
    var parentID = Int()
    var categoryID = Int()
    var senderName :String?
    var senderAvatar : String?
}
struct LanguageData {
    static var sharedInstance = LanguageData()
    var optionHeader : [String:String] = ["la":"ຍີ່ປຸ່ນ","th":"ประเทศญี่ปุ่น","cn":"日本","us":"Japan","fr":"Le japon","vn":"Nhật Bản"]
    var productHeader : [String:String] = ["la":"ມື້ນີ້","th":"ในวันนี้","cn":"今天","us":"Today","fr":"Aujourd'hui","vn":"Hôm nay"]
    var productFooter : [String:String] = ["la":"More","th":"More","cn":"More","us":"More","fr":"More","vn":"Khác"]
    var today : [String:String] = ["la":"Today","th":"Today","cn":"Today","us":"Today","fr":"Today","vn":"Hôm nay"]
}

