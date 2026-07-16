//
//  OrderRepository.swift
//  Buyza App
//

import Foundation

protocol OrderRepositoryProtocol {
    func fetchOrders() async throws -> [Order]
}
