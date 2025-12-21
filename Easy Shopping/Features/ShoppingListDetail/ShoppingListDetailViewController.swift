//
//  ShoppingListDetailViewController.swift
//  Easy Shopping
//
//  Created by Agah Ozdemir on 18.12.2025
//

import UIKit

final class ShoppingListDetailViewController: UIViewController {

    // MARK: - Dependencies

    private let viewModel: ShoppingListDetailViewModel

    // MARK: - UI

    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private let emptyStateView = EmptyStateView()

    // MARK: - Init

    init(viewModel: ShoppingListDetailViewModel) {
        self.viewModel = viewModel
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
        title = viewModel.list.title

        configureNavigationBar()
        configureTableView()
        configureEmptyState()
        bindViewModel()
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

    private func bindViewModel() {
        viewModel.state.bind { [weak self] state in
            self?.render(state)
        }
    }
    
    private func render(_ state: ShoppingListDetailState) {
        emptyStateView.isHidden = !state.isEmpty
        tableView.isHidden = state.isEmpty
        tableView.reloadData()
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

        alert.addAction(UIAlertAction(title: "İptal", style: .cancel))

        alert.addAction(UIAlertAction(title: "Ekle", style: .default) { [weak self] _ in
            guard
                let self,
                let name = alert.textFields?[0].text,
                let quantity = alert.textFields?[1].text,
                !name.trimmingCharacters(in: .whitespaces).isEmpty
            else { return }

            self.viewModel.addItem(name: name, quantity: quantity)
        })

        present(alert, animated: true)
    }

    private func presentEditItemAlert(at index: Int) {
        let item = viewModel.state.value.items[index]

        let alert = UIAlertController(
            title: "Ürünü Düzenle",
            message: nil,
            preferredStyle: .alert
        )

        alert.addTextField { $0.text = item.name }
        alert.addTextField { $0.text = item.quantity }

        alert.addAction(UIAlertAction(title: "İptal", style: .cancel))
        alert.addAction(UIAlertAction(title: "Kaydet", style: .default) { [weak self] _ in
            guard
                let self,
                let newName = alert.textFields?[0].text,
                let newQuantity = alert.textFields?[1].text,
                !newName.trimmingCharacters(in: .whitespaces).isEmpty
            else { return }

            self.viewModel.updateItem(
                at: index,
                newName: newName,
                newQuantity: newQuantity,
                isCompleted: item.isCompleted
            )
        })

        present(alert, animated: true)
    }

}

// MARK: - UITableViewDataSource & Delegate

extension ShoppingListDetailViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        viewModel.state.value.numberOfItems
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: ShoppingItemCell.reuseIdentifier,
            for: indexPath
        ) as! ShoppingItemCell

        let item = viewModel.state.value.items[indexPath.row]
        cell.configure(with: item)

        return cell
    }

    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {

        let editAction = UIContextualAction(style: .normal, title: "Düzenle") { [weak self] _, _, completion in
            self?.presentEditItemAlert(at: indexPath.row)
            completion(true)
        }
        editAction.backgroundColor = .systemBlue

        let deleteAction = UIContextualAction(style: .destructive, title: "Sil") { [weak self] _, _, completion in
            guard let self else { return }
            self.viewModel.deleteItem(at: indexPath.row)
            completion(true)
        }

        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        guard
            let cell = tableView.cellForRow(at: indexPath) as? ShoppingItemCell
        else { return }

        viewModel.toggleItemCompletion(at: indexPath.row)

        let updatedItem = viewModel.state.value.items[indexPath.row]

        cell.configure(with: updatedItem, animated: true)

        tableView.deselectRow(at: indexPath, animated: true)
    }
}

