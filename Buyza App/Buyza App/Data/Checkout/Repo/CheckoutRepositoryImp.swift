//
//  CheckoutRepositoryImp.swift
//  Buyza App
//

import Foundation

struct CheckoutRepositoryImp: CheckoutRepository {
    private let remoteDataSource: CheckoutDataSourceProtocol
    private let adminDataSource: ShopifyAdminCheckoutDataSource
    private let localAuth: LocalAuthDataSourceProtocol
    
    init(
        remoteDataSource: CheckoutDataSourceProtocol = ShopifyCheckoutDataSource(),
        adminDataSource: ShopifyAdminCheckoutDataSource = ShopifyAdminCheckoutDataSource(),
        localAuth: LocalAuthDataSourceProtocol = KeychainService.shared
    ) {
        self.remoteDataSource = remoteDataSource
        self.adminDataSource = adminDataSource
        self.localAuth = localAuth
    }
    
    func createCheckout(cartID: String, addressID: String?) async throws -> CheckoutSummary {
        var currentCartID = cartID
        if let addressID = addressID {
            if let token = try? localAuth.getShopifyToken() {
                currentCartID = try await remoteDataSource.updateBuyerIdentity(cartID: cartID, addressID: addressID, customerAccessToken: token)
                
                if currentCartID != cartID {
                    UserDefaults.standard.set(currentCartID, forKey: "shopify_cart_id")
                }
            } else {
                print("Warning: Could not fetch shopify token to attach address to cart.")
            }
        }
        
        return try await remoteDataSource.getCheckoutURL(cartID: currentCartID)
    }
    
    func applyDiscount(checkoutID: String, discountCode: String) async throws -> CheckoutSummary {
        return try await remoteDataSource.applyDiscount(cartID: checkoutID, discountCode: discountCode)
    }
    
    func placeCODOrder(cartID: String, address: Address, customerID: String, discountAmount: Double, discountCode: String?) async throws -> Order {
        return try await adminDataSource.placeCODOrder(cartID: cartID, address: address, customerID: customerID, discountAmount: discountAmount, discountCode: discountCode)
    }
    
    func fetchLatestOrder(customerID: String) async throws -> Order? {
        return try await adminDataSource.fetchLatestOrder(customerID: customerID)
    }
}
