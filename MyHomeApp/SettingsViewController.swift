//
//  SettingsViewController.swift
//  MyHomeApp
//
//  Created by Gabriel on 2/13/25.
//

import UIKit

class SettingsViewController: UIViewController, UITextFieldDelegate {
    
    
    var choose_pressure: Int!
    @IBOutlet weak var textField_distance: UITextField!
    
    @IBOutlet weak var button_pression_sensible: UIButton!
    @IBOutlet weak var button_pression_hard: UIButton!
    @IBOutlet weak var button_validate: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField_distance.delegate = self
        
        setInformation()
    }

    private func setInformation() {
        // Charger notre objet depuis le fichier
        if let objetCharge = loadObjet() {
           textField_distance.text = objetCharge.components[1].stock_parameter
           
            if let parameter = objetCharge.components[2].stock_parameter, let pression = Int(parameter) {
                if pression <= 3000 {
                    button_pression_sensible.layer.cornerRadius = 25
                    button_pression_sensible.backgroundColor = .green
                    choose_pressure = 0
                } else {
                    button_pression_hard.layer.cornerRadius = 25
                    button_pression_hard.backgroundColor = .green
                    choose_pressure = 1
                }
            } else {
                print("Paramètre de pression non valide.")
            }

           
       } else {
           print("Aucun objet trouvé.")
       }
        
    }
    
    
    @IBAction func handle_sensible(_ sender: Any) {
        choose_pressure = 0
        updateButtonStyle(button: button_pression_sensible, isSelected: true)
        updateButtonStyle(button: button_pression_hard, isSelected: false)
    }
    
    @IBAction func handle_hard(_ sender: Any) {
        choose_pressure = 1
        updateButtonStyle(button: button_pression_sensible, isSelected: false)
        updateButtonStyle(button: button_pression_hard, isSelected: true)
    }
    
    
    
    private func updateButtonStyle(button: UIButton, isSelected: Bool) {
        button.layer.cornerRadius = 25
        button.backgroundColor = isSelected ? .green : .white
    }
    
    
    @IBAction func handle_validate(_ sender: Any) {
        let valid_number = changeDistanceMin()
        if valid_number == 0 {
            changePression()
            validate_popup(text_title: "Confirmation", text_mess: "The validation is okay !")
        }
            
       
    }
    
    func changeDistanceMin() -> Int {
        if let textfield = textField_distance.text, !textfield.isEmpty, isValidNumber(textfield) {
            if let objetCharge = loadObjet() {
                objetCharge.components[1].stock_parameter = textfield
                return 0
            } else {
                print("No object.")
            }
        } else {
            validate_popup(text_title: "Error", text_mess: "You must enter a  valid number !")
            return 1
        }
        return 3
    }
    

    func isValidNumber(_ text: String) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: text)
        return allowedCharacters.isSuperset(of: characterSet)
    }
    
    func changePression() {
        let choose_pressure_final = (choose_pressure == 0) ? 3000 : 3900
        
        ObjectServices.setPowerPression(pression: choose_pressure_final) { success, message in
            DispatchQueue.main.async {
                if success {
                    print("OK")
                } else {
                    print("KO")
                }
            }
        }
    }

    
    func validate_popup(text_title: String, text_mess: String){
        let alert = UIAlertController(title: text_title, message: text_mess , preferredStyle: .alert)
    
        let cancelAction = UIAlertAction(title: "Retour", style: .cancel, handler: nil)
        
        
        alert.addAction(cancelAction)
    
        present(alert, animated: true, completion: nil)
    }
   
    
    
    
}
