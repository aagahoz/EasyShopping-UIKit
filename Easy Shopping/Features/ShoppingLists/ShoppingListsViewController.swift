//
//  ShoppingListsViewController.swift
//  Easy Shopping
//
//  Created by Agah Ozdemir on 16.12.2025.
//

import UIKit

final class ShoppingListsViewController: UIViewController {

    // MARK: - Dependencies
    private let manager: ShoppingListManager

    // MARK: - UI
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private let emptyStateView = EmptyStateView()

    // MARK: - Init
    init(manager: ShoppingListManager) {
        self.manager = manager
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = "My Shopping Lists"

        configureNavigationBar()
        configureTableView()
        configureEmptyState()
        updateUI()
    }

    private var shoppingLists: [ShoppingList] {
        manager.lists
    }

    // MARK: - UI Setup

    private func configureNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addButtonTapped)
        )
    }

    private func configureTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        tableView.dataSource = self
        tableView.delegate = self

        tableView.register(
            ShoppingListCell.self,
            forCellReuseIdentifier: ShoppingListCell.reuseIdentifier
        )
    }

    private func configureEmptyState() {
        view.addSubview(emptyStateView)
        emptyStateView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            emptyStateView.topAnchor.constraint(equalTo: view.topAnchor),
            emptyStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emptyStateView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func updateUI() {
        let isEmpty = shoppingLists.isEmpty
        emptyStateView.isHidden = !isEmpty
        tableView.isHidden = isEmpty
        
        if !isEmpty {
            tableView.reloadData()
        }
    }

    // MARK: - Actions

    @objc private func addButtonTapped() {
        let alert = UIAlertController(
            title: "Yeni Liste",
            message: "Liste adı gir",
            preferredStyle: .alert
        )

        alert.addTextField {
            $0.placeholder = "Örn: Haftalık Alışveriş"
        }

        alert.addAction(UIAlertAction(title: "İptal", style: .cancel))

        alert.addAction(UIAlertAction(title: "Ekle", style: .default) { [weak self] _ in
            guard
                let self,
                let text = alert.textFields?.first?.text,
                !text.trimmingCharacters(in: .whitespaces).isEmpty
            else { return }

            self.manager.createList(title: text)
            self.updateUI()
        })

        present(alert, animated: true)
    }
}

// MARK: - TableView

extension ShoppingListsViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        shoppingLists.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: ShoppingListCell.reuseIdentifier,
            for: indexPath
        ) as! ShoppingListCell
        
        let list = shoppingLists[indexPath.row]
        let itemCount = manager.items(for: list).count
        
        cell.configure(with: list, itemCount: itemCount)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedList = shoppingLists[indexPath.row]
        
        let detailVC = ShoppingListDetailViewController(
            list: selectedList,
            manager: manager
        )
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        guard editingStyle == .delete else { return }
        
        let listToRemove = shoppingLists[indexPath.row]
        manager.removeList(listToRemove)
        
        tableView.deleteRows(at: [indexPath], with: .automatic)
        updateUI()
    }
}
