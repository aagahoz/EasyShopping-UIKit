//
//  ShoppingListRepository.swift
//  Easy Shopping
//
//  Created by Agah Ozdemir on 19.12.2025.
//

import Foundation

protocol ShoppingListRepository {

    // LISTS
    func fetchLists() -> [ShoppingList]
    func createList(title: String) -> ShoppingList
    func updateList(listID: UUID, newTitle: String)
    func removeList(listID: UUID)

    // ITEMS
    func items(for listID: UUID) -> [ShoppingItem]

    func addItem(
        to listID: UUID,
        name: String,
        quantity: String
    )

    func updateItem(
        itemID: UUID,
        in listID: UUID,
        newName: String,
        newQuantity: String,
        isCompleted: Bool
    )

    func removeItem(
        itemID: UUID,
        from listID: UUID
    )

    func toggleCompletion(
        itemID: UUID,
        in listID: UUID
    )
}
