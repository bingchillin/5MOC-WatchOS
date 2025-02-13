//
//  HomeViewController.swift
//  MyHomeApp
//
//  Created by KMG ;).
//

import UIKit
import HomeKit

class HomeViewController: UIViewController {

    @IBOutlet weak var homeTableView: UITableView!
    var homeManager: HMHomeManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "HomeApp"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(handleSearchAccessory))
        self.homeManager = HMHomeManager()
        self.homeManager.delegate = self
        self.homeTableView.delegate = self
        self.homeTableView.dataSource = self
    }

    @objc func handleSearchAccessory() {
        let searchController = SearchAccessoryViewController()
        searchController.delegate = self
        self.navigationController?.pushViewController(searchController, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.homeTableView.reloadData()
    }
}

extension HomeViewController: HMHomeManagerDelegate {
    func homeManagerDidUpdateHomes(_ manager: HMHomeManager) {
        self.homeTableView.reloadData()
    }
}

extension HomeViewController: SearchAccessoryViewControllerDelegate {
    func searchAccessoryViewController(_ searchAccessoryViewController: SearchAccessoryViewController, didSelectAccessory accessory: HMAccessory) {
        if self.homeManager.homes.count > 0 {
            self.selectHomeForAccessory(accessory)
        } else {
            self.alertNewHomeForAccessory(accessory)
        }
    }
    
    func homeAddAccessory(_ home: HMHome, accessory: HMAccessory) {
        home.addAccessory(accessory) { err in
            print(err)
        }
    }
    
    func alertNewHomeForAccessory(_ accessory: HMAccessory) {
        let alert = UIAlertController(title: "Nouvelle maison", message: "Ecrire le nom de votre maison", preferredStyle: .alert)
        alert.addTextField { field in
            field.placeholder = "Nom*"
        }
        alert.addAction(UIAlertAction(title: "Annuler", style: .cancel))
        alert.addAction(UIAlertAction(title: "Valider", style: .default, handler: { _ in
            self.homeManager.addHome(withName: alert.textFields![0].text!) { home, err in
                if let h = home {
                    self.homeAddAccessory(h, accessory: accessory)
                }
            }
        }))
        self.navigationController?.visibleViewController?.present(alert, animated: true)
    }
    
    func selectHomeForAccessory(_ accessory: HMAccessory) {
        let actionSheet = UIAlertController(title: "Selection de maison", message: "Choisir votre maison", preferredStyle: .actionSheet)
        self.homeManager.homes.forEach { home in
            actionSheet.addAction(UIAlertAction(title: home.name, style: .default, handler: { _ in
                self.homeAddAccessory(home, accessory: accessory)
            }))
        }
        actionSheet.addAction(UIAlertAction(title: "Ajouter une nouvelle", style: .default, handler: { _ in
            self.alertNewHomeForAccessory(accessory);
        }))
        actionSheet.addAction(UIAlertAction(title: "Annuler", style: .cancel))
        self.navigationController?.visibleViewController?.present(actionSheet, animated: true)
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.homeManager.homes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HOME") ?? UITableViewCell(style: .default, reuseIdentifier: "HOME")
        cell.textLabel?.text = self.homeManager.homes[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let home = self.homeManager.homes[indexPath.row]
        let accessoryList = AccessoryListViewController.newInstance(home: home)
        self.navigationController?.pushViewController(accessoryList, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
         
            let home = self.homeManager.homes[indexPath.row]
            let alert = UIAlertController(title: "Suppression de \(home.name)", message: "Etes vous sur ?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Supprimer", style: .destructive, handler: { _ in
                self.homeManager.removeHome(home) { err in
                    self.homeTableView.reloadData()
                }
            }))
            alert.addAction(UIAlertAction(title: "Annuler", style: .cancel))
            self.present(alert, animated: true)
        }
        
    }
}
