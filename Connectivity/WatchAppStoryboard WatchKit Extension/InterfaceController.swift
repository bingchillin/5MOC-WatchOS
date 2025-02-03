//
//  InterfaceController.swift
//  WatchAppStoryboard WatchKit Extension
//
//  Created by Elsa on 08/01/2024.
//

import WatchKit
import WatchConnectivity
import Foundation


class InterfaceController: WKInterfaceController {
    
    @IBOutlet weak var option1Switch: WKInterfaceSwitch!
    
    override func awake(withContext context: Any?) {
        // Configure interface objects here.
    }
    
    override func willActivate() {
        if WCSession.isSupported() {
            let on = WCSession.default.applicationContext["option1"] as? Bool ?? false
            self.option1Switch.setOn(on)
        } else {
            self.option1Switch.setEnabled(false)
        }
    }
    
    @IBAction func handleOption1Changed(_ value: Bool) {
        do {
            try WCSession.default.updateApplicationContext([
                "option1": value
            ])
        } catch {
            self.option1Switch.setOn(!value)
        }
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
    }
    
    
    @IBAction func touchLeft() {
        let session = WCSession.default
        if session.isReachable {
            session.sendMessage([
                "action": "-"
            ]) { reply in
                print(reply)
            }
        }
    }
     
    
    @IBAction func touchRight() {
        let session = WCSession.default
        if session.isReachable {
            session.sendMessage([
                "action": "+"
            ]) { reply in
                print(reply)
            }
        }
    }
}
