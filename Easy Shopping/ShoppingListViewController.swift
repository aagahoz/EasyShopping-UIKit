//
//  ShoppingListViewController.swift
//  Easy Shopping
//
//  Created by Agah Ozdemir on 16.12.2025.
//

import UIKit

struct ShoppingList {
    let title: String
}

final class ShoppingListViewController: UIViewController {
    
    // Mark - State
    private var shoppingLists: [ShoppingList] = []
    
    // Mark - UI
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private let emptyStateView = EmptyStateView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        title = "My Shopping List"
        
        configureNavigationBar()
        configureTableView()
        configureEmptyState()
        updateUI()
    }
    
    private func configureNavigationBar() {
        let addButton = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addButtonTapped)
        )
        navigationItem.rightBarButtonItem = addButton
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
            UITableViewCell.self,
            forCellReuseIdentifier: "ListCell"
        )
    }
    
    private func configureEmptyState() {
        view.addSubview(emptyStateView)
        
        emptyStateView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            emptyStateView.topAnchor.constraint(equalTo: view.topAnchor),
            emptyStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyStateView.trailingAnchor.constraint(equalTo:  view.trailingAnchor),
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
    
    @objc private func addButtonTapped() {
        let alert = UIAlertController(
            title: "Yeni Liste",
            message: "Liste adı gir",
            preferredStyle: .alert
        )
        
        alert.addTextField { textField in
            textField.placeholder = "Örn: Haftalık Alışveriş"
        }
        
        let cancelAction = UIAlertAction(title: "İptal", style: .cancel)
        
        let addAction = UIAlertAction(title: "Ekle", style: .default) { [weak self] _ in
            guard
                let text = alert.textFields?.first?.text,
                !text.trimmingCharacters(in: .whitespaces).isEmpty
            else { return }
            
            self?.shoppingLists.append(ShoppingList(title: text))
            self?.updateUI()
        }
        
        alert.addAction(cancelAction)
        alert.addAction(addAction)
        present(alert, animated: true)
    }
}

extension ShoppingListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        shoppingLists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        content.text = shoppingLists[indexPath.row].title
        
        cell.contentConfiguration = content
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
}
