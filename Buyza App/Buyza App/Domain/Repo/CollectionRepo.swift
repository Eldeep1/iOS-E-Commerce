//
//  CollectionRepo.swift
//  Buyza App
//
//  Created by Ahmed Tarek on 03/07/2026.
//

import Foundation

protocol CollectionRepoProtocol : ProductProtocol {
    func fetchCollectionProducts(collectionId: Int) async throws -> ProductsResponse
    func fetchProductsByVendor(vendor: String) async throws -> ProductsResponse
}
