//
//  Common_Category.swift
//  LaoEc_Test
//
//  Created by Chinh on 10/14/19.
//  Copyright © 2019 Chinh. All rights reserved.
//

import Foundation


//PRODUCT
struct ProductData: Codable {
    let data: [ProductDetail]
}

struct ProductDetail: Codable {
    let id: Int
    let name, detail, thumb: String
    let images: [String]?
    let price, priceType: Int
    let priceUsd: Int?
    let viewCount, installment, downpayment: Int
    let installmentNum: [String]?
    let approvedAt, createdAt, updatedAt: String
    let memberID: Int
    let categoryID: String
    let type, status, promote: Int
    let bumpTime: JSONNull?
    let member: Member?
    let category: Category
    let user: JSONNull?
    let favorite: Bool
    let priceCustom, installmentCustom, downpaymentCustom: Int
    let installmentNumCustom: [String]?

    enum CodingKeys: String, CodingKey {
        case id, name, detail, thumb, images, price
        case priceType = "price_type"
        case priceUsd = "price_usd"
        case viewCount = "view_count"
        case installment, downpayment
        case installmentNum = "installment_num"
        case approvedAt = "approved_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case memberID = "member_id"
        case categoryID = "category_id"
        case type, status, promote
        case bumpTime = "bump_time"
        case member, category, user, favorite
        case priceCustom = "price_custom"
        case installmentCustom = "installment_custom"
        case downpaymentCustom = "downpayment_custom"
        case installmentNumCustom = "installment_num_custom"
    }
}

// MARK: - Category
struct Category: Codable {
    let id: Int
    let name, thumb: String
    let type, parentID, productCount: Int

    enum CodingKeys: String, CodingKey {
        case id, name, thumb, type
        case parentID = "parent_id"
        case productCount = "product_count"
    }
}

// MARK: - Member
struct Member: Codable {
    let id: Int
    let name: Name
    let phone: String
    let email: Email
    let avatar: String?
    let provinceID, districtID: Int
    let facebook: JSONNull?
    let status: Int
    let rating: Double
    let rateCount, followCount, productCount: Int

    enum CodingKeys: String, CodingKey {
        case id, name, phone, email, avatar
        case provinceID = "province_id"
        case districtID = "district_id"
        case facebook, status, rating
        case rateCount = "rate_count"
        case followCount = "follow_count"
        case productCount = "product_count"
    }
}

enum Email: String, Codable {
    case dxluongGmailCOM = "dxluong@gmail.com"
    case empty = ""
    case luongdxHiworldCOMVn = "luongdx@hiworld.com.vn"
    case nhunhithuongGmailCOM = "nhunhithuong@gmail.com"
    case yenntGmailCOM = "yennt@gmail.com"
    case yenntHiworldCOMVn = "yennt@hiworld.com.vn"
}

enum Name: String, Codable {
    case khoun = "khoun"
    case luong = "Luong"
    case luongDX = "Luong DX"
    case msPhetmanyNui = "Ms. Phetmany (Nui)"
    case thingpay = "thingpay"
    case yen = "Yen"
    case yenNT = "yen nt"
}

//CATEGORY
struct CategoryData: Codable {
    let data: [CategoryDetail]
}
struct CategoryDetail: Codable {
    let id: Int
    let parentID: Int?
    let name : String
    let thumb: String
    let banners: JSONNull?
    let active, type, level: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case parentID = "parent_id"
        case name, thumb, banners, active, type, level
    }

}

//BANNER
struct BannerData: Codable {
    let data: [BannerDetail]
}
struct BannerDetail: Codable {
    let id, position: Int
    let categoryID: Int?
    let image: String
    let url: String
    let view, click, active: Int
    let note: JSONNull?
    let createdAt, updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id, position
        case categoryID
        case image, url, view, click, active, note
        case createdAt
        case updatedAt
    }
}

//AUTH LOGIN
struct AuthLogin: Encodable {
    var phone: String
    var password : String

    init(phone: String, password : String) {
        self.phone = phone
        self.password  = password
    }
}

struct GetLogin: Codable {
    let token: String
    let profile: Profile
}

// MARK: - Profile
struct Profile: Codable {
    let id: Int?
    let email, phone, name: String?
    let gender: Int?
    let dob: String?
    let group: Int?
    let avatar: String?
    let extraTokenCount: Int?
    let lastAction: String?
    let provinceID, districtID: Int?
    let village: String?
    let address: String?
    let facebook, info, fbid: String?
    let point: Int?
    let lang: String?
    let settingNoti, settingEmail, status: Int?
    let userID: Int?
    let upgradeStatus, upgradeType: Int?
    let upgradeDate, upgradeExpired: String?
    let note: String?
    let chatID: Int?
    let createdAt, updatedAt, location: String?
    let rating, rateCount, followCount, productCount: Int?

    enum CodingKeys: String, CodingKey {
        case id, email, phone, name, gender, dob, group, avatar
        case extraTokenCount = "extra_token_count"
        case lastAction = "last_action"
        case provinceID = "province_id"
        case districtID = "district_id"
        case village, address, facebook, info, fbid, point, lang
        case settingNoti = "setting_noti"
        case settingEmail = "setting_email"
        case status
        case userID = "user_id"
        case upgradeStatus = "upgrade_status"
        case upgradeType = "upgrade_type"
        case upgradeDate = "upgrade_date"
        case upgradeExpired = "upgrade_expired"
        case note
        case chatID = "chat_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case location, rating
        case rateCount = "rate_count"
        case followCount = "follow_count"
        case productCount = "product_count"
    }
}

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

