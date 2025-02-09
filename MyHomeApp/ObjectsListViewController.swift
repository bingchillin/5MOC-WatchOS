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
    
    // MARK: - Sources de données
    
    /// Données statiques pré-remplies
    private var staticHomeItems: [HomeItem] = [
        HomeItem(name: "Maison Statique 1", source: .staticData, home: nil),
        HomeItem(name: "Maison Statique 2", source: .staticData, home: nil)
    ]
    
    /// Données issues de HomeKit
    private var homeKitHomeItems: [HomeItem] = []
    
    /// Tableau fusionné (les données statiques et HomeKit)
    private var allHomeItems: [HomeItem] {
        return staticHomeItems + homeKitHomeItems
    }
    
    // MARK: - UI
    
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
    
    // MARK: - HomeKit Manager
    
    private var homeManager: HMHomeManager?
    
    // MARK: - Vie du contrôleur
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Liste d'Objets"
        view.backgroundColor = .white
        
        // Configuration de la table view
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        view.addSubview(tableView)
        view.addSubview(emptyLabel)
        
        setupConstraints()
        updateUI()
        
        // Initialisation et configuration de HomeKit
        homeManager = HMHomeManager()
        homeManager?.delegate = self
    }
    
    // Mise en place des contraintes Auto Layout
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Table view occupe toute la vue
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Label centré dans la vue
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    // Met à jour l'interface en fonction du contenu
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

        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let item = allHomeItems[indexPath.row]
        cell.textLabel?.text = item.name
        return cell
    }
    
    // Par exemple, au clic, on pourra afficher des détails (à adapter)
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = allHomeItems[indexPath.row]
        print("Sélection de l'objet : \(selectedItem.name) provenant de \(selectedItem.source)")
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - HMHomeManagerDelegate

extension ObjectsListViewController: HMHomeManagerDelegate {
    func homeManagerDidUpdateHomes(_ manager: HMHomeManager) {
        // À chaque mise à jour, on récupère les maisons HomeKit et on les transforme en HomeItem
        homeKitHomeItems = manager.homes.map { home in
            return HomeItem(name: home.name, source: .homeKit, home: home)
        }
        updateUI()
    }
}
