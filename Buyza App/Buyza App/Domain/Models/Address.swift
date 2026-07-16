//
//  Address.swift
//  Buyza App
//

import Foundation

struct Address: Identifiable, Equatable {
    let id: String
    let firstName: String
    let lastName: String
    let phoneNumber: String
    let streetAddress: String
    let city: String
    let province: String
    let zip: String
    let country: String
    var isDefault: Bool
    
    var fullName: String {
        return "\(firstName) \(lastName)".trimmingCharacters(in: .whitespaces)
    }
    
    var fullAddressString: String {
        var parts = [streetAddress, city]
        let stateZip = [province, zip].filter { !$0.isEmpty }.joined(separator: " ")
        if !stateZip.isEmpty {
            parts.append(stateZip)
        }
        if !country.isEmpty {
            parts.append(country)
        }
        return parts.filter { !$0.isEmpty }.joined(separator: ", ")
    }
}
