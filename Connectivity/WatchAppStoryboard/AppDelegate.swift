//
//  AppDelegate.swift
//  WatchAppStoryboard
//
//  Created by Elsa on 08/01/2024.
//

import UIKit
import WatchConnectivity

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = UINavigationController(rootViewController: HomeViewController())
        window.makeKeyAndVisible()
        self.window = window

        return true
    }
    
    // event lorsque lapp est en premier plan
    func applicationDidBecomeActive(_ application: UIApplication) {
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }
}

extension AppDelegate: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: (any Error)?) {
        print("SESSION ACTIVATION STATE \(activationState)")
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        DispatchQueue.main.async {
            guard let navigation = self.window?.rootViewController as? UINavigationController else {
                return
            }
            if let watchController = navigation.topViewController as? WatchViewController {
                watchController.reloadUsingContext()
            }
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String: Any],
                 replyHandler: @escaping ([String: Any]) -> Void) {
        DispatchQueue.main.async {
            guard let navigation = self.window?.rootViewController as? UINavigationController,
                  let watchController = navigation.topViewController as? WatchViewController,
                  let action = message["action"] as? String else {
                replyHandler(["success": 0])
                return
            }
            let direction = session.receivedApplicationContext["option1"] as? Bool ?? false
            if action == "-" {
                if direction {
                    watchController.moveImage(direction: 0)
                } else {
                    watchController.moveImage(direction: 3)
                }
            } else if action == "+" {
                if direction {
                    watchController.moveImage(direction: 1)
                } else {
                    watchController.moveImage(direction: 2)
                }
                
            }
        }
        print(message)
        replyHandler(["success": 1])
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("SESSION DID BECOME ACTIVE")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        print("SESSION DID DEACTIVE")
    }
}
