//
//  HomeLocalDataSource.swift
//  Buyza App
//
//  Created by Ahmed Tarek on 03/07/2026.
//

import Foundation
import CoreData

protocol ProductLocalDataSourceProtocol {
    func saveProduct(product: Product) throws
    func removeProduct(productId: Int64) throws
    func getFavoriteProducts() throws -> [Product]
    func isFavorite(productId: Int64) throws -> Bool
}

class ProductLocalDataSource: ProductLocalDataSourceProtocol {
    
    private let coreDataManager: CoreDataManager
    
    init(coreDataManager: CoreDataManager = .shared) {
        self.coreDataManager = coreDataManager
    }
    
    func saveProduct(product: Product) throws {
        let context = coreDataManager.viewContext
        
        if try isFavorite(productId: product.id) {
            return
        }
        
        let entity = ProductEntity(context: context)
        entity.fromDomain(product)
        coreDataManager.saveContext(context)
    }
    
    func removeProduct(productId: Int64) throws {
        let context = coreDataManager.viewContext
        let fetchRequest: NSFetchRequest<ProductEntity> = ProductEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %lld", productId)
        
        let results = try context.fetch(fetchRequest)
        if let entity = results.first {
            context.delete(entity)
            coreDataManager.saveContext(context)
        }
    }
    
    func getFavoriteProducts() throws -> [Product] {
        let context = coreDataManager.viewContext
        let fetchRequest: NSFetchRequest<ProductEntity> = ProductEntity.fetchRequest()
        
        let results = try context.fetch(fetchRequest)
        return results.map { $0.toDomain() }
    }
    
    func isFavorite(productId: Int64) throws -> Bool {
        let context = coreDataManager.viewContext
        let fetchRequest: NSFetchRequest<ProductEntity> = ProductEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %lld", productId)
        fetchRequest.fetchLimit = 1
        
        let count = try context.count(for: fetchRequest)
        return count > 0
    }
}
