//
//  Category.swift
//  Buyza App
//
//  Created by Ahmed Tarek on 29/06/2026.
//

import Foundation

struct CategoryResponse : Codable {
    var custom_collections : [Collection]?
}

struct Collection : Codable {
    var id : Int?
    var title : String?
    var image : NetworkImage?
}

struct NetworkImage : Codable {
    var src : String?
}
