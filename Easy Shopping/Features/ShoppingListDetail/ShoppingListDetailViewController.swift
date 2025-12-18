//
//  ShoppingListDetailViewController.swift
//  Easy Shopping
//
//  Created by Agah Ozdemir on 18.12.2025.
//

import UIKit

final class ShoppingListDetailViewController: UIViewController {

    // MARK: - Dependencies

    private let list: ShoppingList
    private let manager: ShoppingListManager

    // MARK: - State

    private var items: [ShoppingItem] {
        manager.items(for: list)
    }

    // MARK: - UI

    private let tableView = UITableView(frame: .zero, style: .insetGrouped)

    private let emptyStateView = EmptyStateView()

    // MARK: - Init

    init(
        list: ShoppingList,
        manager: ShoppingListManager
    ) {
        self.list = list
        self.manager = manager
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Storyboard kullanılmıyor")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = list.title

        configureNavigationBar()
        configureTableView()
        configureEmptyState()
        updateUI()
    }

    // MARK: - Navigation Bar

    private func configureNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addItemTapped)
        )
    }

    // MARK: - TableView

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
            ShoppingItemCell.self,
            forCellReuseIdentifier: ShoppingItemCell.reuseIdentifier
        )
    }

    // MARK: - Empty State

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

    // MARK: - UI Update

    private func updateUI() {
        let isEmpty = items.isEmpty

        emptyStateView.isHidden = !isEmpty
        tableView.isHidden = isEmpty

        if !isEmpty {
            tableView.reloadData()
        }
    }

    // MARK: - Actions

    @objc private func addItemTapped() {
        let alert = UIAlertController(
            title: "Yeni Ürün",
            message: "Listeye ürün ekle",
            preferredStyle: .alert
        )

        alert.addTextField {
            $0.placeholder = "Ürün adı"
            $0.autocapitalizationType = .sentences
        }

        alert.addTextField {
            $0.placeholder = "Miktar (örn: 1 kg)"
        }

        alert.addAction(
            UIAlertAction(title: "İptal", style: .cancel)
        )

        alert.addAction(
            UIAlertAction(title: "Ekle", style: .default) { [weak self] _ in
                guard
                    let self,
                    let name = alert.textFields?[0].text,
                    let quantity = alert.textFields?[1].text,
                    !name.trimmingCharacters(in: .whitespaces).isEmpty
                else { return }

                self.manager.addItem(
                    to: self.list,
                    name: name,
                    quantity: quantity
                )

                self.updateUI()
            }
        )

        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource & Delegate

extension ShoppingListDetailViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        items.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: ShoppingItemCell.reuseIdentifier,
            for: indexPath
        ) as! ShoppingItemCell

        let item = items[indexPath.row]
        cell.configure(with: item)
        
        return cell
    }
}
