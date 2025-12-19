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
    private(set) var lists: [ShoppingList] = []

    // MARK: - Init

    init(repository: ShoppingListRepository) {
        self.repository = repository
        loadLists()
    }

    // MARK: - Data Loading

    /// Repository'den listeleri çeker ve ViewModel state'ini günceller
    func loadLists() {
        lists = repository.fetchLists()
    }

    // MARK: - Computed Properties (UI Kararları)

    /// Empty state gösterilecek mi?
    var isEmpty: Bool {
        lists.isEmpty
    }

    /// TableView için güvenli count
    var numberOfLists: Int {
        lists.count
    }

    // MARK: - List Actions

    /// Yeni liste oluşturur
    func createList(title: String) {
        repository.createList(title: title)
        loadLists()
    }

    /// Index üzerinden liste siler (UI index ile çalışır)
    func deleteList(at index: Int) {
        guard lists.indices.contains(index) else { return }
        let list = lists[index]
        repository.removeList(list)
        loadLists()
    }

    /// Liste başlığını günceller
    func updateList(_ list: ShoppingList, newTitle: String) {
        repository.updateList(list, newTitle: newTitle)
        loadLists()
    }

    // MARK: - Helpers (Cell için)

    /// TableView cell'leri için liste döner
    func list(at index: Int) -> ShoppingList {
        lists[index]
    }

    /// Bir listenin item sayısını hesaplar
    func itemCount(for list: ShoppingList) -> Int {
        repository.items(for: list).count
    }
}
