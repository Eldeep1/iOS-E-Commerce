//
//  AddressUIModel.swift
//  Buyza App
//

import Foundation

struct AddressUIModel: Identifiable, Equatable {
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
    
    // Mock data for UI development
    static let mocks: [AddressUIModel] = [
        AddressUIModel(
            id: "1",
            fullName: "John Doe",
            phoneNumber: "+1 234 567 8900",
            streetAddress: "123 Apple Park Way",
            city: "Cupertino",
            country: "United States",
            isDefault: true
        ),
        AddressUIModel(
            id: "2",
            fullName: "Jane Smith",
            phoneNumber: "+44 20 7946 0958",
            streetAddress: "10 Downing Street",
            city: "London",
            country: "United Kingdom",
            isDefault: false
        )
    ]
}
