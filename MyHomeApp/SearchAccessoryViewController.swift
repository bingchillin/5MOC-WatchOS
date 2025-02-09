//
//  SearchAccessoryViewController.swift
//  MyHomeApp
//
//  Created by Benoit Briatte on 10/01/2025.
//

import UIKit
import HomeKit

protocol SearchAccessoryViewControllerDelegate: AnyObject {
     func searchAccessoryViewController(_ searchAccessoryViewController: SearchAccessoryViewController, didSelectAccessory accessory: HMAccessory)
}

class SearchAccessoryViewController: UIViewController {

    @IBOutlet weak var searchTableView: UITableView!
    var accessoryBrowser: HMAccessoryBrowser!
    weak var delegate: SearchAccessoryViewControllerDelegate?
    var accessories: [HMAccessory] = [] {
        didSet {
            self.searchTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchTableView.delegate = self
        self.searchTableView.dataSource = self
        self.accessoryBrowser = HMAccessoryBrowser()
        self.accessoryBrowser.delegate = self
        // lance la recherche des accessoires autour de l'iphone
        self.accessoryBrowser.startSearchingForNewAccessories()
    }
}

extension SearchAccessoryViewController: HMAccessoryBrowserDelegate {
    
    func accessoryBrowser(_ browser: HMAccessoryBrowser, didFindNewAccessory accessory: HMAccessory) {
        self.accessories.append(accessory)
    }
    
    func accessoryBrowser(_ browser: HMAccessoryBrowser, didRemoveNewAccessory accessory: HMAccessory) {
        let index = self.accessories.firstIndex { acc in
            return acc.uniqueIdentifier == accessory.uniqueIdentifier
        }
        if let accIndex = index {
            self.accessories.remove(at: accIndex)
        }
    }
}

extension SearchAccessoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.accessories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ACC") ?? UITableViewCell(style: .default, reuseIdentifier: "ACC")
        cell.textLabel?.text = self.accessories[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let acc = self.accessories[indexPath.row]
        self.delegate?.searchAccessoryViewController(self, didSelectAccessory: acc)
    }
    
}
