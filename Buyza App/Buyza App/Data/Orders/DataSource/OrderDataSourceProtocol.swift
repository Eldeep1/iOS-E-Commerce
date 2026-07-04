//
//  OrderDataSourceProtocol.swift
//  Buyza App
//

import Foundation

protocol OrderDataSourceProtocol {
    func fetchOrders() async throws -> [OrderDTO]
}
