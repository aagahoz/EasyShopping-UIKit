//
//  ShoppingListsViewModel.swift
//  Easy Shopping
//
//  Created by Agah Ozdemir on 19.12.2025.
//

import Foundation

final class ShoppingListsViewModel {

    // MARK: - Dependencies

    /// Verinin nereden geldiğini bilen katman
    /// (InMemory, CoreData, Firebase fark etmez)
    let repository: ShoppingListRepository

    // MARK: - State

    /// Ekranın göstereceği shopping list'ler
    /// ViewController bu veriyi SADECE okur
//    private(set) var lists: [ShoppingList] = []
    let state: Observable<ShoppingListsState>
    
    // MARK: - Init

    init(repository: ShoppingListRepository) {
        self.repository = repository
        self.state = Observable(ShoppingListsState(lists: repository.fetchLists()))
    }

    // MARK: - Data Loading
    
    func reload() {
        state.value = ShoppingListsState(lists: repository.fetchLists())
    }
    
    /// Repository'den listeleri çeker ve ViewModel state'ini günceller
//    func loadLists() {
//        lists = repository.fetchLists()
//    }

    // MARK: - Computed Properties (UI Kararları)

//    /// Empty state gösterilecek mi?
//    var isEmpty: Bool {
//        lists.isEmpty
//    }
//
//    /// TableView için güvenli count
//    var numberOfLists: Int {
//        lists.count
//    }

    // MARK: - List Actions

    /// Yeni liste oluşturur
    func createList(title: String) {
        repository.createList(title: title)
        reload()
    }

    /// Index üzerinden liste siler (UI index ile çalışır)
    func deleteList(at index: Int) {
        guard state.value.lists.indices.contains(index) else { return }

        repository.removeList(
            listID: state.value.lists[index].id
        )

        reload()
    }

    /// Liste başlığını günceller
    func updateList(at index: Int, newTitle: String) {
        guard state.value.lists.indices.contains(index) else { return }

        repository.updateList(
            listID: state.value.lists[index].id,
            newTitle: newTitle
        )

        reload()
    }

    // MARK: - Helpers (Cell için)

    /// TableView cell'leri için liste döner
    func list(at index: Int) -> ShoppingList {
        state.value.lists[index]
    }

    /// Bir listenin item sayısını hesaplar
    func itemCount(for list: ShoppingList) -> Int {
        repository.items(for: list.id).count
    }
}
