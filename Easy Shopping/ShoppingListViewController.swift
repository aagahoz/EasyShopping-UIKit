//
//  ShoppingListViewController.swift
//  Easy Shopping
//
//  Created by Agah Ozdemir on 16.12.2025.
//

import UIKit

final class ShoppingListViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        configureNavigationBar()
        configureAddButton()
    }
    
    
    private func configureNavigationBar() {
        title = "EasyShopping"
        
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func configureAddButton() {
        let addButton = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addButtonTapped)
        )
        navigationItem.rightBarButtonItem = addButton
    }
    
    @objc private func addButtonTapped() {
        presentAddItemAlert()
    }
    
    private func presentAddItemAlert() {
        
        let alertController = UIAlertController(
            title: "Yeni Ürün",
            message: "Alışveriş listene ekle",
            preferredStyle: .alert
        )
        
        alertController.addTextField { textfield in
            textfield.placeholder = "Ürün adı"
            textfield.autocapitalizationType = .sentences
        }
        
        let cancelAction = UIAlertAction(
                title: "İptal",
                style: .cancel
        )
        
        let addAction = UIAlertAction(
            title: "Ekle",
            style: .default
        ) { [weak alertController] _ in
            let text = alertController?.textFields?.first?.text
            print("Girilen ürün \(text ?? "")")
        }
        alertController.addAction(cancelAction)
        alertController.addAction(addAction)
        
        present(alertController, animated: true)
    }
    
}
