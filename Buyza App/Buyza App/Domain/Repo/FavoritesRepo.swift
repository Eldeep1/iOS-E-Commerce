//
//  FavoritesRepo.swift
//  Buyza App
//
//  Created by Ahmed Tarek on 03/07/2026.
//

import Foundation

protocol FavoritesRepoProtocol : ProductProtocol {
    func getFavoriteProducts() throws -> [Product]
}
