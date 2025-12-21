//
//  MockShoppingListRepository+Items.swift
//  Easy ShoppingTests
//
//  Created by Agah Ozdemir on 20.12.2025.
//

import Foundation
@testable import Easy_Shopping

extension MockShoppingListRepository {
    
    func updateItem(
        itemID: UUID,
        in listID: UUID,
        newName: String,
        newQuantity: String,
        isCompleted: Bool
    ) {
        guard var items = itemsByListID[listID],
              let index = items.firstIndex(where: { $0.id == itemID }) else { return }

        items[index].name = newName
        items[index].quantity = newQuantity
        items[index].isCompleted = isCompleted
        itemsByListID[listID] = items
    }

    func removeItem(
        itemID: UUID,
        from listID: UUID
    ) {
        guard var items = itemsByListID[listID] else { return }
        items.removeAll { $0.id == itemID }
        itemsByListID[listID] = items
    }

    func toggleCompletion(
        itemID: UUID,
        in listID: UUID
    ) {
        guard var items = itemsByListID[listID],
              let index = items.firstIndex(where: { $0.id == itemID }) else { return }

        items[index].isCompleted.toggle()
        itemsByListID[listID] = items
    }
}
