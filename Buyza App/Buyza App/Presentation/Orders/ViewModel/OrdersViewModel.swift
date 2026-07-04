//
//  OrdersViewModel.swift
//  Buyza App
//

import Foundation

final class OrdersViewModel: ObservableObject {
    @Published private(set) var orders: [Order] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let getOrdersUseCase: GetOrdersUseCaseProtocol

    init(
        getOrdersUseCase: GetOrdersUseCaseProtocol = GetOrdersUseCase(
            repository: OrderRepositoryImp(
                remoteDataSource: ShopifyOrderDataSource()
            )
        )
    ) {
        self.getOrdersUseCase = getOrdersUseCase
    }

    func loadOrders() {
        Task { @MainActor in
            isLoading = true
            errorMessage = nil
            do {
                orders = try await getOrdersUseCase.execute()
            } catch {
                errorMessage = error.localizedDescription
                orders = []
            }
            isLoading = false
        }
    }
}
