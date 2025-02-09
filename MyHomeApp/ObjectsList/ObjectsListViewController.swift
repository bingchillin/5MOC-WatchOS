//
//  ObjectsListViewController.swift
//  MyHomeApp
//
//  Created by Mohamed El Fakharany on 09/02/2025.
//

import Foundation
import UIKit
import HomeKit

class ObjectsListViewController: UIViewController {
    
    // Sources de données
    private var staticHomeItems: [HomeItem] = [
        HomeItem(name: "Maison Statique 1", source: .staticData, isFavorite: false, home: nil),
        HomeItem(name: "Maison Statique 2", source: .staticData, isFavorite: false, home: nil)
    ]
    
    private var homeKitHomeItems: [HomeItem] = []
    
    /// On fusionne les deux tableaux et on trie pour afficher les favoris en premier
    private var allHomeItems: [HomeItem] {
        let items = staticHomeItems + homeKitHomeItems
        return items.sorted {
            if $0.isFavorite != $1.isFavorite {
                return $0.isFavorite && !$1.isFavorite
            } else {
                return $0.name < $1.name
            }
        }
    }
    
    // Interface
    private let tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "Aucun élément"
        label.textAlignment = .center
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // HomeKit Manager
    private var homeManager: HMHomeManager?
    
    // MARK: - Cycle de vie
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Liste d'Objets"
        view.backgroundColor = .white
        
        // Configuration de la table view
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ObjectTableViewCell.self, forCellReuseIdentifier: ObjectTableViewCell.identifier)
        
        view.addSubview(tableView)
        view.addSubview(emptyLabel)
        setupConstraints()
        updateUI()
        
        // Initialisation de HomeKit
        homeManager = HMHomeManager()
        homeManager?.delegate = self
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // La table view occupe toute la vue
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Le label vide est centré
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    /// Met à jour l'affichage : si aucun élément n'existe, on affiche le label vide, sinon la table view.
    private func updateUI() {
        if allHomeItems.isEmpty {
            tableView.isHidden = true
            emptyLabel.isHidden = false
        } else {
            tableView.isHidden = false
            emptyLabel.isHidden = true
            tableView.reloadData()
        }
    }
}

// MARK: - UITableViewDataSource & Delegate
extension ObjectsListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allHomeItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: ObjectTableViewCell.identifier, for: indexPath) as? ObjectTableViewCell else {
            return UITableViewCell()
        }
        let item = allHomeItems[indexPath.row]
        cell.configure(with: item)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = allHomeItems[indexPath.row]
        print("Sélection de l'objet : \(selectedItem.name) (Source: \(selectedItem.source))")
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - ObjectTableViewCellDelegate
extension ObjectsListViewController: ObjectTableViewCellDelegate {
    func didTapFavoriteButton(for cell: ObjectTableViewCell) {
        guard let item = cell.item else { return }
        
        // Selon la source, on trouve l'index de l'objet dans le tableau correspondant et on toggle son statut
        if item.source == .staticData {
            if let index = staticHomeItems.firstIndex(where: { $0.id == item.id }) {
                staticHomeItems[index].isFavorite.toggle()
            }
        } else if item.source == .homeKit {
            if let index = homeKitHomeItems.firstIndex(where: { $0.id == item.id }) {
                homeKitHomeItems[index].isFavorite.toggle()
            }
        }
        updateUI() // On met à jour l'affichage (le tri dans allHomeItems fera remonter les favoris)
    }
}

// MARK: - HMHomeManagerDelegate
extension ObjectsListViewController: HMHomeManagerDelegate {
    func homeManagerDidUpdateHomes(_ manager: HMHomeManager) {
        // Mise à jour des données HomeKit
        homeKitHomeItems = manager.homes.map { home in
            // Par défaut, on initialise isFavorite à false.
            return HomeItem(name: home.name, source: .homeKit, isFavorite: false, home: home)
        }
        updateUI()
    }
}
