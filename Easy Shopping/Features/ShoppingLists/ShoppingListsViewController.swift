//
//  ShoppingListsViewController.swift
//  Easy Shopping
//
//  Created by Agah Ozdemir on 16.12.2025.
//

import UIKit

final class ShoppingListsViewController: UIViewController {

    // MARK: - Dependencies
    private let viewModel: ShoppingListsViewModel

    // MARK: - UI
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private let emptyStateView = EmptyStateView()

    // MARK: - Init
    init(repository: ShoppingListRepository) {
        self.viewModel = ShoppingListsViewModel(repository: repository)
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
        title = "My Shopping Lists"

        configureNavigationBar()
        configureTableView()
        configureEmptyState()
        updateUI()
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
        emptyStateView.isHidden = !viewModel.isEmpty
        tableView.isHidden = viewModel.isEmpty
        tableView.reloadData()
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

            self.viewModel.createList(title: text)
            self.updateUI()
        })

        present(alert, animated: true)
    }

    private func presentEditListAlert(list: ShoppingList) {
        let alert = UIAlertController(
            title: "Listeyi Düzenle",
            message: nil,
            preferredStyle: .alert
        )

        alert.addTextField { $0.text = list.title }

        alert.addAction(UIAlertAction(title: "İptal", style: .cancel))
        alert.addAction(UIAlertAction(title: "Düzenle", style: .default) { [weak self] _ in
            guard
                let self,
                let newTitle = alert.textFields?.first?.text,
                !newTitle.trimmingCharacters(in: .whitespaces).isEmpty
            else { return }

            self.viewModel.updateList(list, newTitle: newTitle)
            self.updateUI()
        })

        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource & Delegate

extension ShoppingListsViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfLists
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: ShoppingListCell.reuseIdentifier,
            for: indexPath
        ) as! ShoppingListCell

        let list = viewModel.list(at: indexPath.row)
        let itemCount = viewModel.itemCount(for: list)

        cell.configure(with: list, itemCount: itemCount)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedList = viewModel.lists[indexPath.row]

        let detailViewModel = ShoppingListDetailViewModel(
            list: selectedList,
            repository: viewModel.repository
        )
        
        let detailVC = ShoppingListDetailViewController(
            viewModel: detailViewModel
        )
        
        navigationController?.pushViewController(detailVC, animated: true)
    }

    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {

        let list = viewModel.list(at: indexPath.row)

        let editAction = UIContextualAction(style: .normal, title: "Düzenle") { [weak self] _, _, completion in
            self?.presentEditListAlert(list: list)
            completion(true)
        }
        editAction.backgroundColor = .systemBlue

        let deleteAction = UIContextualAction(style: .destructive, title: "Sil") { [weak self] _, _, completion in
            guard let self else { return }
            self.viewModel.deleteList(at: indexPath.row)
            self.updateUI()
            completion(true)
        }

        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
}
