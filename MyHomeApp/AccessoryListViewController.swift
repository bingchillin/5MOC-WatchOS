//
//  AccessoryListViewController.swift
//  MyHomeApp
//
//  Created by Benoit Briatte on 10/01/2025.
//

import UIKit
import HomeKit

class AccessoryListViewController: UIViewController {
   
    @IBOutlet weak var accessoryTableView: UITableView!
    var home: HMHome!
    var lightbulbAccessories: [HMAccessory] = []
    
    static func newInstance(home: HMHome) -> AccessoryListViewController {
        let controller = AccessoryListViewController()
        controller.home = home
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.home.name
        self.accessoryTableView.delegate = self
        self.accessoryTableView.dataSource = self
        self.lightbulbAccessories = self.home.accessories.filter { acc in
            let isLightbulb = acc.services.firstIndex { service in
                return service.serviceType == HMServiceTypeLightbulb
            }
            return isLightbulb != nil
        }
    }
       
}

extension AccessoryListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.lightbulbAccessories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ACC") ?? UITableViewCell(style: .default, reuseIdentifier: "ACC")
        cell.textLabel?.text = self.lightbulbAccessories[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let acc = self.lightbulbAccessories[indexPath.row]
        let lightbulbController = LightbulbViewController.newInstance(home: self.home, accessory: acc)
        self.navigationController?.pushViewController(lightbulbController, animated: true)
    }
    
}
