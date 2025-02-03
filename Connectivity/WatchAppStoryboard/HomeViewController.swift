//
//  HomeViewController.swift
//  WatchAppStoryboard
//
//  Created by Benoit Briatte on 07/11/2024.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func handleWatch(_ sender: Any) {
        let controller = WatchViewController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
