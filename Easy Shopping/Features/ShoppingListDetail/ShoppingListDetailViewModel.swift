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
    let state: Observable<ShoppingListDetailState>
    
    // MARK: - Init

    init(
        list: ShoppingList,
        repository: ShoppingListRepository
    ) {
        self.list = list
        self.repository = repository
        
        let items = repository.items(for: list.id)
        self.state = Observable(ShoppingListDetailState(items: items))
    }

    // MARK: - Private

    private func reload() {
        let items = repository.items(for: list.id)
        state.value = ShoppingListDetailState(items: items)
    }

    // MARK: - Item Actions

    func addItem(name: String, quantity: String) {
        repository.addItem(
            to: list.id,
            name: name,
            quantity: quantity
        )
        reload()
    }

    func deleteItem(at index: Int) {
        guard state.value.items.indices.contains(index) else { return }

        repository.removeItem(
            itemID: state.value.items[index].id,
            from: list.id
        )

        reload()
    }

    func updateItem(
        at index: Int,
        newName: String,
        newQuantity: String,
        isCompleted: Bool
    ) {
        guard state.value.items.indices.contains(index) else { return }

        repository.updateItem(
            itemID: state.value.items[index].id,
            in: list.id,
            newName: newName,
            newQuantity: newQuantity,
            isCompleted: isCompleted
        )

        reload()
    }
    
    func toggleItemCompletion(at index: Int) {
        guard state.value.items.indices.contains(index) else { return }

        let itemID = state.value.items[index].id

        repository.toggleCompletion(
            itemID: itemID,
            in: list.id
        )

        reload()
    }
}
