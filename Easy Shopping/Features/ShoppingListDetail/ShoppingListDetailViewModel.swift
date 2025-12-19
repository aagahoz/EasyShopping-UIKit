//
//  ShoppingListDetailViewModel.swift
//  Easy Shopping
//
//  Created by Agah Ozdemir on 19.12.2025
//

import Foundation

final class ShoppingListDetailViewModel {

    // MARK: - Dependencies

    let list: ShoppingList
    private let repository: ShoppingListRepository

    // MARK: - State

    private(set) var items: [ShoppingItem] = []

    // MARK: - Init

    init(
        list: ShoppingList,
        repository: ShoppingListRepository
    ) {
        self.list = list
        self.repository = repository
        loadItems()
    }

    // MARK: - Data Loading

    func loadItems() {
        items = repository.items(for: list)
    }

    // MARK: - UI Helpers

    var isEmpty: Bool {
        items.isEmpty
    }

    var numberOfItems: Int {
        items.count
    }

    func item(at index: Int) -> ShoppingItem {
        items[index]
    }

    // MARK: - Item Actions

    func addItem(name: String, quantity: String) {
        repository.addItem(
            to: list,
            name: name,
            quantity: quantity
        )
        loadItems()
    }

    func deleteItem(at index: Int) {
        guard items.indices.contains(index) else { return }
        let item = items[index]
        repository.removeItem(item, from: list)
        loadItems()
    }

    func updateItem(
        _ item: ShoppingItem,
        newName: String,
        newQuantity: String
    ) {
        repository.updateItem(
            item,
            in: list,
            newName: newName,
            newQuantity: newQuantity
        )
        loadItems()
    }
}
