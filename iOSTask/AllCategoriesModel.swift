//
//  AllCategoriesModel.swift
//  iOSTask
//
//  Created by eslam mohamed on 3/25/25.
//

import Foundation

// MARK: - DataClass
struct AllCategoriesModel: Codable {
    let categories: [Category]?
    let iosVersion, iosLatestVersion, googleVersion, huaweiVersion: String?

    enum CodingKeys: String, CodingKey {
        case categories
        case iosVersion = "ios_version"
        case iosLatestVersion = "ios_latest_version"
        case googleVersion = "google_version"
        case huaweiVersion = "huawei_version"
    }
}

// MARK: - Category
struct Category: Codable {
    
    
    let id: Int?
    let name, slug: String?
    let parentID: Int?
    let propertiesCount: Int?
    let image: Image?
    let isOther: Bool?
    
    internal init(id: Int? = nil, name: String? = nil, slug: String? = nil, parentID: Int? = nil, propertiesCount: Int? = nil, image: Image? = nil, isOther: Bool? = nil) {
        self.id = id
        self.name = name
        self.slug = slug
        self.parentID = parentID
        self.propertiesCount = propertiesCount
        self.image = image
        self.isOther = isOther
    }

    enum CodingKeys: String, CodingKey {
        case id, name, slug
        case parentID = "parent_id"
        case propertiesCount = "properties_count"
        case image
        case isOther = "is_other"
    }
}

// MARK: - Image
struct Image: Codable {
    let medium, thumbnail: String?
    let id: Int?
   

    enum CodingKeys: String, CodingKey {
        case medium, thumbnail, id
    }
}

struct SubCategoryModel: Codable {
    
    
    let id: Int?
    let name, type: String?
    let parentID: Int?
    let options: [Option]?
    
    internal init(id: Int? = nil, name: String? = nil, type: String? = nil, parentID: Int? = nil, options: [Option]? = nil) {
        self.id = id
        self.name = name
        self.type = type
        self.parentID = parentID
        self.options = options
    }

    enum CodingKeys: String, CodingKey {
        case id, name, type
        case parentID = "parent_id"
        case options
    }
}

// MARK: - Option
struct Option: Codable {
    let id: Int?
    let name: String?
    let hasChild: Bool?

    enum CodingKeys: String, CodingKey {
        case id, name
        case hasChild = "has_child"
    }
}

