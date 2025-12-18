//
//  ShoppingItemCell.swift
//  Easy Shopping
//
//  Created by Agah Ozdemir on 18.12.2025.
//

import UIKit

final class ShoppingItemCell: UITableViewCell {

    // MARK: - Reuse Identifier

    static let reuseIdentifier = "ShoppingItemCell"

    // MARK: - UI Elements

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .label
        label.numberOfLines = 1
        return label
    }()

    private let quantityLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        return label
    }()

    private let statusImageView: UIImageView = {
        let imageView = UIImageView(
            image: UIImage(systemName: "circle")
        )
        imageView.tintColor = .tertiaryLabel
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
        configureLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Storyboard kullanılmıyor")
    }

    // MARK: - Configuration

    func configure(with item: ShoppingItem) {
        nameLabel.text = item.name
        quantityLabel.text = item.quantity
    }

    // MARK: - Setup

    private func configureCell() {
        selectionStyle = .none
        backgroundColor = .clear

        contentView.addSubview(statusImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(quantityLabel)
    }

    private func configureLayout() {
        statusImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        quantityLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([

            // Status icon
            statusImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            statusImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            statusImageView.widthAnchor.constraint(equalToConstant: 20),
            statusImageView.heightAnchor.constraint(equalToConstant: 20),

            // Name
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            nameLabel.leadingAnchor.constraint(equalTo: statusImageView.trailingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            // Quantity
            quantityLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            quantityLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            quantityLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            quantityLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
}
