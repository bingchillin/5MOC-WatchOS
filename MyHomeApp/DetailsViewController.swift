//
//  DetailsViewController.swift
//  MyHomeApp
//
//  Created by Gabriel on 2/12/25.
//
import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var label_presence: UILabel!
    @IBOutlet weak var label_intrusion: UILabel!
    @IBOutlet weak var alarm_button: UIButton!
    
    // Timer pour le rechargement automatique des données
    var dataRefreshTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        
        setupAlarmButton()
        
        updateData()
        
        dataRefreshTimer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(updateData), userInfo: nil, repeats: true)
    }
    
    deinit {
        dataRefreshTimer?.invalidate()
    }
    
   
    private func setupNavigationBar() {
        // Bouton pour aller aux paramètres
        let settingsButton = UIBarButtonItem(image: UIImage(systemName: "gearshape"), style: .plain, target: self, action: #selector(goToSettings))
        settingsButton.tintColor = .black
        
        // Bouton pour aller à la liste des objets
        let objectListButton = UIBarButtonItem(image: UIImage(systemName: "list.bullet"), style: .plain, target: self, action: #selector(goToObjectList))
        objectListButton.tintColor = .black
        
        // Ajout des boutons dans la barre de navigation
        navigationItem.rightBarButtonItems = [settingsButton, objectListButton]
    }
    
    @objc func goToSettings() {
        let nextController = SettingsViewController()
        self.navigationController?.pushViewController(nextController, animated: true)
       }
       
       @objc func goToObjectList() {
           let nextController = ObjectsListViewController()
           self.navigationController?.pushViewController(nextController, animated: true)
       }
       
    
    @objc func updateData() {
        
        ObjectServices.getPresence { error, distance in
            DispatchQueue.main.async {
                if let error = error {
                    print("Erreur : \(error.localizedDescription)")
                } else if let distance = distance {
                    
                    
                      // Charger notre objet depuis le fichier
                    if let objetCharge = loadObjet() {
                         let ccl_presence = distance
                        
                         if ccl_presence <= Float(objetCharge.components[1].stock_parameter!)! && ccl_presence != 0 {
                             self.label_presence.text = "Presence detected !"
                             self.label_presence.textColor = .red
                             
                         }else {
                             self.label_presence.text = "NONE"
                             self.label_presence.textColor = .black
                         }
                         
                     } else {
                         print("Aucun objet trouvé.")
                         self.label_presence.text = "defective detector"
                     }
                    
                } else {
                    print("Aucune donnée reçue")
                }
            }
        }
        
        // Mise à jour de l'intrusion
        ObjectServices.getIntrusion { error, intrusion in
            DispatchQueue.main.async {
                if let error = error {
                    print("Erreur : \(error.localizedDescription)")
                } else if let intrusion = intrusion {
                    let ccl_intrusion = intrusion
                    if ccl_intrusion == 0 {
                        self.updateAlarmButtonState(0)
                        self.label_intrusion.text = "NONE"
                        self.label_intrusion.textColor = .black
                        self.alarm_button.backgroundColor = .green
                        self.alarm_button.setTitle("OFF", for: .normal)
                    } else {
                        self.updateAlarmButtonState(1)
                        self.label_intrusion.text = "ALARM ON !"
                        self.label_intrusion.textColor = .red
                        self.alarm_button.backgroundColor = .red
                        self.alarm_button.setTitle("ON", for: .normal)
                    }
                } else {
                    print("Aucune donnée reçue")
                }
            }
        }
    }

    // Fonction pour configurer le bouton alarme
    private func setupAlarmButton() {
        alarm_button.layer.cornerRadius = 50
    }
    
    // Mise à jour de l'état du bouton d'alarme en fonction de l'intrusion
    private func updateAlarmButtonState(_ intrusion: Int) {
        if intrusion == 1 {
            // Si l'alarme est activée, bouton rouge
            alarm_button.backgroundColor = .red
            alarm_button.setTitle("ON", for: .normal)
        } else {
            // Si l'alarme est désactivée, bouton vert
            alarm_button.backgroundColor = .green
            alarm_button.setTitle("OFF", for: .normal)
        }
    }
    
    // Action pour le bouton d'alarme
    @IBAction func handle_OnOff(_ sender: Any) {
        // Vérification de l'état actuel de l'alarme avant d'envoyer la requête
        ObjectServices.getIntrusion { error, intrusion in
            DispatchQueue.main.async {
                if let error = error {
                    print("Erreur : \(error.localizedDescription)")
                } else if let intrusion = intrusion {
                    if intrusion == 1 {
                        // Si l'alarme est activée => on l'éteint
                        ObjectServices.setAlarm(state: "off") { error, response in
                            DispatchQueue.main.async {
                                if error != nil {
                                    print("Erreur lors de la désactivation de l'alarme")
                                } else {
                                    self.updateAlarmButtonState(0)
                                }
                            }
                        }
                    } else {
                        // Si l'alarme est désactivée => on l'active
                        ObjectServices.setAlarm(state: "on") { error, response in
                            DispatchQueue.main.async {
                                if error != nil {
                                    print("Erreur lors de l'activation de l'alarme")
                                } else {
                                    self.updateAlarmButtonState(1)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
