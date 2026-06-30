//
//  ShopifyLoginModels.swift
//  Buyza App
//
//  Created by depo on 29/06/2026.
//

struct CustomerAccessTokenVariables: Encodable {
    let input: CustomerAccessTokenInput
}
struct CustomerAccessTokenInput: Encodable {
    let email: String
    let password: String
}
struct CustomerAccessTokenResponse: Decodable {
    let customerAccessTokenCreate: CustomerAccessTokenPayload
}
struct CustomerAccessTokenPayload: Decodable {
    let customerAccessToken: AccessTokenNode?
    let customerUserErrors: [ShopifyUserError]
}
struct AccessTokenNode: Decodable {
    let accessToken: String
}
struct CustomerByTokenResponse: Decodable {
    let customer: CustomerIDNode?
}
struct CustomerIDNode: Decodable {
    let id: String
}
