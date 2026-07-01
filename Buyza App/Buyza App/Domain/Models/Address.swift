//
//  Address.swift
//  Buyza App
//

import Foundation

struct Address: Identifiable, Equatable {
    let id: String
    let fullName: String
    let phoneNumber: String
    let streetAddress: String
    let city: String
    let country: String
    var isDefault: Bool
    
    var fullAddressString: String {
        return "\(streetAddress), \(city), \(country)"
    }
}
