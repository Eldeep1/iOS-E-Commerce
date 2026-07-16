//
//  Product.swift
//  Buyza App
//
//  Created by Ahmad Fathy on 27/06/2026.
//

import Foundation

struct ProductResponse: Decodable {
    let product: Product
}

struct ProductsResponse: Decodable {
    let products: [Product]
}

struct Product: Identifiable, Decodable, Hashable {
    let id: Int64
    let title: String
    let body_html: String?
    let vendor: String
    let product_type: String
    let status: String?
    let options: [ProductOption]
    let images: [ProductImage]
    let variants: [ProductVariant]

    private enum CodingKeys: String, CodingKey {
        case id, title, body_html, vendor, product_type, status, options, images, variants
    }

    var brandName: String {
        vendor.uppercased()
    }

    var price: Decimal {
        Decimal(string: variants.first?.price ?? "0") ?? 0
    }

    var imageURLs: [URL] {
        images
            .sorted { ($0.position ?? 0) < ($1.position ?? 0) }
            .compactMap { URL(string: $0.src) }
    }

    var sizeValues: [String] {
        options.first { $0.name.lowercased() == "size" }?.values ?? []
    }

    var colorValues: [String] {
        options.first { $0.name.lowercased() == "color" }?.values ?? []
    }

    var descriptionText: String {
        body_html?.htmlStripped ?? ""
    }
}

struct ProductOption: Identifiable, Codable, Hashable {
    let id: Int64
    let name: String
    let values: [String]
}

struct ProductImage: Codable, Hashable {
    let src: String
    let position: Int?
}

struct ProductVariant: Codable, Hashable {
    let id: Int64
    let price: String
    let option1: String?
    let option2: String?
    let option3: String?
}

extension Product {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int64.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        body_html = try container.decodeIfPresent(String.self, forKey: .body_html)
        vendor = try container.decode(String.self, forKey: .vendor)
        product_type = try container.decode(String.self, forKey: .product_type)
        status = try container.decodeIfPresent(String.self, forKey: .status)
        options = try container.decodeIfPresent([ProductOption].self, forKey: .options) ?? []
        images = try container.decodeIfPresent([ProductImage].self, forKey: .images) ?? []
        variants = try container.decodeIfPresent([ProductVariant].self, forKey: .variants) ?? []
    }
}

extension Product {
    static let adidasClassicBackpack = ProductResponse.adidasClassicBackpackSample.product
}

extension ProductResponse {
    static let adidasClassicBackpackSample: ProductResponse = {
        let json = """
        {
            "product": {
                "id": 8894529437893,
                "title": "ADIDAS | CLASSIC BACKPACK",
                "body_html": "This women's backpack has a glam look, thanks to a faux-leather build with an allover fur print. The front zip pocket keeps small things within reach, while an interior divider reins in potential chaos.",
                "vendor": "ADIDAS",
                "product_type": "ACCESSORIES",
                "status": "active",
                "options": [
                    {
                        "id": 11162534248645,
                        "name": "Size",
                        "values": ["OS"]
                    },
                    {
                        "id": 11162534281413,
                        "name": "Color",
                        "values": ["black"]
                    }
                ],
                "images": [
                    {
                        "position": 1,
                        "src": "https://cdn.shopify.com/s/files/1/0790/8907/4373/files/product_29_image1.jpg?v=1782058578"
                    },
                    {
                        "position": 2,
                        "src": "https://cdn.shopify.com/s/files/1/0790/8907/4373/files/product_29_image2.jpg?v=1782058578"
                    },
                    {
                        "position": 3,
                        "src": "https://cdn.shopify.com/s/files/1/0790/8907/4373/files/product_29_image3.jpg?v=1782058578"
                    }
                ],
                "variants": [
                    {
                        "id": 46441522528453,
                        "price": "70.00",
                        "option1": "OS",
                        "option2": "black"
                    }
                ]
            }
        }
        """
        let data = Data(json.utf8)
        return try! JSONDecoder().decode(ProductResponse.self, from: data)
    }()
}
