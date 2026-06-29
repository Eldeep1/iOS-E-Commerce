//
//  KeychainService.swift
//  Buyza App
//
//  Created by depo on 29/06/2026.
//

import Foundation
import Security

protocol LocalAuthDataSourceProtocol {
    func saveShopifyID(_ id: String) throws
    func getShopifyID() throws -> String
}

final class KeychainService : LocalAuthDataSourceProtocol{
    
    func saveShopifyID(_ id: String) throws {
        print("from the save in the keychain")
        print(id)
        try save(key: "ShopifyCustomerID", value: id)
    }
    
    func getShopifyID() throws -> String {
        return try read(key: "ShopifyCustomerID")
    }
    
    enum KeychainError: Error {
        case itemNotFound
        case unexpectedStatus(OSStatus)
    }
    
    static let shared = KeychainService()
    private init() {}
    
    func save(key: String, value: String) throws {
        let data = Data(value.utf8)
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]
        
        // delete any existing item with this key before saving
        SecItemDelete(query as CFDictionary)
        
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw KeychainError.unexpectedStatus(status)
        }
    }
    
    func read(key: String) throws -> String {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        guard status == errSecSuccess, let data = dataTypeRef as? Data, let result = String(data: data, encoding: .utf8) else {
            throw KeychainError.itemNotFound
        }
        
        return result
    }
}
