//
//  ObjectTableViewCell.swift
//  MyHomeApp
//
//  Created by Mohamed El Fakharany on 09/02/2025.
//

import Foundation
import UIKit

protocol ObjectTableViewCellDelegate: AnyObject {
    func didTapFavoriteButton(for cell: ObjectTableViewCell)
}

class ObjectTableViewCell: UITableViewCell {
    
    static let identifier = "ObjectTableViewCell"
    
    weak var delegate: ObjectTableViewCellDelegate?
    
    private let nameLabel: UILabel = {
       let label = UILabel()
       label.translatesAutoresizingMaskIntoConstraints = false
       return label
    }()
    
    private let favoriteButton: UIButton = {
       let button = UIButton(type: .system)
       button.translatesAutoresizingMaskIntoConstraints = false
       return button
    }()
    
    /// On garde une référence de l’item affiché dans la cellule
    var item: HomeItem?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
       super.init(style: style, reuseIdentifier: reuseIdentifier)
       contentView.addSubview(nameLabel)
       contentView.addSubview(favoriteButton)
       
       // Contraintes
       NSLayoutConstraint.activate([
           nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
           nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
           
           favoriteButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
           favoriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
           favoriteButton.widthAnchor.constraint(equalToConstant: 32),
           favoriteButton.heightAnchor.constraint(equalToConstant: 32)
       ])
       
       // Action sur le bouton favori
       favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
    }
    
    @objc private func favoriteButtonTapped() {
       delegate?.didTapFavoriteButton(for: self)
    }
    
    required init?(coder: NSCoder) {
       fatalError("init(coder:) has not been implémenté")
    }
    
    /// Configure la cellule en fonction d’un HomeItem
    func configure(with item: HomeItem) {
       self.item = item
       nameLabel.text = item.name
       let imageName = item.isFavorite ? "star.fill" : "star"
       let image = UIImage(systemName: imageName)
       favoriteButton.setImage(image, for: .normal)
    }
}
