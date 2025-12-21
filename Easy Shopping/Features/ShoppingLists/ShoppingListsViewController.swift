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
        bindViewModel()
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
    
    private func bindViewModel() {
        viewModel.state.bind { [weak self] state in
            self?.render(state)
        }
    }
    
    private func render(_ state: ShoppingListsState) {
        emptyStateView.isHidden = !state.isEmpty
        tableView.isHidden = state.isEmpty
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
        })

        present(alert, animated: true)
    }

    private func presentEditListAlert(at index: Int) {
        let list = viewModel.list(at: index)

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

            self.viewModel.updateList(
                at: index,
                newTitle: newTitle
            )
        })

        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource & Delegate

extension ShoppingListsViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.state.value.numberOfLists
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
        let selectedList = viewModel.state.value.lists[indexPath.row]

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

        let editAction = UIContextualAction(style: .normal, title: "Düzenle") { [weak self] _, _, completion in
            self?.presentEditListAlert(at: indexPath.row)
            completion(true)
        }
        editAction.backgroundColor = .systemBlue

        let deleteAction = UIContextualAction(style: .destructive, title: "Sil") { [weak self] _, _, completion in
            guard let self else { return }
            self.viewModel.deleteList(at: indexPath.row)
            completion(true)
        }

        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
}
