//
//  CoreDataShoppingListRepository.swift
//  Easy Shopping
//
//  Created by Agah Ozdemir on 21.12.2025.
//

import CoreData

final class CoreDataShoppingListRepository: ShoppingListRepository {

    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = CoreDataStack.shared.context) {
        self.context = context
    }

    // MARK: - Lists

    func fetchLists() -> [ShoppingList] {
        let request: NSFetchRequest<ShoppingListEntity> = ShoppingListEntity.fetchRequest()
        let entities = (try? context.fetch(request)) ?? []

        return entities.map {
            ShoppingList(id: $0.id!, title: $0.title!)
        }
    }

    func createList(title: String) -> ShoppingList {
        let entity = ShoppingListEntity(context: context)
        entity.id = UUID()
        entity.title = title

        save()

        return ShoppingList(id: entity.id!, title: entity.title!)
    }

    func updateList(listID: UUID, newTitle: String) {
        guard let entity = listEntity(by: listID) else { return }
        entity.title = newTitle
        save()
    }

    func removeList(listID: UUID) {
        guard let entity = listEntity(by: listID) else { return }
        context.delete(entity)
        save()
    }

    // MARK: - Items

    func items(for listID: UUID) -> [ShoppingItem] {
        guard let list = listEntity(by: listID) else { return [] }
        let items = list.items?.allObjects as? [ShoppingItemEntity] ?? []

        return items.map {
            ShoppingItem(
                id: $0.id!,
                name: $0.name!,
                quantity: $0.quantity!,
                isCompleted: $0.isCompleted
            )
        }
    }

    func addItem(to listID: UUID, name: String, quantity: String) {
        guard let list = listEntity(by: listID) else { return }

        let item = ShoppingItemEntity(context: context)
        item.id = UUID()
        item.name = name
        item.quantity = quantity
        item.isCompleted = false
        item.list = list

        save()
    }

    func updateItem(
        itemID: UUID,
        in listID: UUID,
        newName: String,
        newQuantity: String,
        isCompleted: Bool
    ) {
        guard let item = itemEntity(by: itemID) else { return }

        item.name = newName
        item.quantity = newQuantity
        item.isCompleted = isCompleted
        save()
    }

    func removeItem(itemID: UUID, from listID: UUID) {
        guard let item = itemEntity(by: itemID) else { return }
        context.delete(item)
        save()
    }

    func toggleCompletion(itemID: UUID, in listID: UUID) {
        guard let item = itemEntity(by: itemID) else { return }
        item.isCompleted.toggle()
        save()
    }

    // MARK: - Helpers

    private func listEntity(by id: UUID) -> ShoppingListEntity? {
        let request: NSFetchRequest<ShoppingListEntity> = ShoppingListEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        return try? context.fetch(request).first
    }

    private func itemEntity(by id: UUID) -> ShoppingItemEntity? {
        let request: NSFetchRequest<ShoppingItemEntity> = ShoppingItemEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        return try? context.fetch(request).first
    }

    private func save() {
        try? context.save()
    }
}
