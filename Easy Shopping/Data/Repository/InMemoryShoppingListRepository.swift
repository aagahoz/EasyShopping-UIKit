//
//  InMemoryShoppingListRepository.swift
//  Easy Shopping
//
//  Created by Agah Ozdemir on 18.12.2025.
//

import Foundation

final class InMemoryShoppingListRepository: ShoppingListRepository {
    
    private var lists: [ShoppingList] = []
    private var itemsByListID: [UUID: [ShoppingItem]] = [:]
    
    func fetchLists() -> [ShoppingList] {
        lists
    }
    
    @discardableResult
    func createList(title: String) -> ShoppingList {
        let list = ShoppingList(id: UUID(), title: title)
        lists.append(list)
        itemsByListID[list.id] = []
        return list
    }
    
    func updateList(listID: UUID, newTitle: String) {
        guard let index = lists.firstIndex(where: { $0.id == listID }) else { return }
        lists[index].title = newTitle
    }

    func removeList(listID: UUID) {
        lists.removeAll { $0.id == listID }
        itemsByListID[listID] = nil
    }
    
    func items(for listID: UUID) -> [ShoppingItem] {
        itemsByListID[listID] ?? []
    }
    
    func addItem(
        to listID: UUID,
        name: String,
        quantity: String
    ) {
        let item = ShoppingItem(
            id: UUID(),
            name: name,
            quantity: quantity,
            isCompleted: false
        )
        itemsByListID[listID, default: []].append(item)
    }
    
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
              let index = items.firstIndex(where: { $0.id == itemID }) else {
            return
        }

        items[index].isCompleted.toggle()
        itemsByListID[listID] = items
    }

}
