//
//  Common_Category.swift
//  LaoEc_Test
//
//  Created by Chinh on 10/14/19.
//  Copyright © 2019 Chinh. All rights reserved.
//

import Foundation

//CATEGORY
struct CategoryData: Decodable {
    let data: [CategoryDetail]
}
struct CategoryDetail: Decodable {
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
struct BannerData: Decodable {
    let data: [BannerDetail]
}
struct BannerDetail: Decodable {
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

//PROVINCE
struct ProvinceData: Decodable {
    let data: [ProvinceDetail]
}
struct ProvinceDetail: Decodable {
    let id: Int
    let name, updatedAt, createdAt: String
}

//DISTRICT
struct DistrictData: Decodable {
    let provinceID: [String]
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
