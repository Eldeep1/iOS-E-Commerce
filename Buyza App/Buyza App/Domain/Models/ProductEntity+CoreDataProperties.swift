//
//  ProductEntity+CoreDataProperties.swift
//  Buyza App
//
//  Created by Ahmed Tarek on 03/07/2026.
//
//

import Foundation
import CoreData

extension ProductEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProductEntity> {
        return NSFetchRequest<ProductEntity>(entityName: "ProductEntity")
    }

    @NSManaged public var id: Int64
    @NSManaged public var title: String
    @NSManaged public var body_html: String?
    @NSManaged public var vendor: String
    @NSManaged public var product_type: String
    @NSManaged public var status: String?
    @NSManaged public var optionsData: Data?
    @NSManaged public var imagesData: Data?
    @NSManaged public var variantsData: Data?

    // MARK: - Computed Properties for Domain Models
    
    var options: [ProductOption] {
        get {
            guard let data = optionsData else { return [] }
            return (try? JSONDecoder().decode([ProductOption].self, from: data)) ?? []
        }
        set {
            optionsData = try? JSONEncoder().encode(newValue)
        }
    }
    
    var images: [ProductImage] {
        get {
            guard let data = imagesData else { return [] }
            return (try? JSONDecoder().decode([ProductImage].self, from: data)) ?? []
        }
        set {
            imagesData = try? JSONEncoder().encode(newValue)
        }
    }
    
    var variants: [ProductVariant] {
        get {
            guard let data = variantsData else { return [] }
            return (try? JSONDecoder().decode([ProductVariant].self, from: data)) ?? []
        }
        set {
            variantsData = try? JSONEncoder().encode(newValue)
        }
    }
}

extension ProductEntity : Identifiable {

}

// MARK: - Domain Mapping

extension ProductEntity {
    func toDomain() -> Product {
        return Product(
            id: self.id,
            title: self.title,
            body_html: self.body_html,
            vendor: self.vendor,
            product_type: self.product_type,
            status: self.status,
            options: self.options,
            images: self.images,
            variants: self.variants
        )
    }
    
    func fromDomain(_ product: Product) {
        self.id = product.id
        self.title = product.title
        self.body_html = product.body_html
        self.vendor = product.vendor
        self.product_type = product.product_type
        self.status = product.status
        self.options = product.options
        self.images = product.images
        self.variants = product.variants
    }
}
