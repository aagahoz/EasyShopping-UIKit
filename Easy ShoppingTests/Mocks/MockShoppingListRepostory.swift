//
//  MockShoppingListRepostory.swift
//  Easy ShoppingTests
//
//  Created by Agah Ozdemir on 20.12.2025.
//

import Foundation
@testable import Easy_Shopping

final class MockShoppingListRepository: ShoppingListRepository {

    private(set) var lists: [ShoppingList] = []
    var itemsByListID: [UUID: [ShoppingItem]] = [:]

    // MARK: - Lists

    func fetchLists() -> [ShoppingList] {
        lists
    }

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

    // MARK: - Items

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
}
