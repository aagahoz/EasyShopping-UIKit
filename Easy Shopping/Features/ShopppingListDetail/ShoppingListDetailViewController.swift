//
//  ShoppingListDetailViewController.swift
//  Easy Shopping
//
//  Created by Agah Ozdemir on 18.12.2025.
//

import UIKit

final class ShoppingListDetailViewController: UIViewController {
    
    // MARK - Dependincies
    private var list: ShoppingList
    private var manager: ShoppingListManager
    
    // MARK - UI
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private let emptyStateView = EmptyStateView()
    
    // MARK - Init
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
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        title = list.title
        
        configureNavigationBar()
        configureTableView()
        configureEmptyState()
        updateUI()
    }
    
    private var items: [ShoppingItem] {
        manager.items(for: list)
    }
    
    private func configureNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addItemTapped)
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
            UITableViewCell.self,
            forCellReuseIdentifier: "ItemCell"
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
        let isEmpty = items.isEmpty
        
        emptyStateView.isHidden = !isEmpty
        tableView.isHidden = isEmpty
        tableView.reloadData()
    }
    
    @objc private func addItemTapped() {
        let alert = UIAlertController(
            title: "Yeni Ürün",
            message: "Listeye Ürün Ekle",
            preferredStyle: .alert
        )
        
        alert.addTextField {
            $0.placeholder = "Ürün adı"
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
            
            self.manager.addItem(
                to: self.list,
                name: name,
                quantity: quantity
            )
            
            self.updateUI()
        })
        present(alert, animated: true)
    }
}

extension ShoppingListDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "ItemCell",
            for: indexPath
        )
        
        let item = items[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = item.name
        content.secondaryText = item.quantity
        
        cell.contentConfiguration = content
        return cell
    }
}
