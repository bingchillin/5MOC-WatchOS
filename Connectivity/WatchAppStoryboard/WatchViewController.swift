//
//  WatchViewController.swift
//  WatchAppStoryboard
//
//  Created by Benoit Briatte on 07/11/2024.
//

import UIKit
import WatchConnectivity

class WatchViewController: UIViewController {

    @IBOutlet weak var option1Switch: UISwitch!
    @IBOutlet weak var imageBloc: UIImageView!
    
    func reloadUsingContext() {
        if WCSession.isSupported() {
            let on = WCSession.default.receivedApplicationContext["option1"] as? Bool ?? false
            self.option1Switch.isOn = on
        } else {
            self.option1Switch.isOn = false
        }
    }
    
    func moveImage(direction: Int) {
        var rect = self.imageBloc.frame
        
        if direction == 0 {
            rect.origin.x -= 10
        } else if direction == 1 {
            rect.origin.x += 10
        } else if direction == 2 {
            rect.origin.y -= 10
        } else if direction == 3 {
            rect.origin.y += 10
        }
        UIView.animate(withDuration: 0.33) {
            // redraw la view dans le parent avec la nouvelle zone
            self.imageBloc.frame = rect
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reloadUsingContext()
    }


}
