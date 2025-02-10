//
//  ObjectDetailsViewController.swift
//  MyHomeApp
//
//  Created by Mohamed El Fakharany on 10/02/2025.
//

import Foundation
import UIKit

class ObjectDetailsViewController: UIViewController {

    // L'objet dont on affiche et modifie les détails
    var homeItem: HomeItem!
    
    // MARK: - UI Components
    
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 16
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    // Champ Nom
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Nom"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private let nameTextField: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .roundedRect
        tf.placeholder = "Entrez le nom"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    // Champ Capteur de pression
    private let pressureLabel: UILabel = {
        let label = UILabel()
        label.text = "Capteur de pression"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private let pressureTextField: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .roundedRect
        tf.placeholder = "Entrez la valeur (en hPa)"
        tf.keyboardType = .decimalPad
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    // Champ Alarme (interrupteur)
    private let alarmLabel: UILabel = {
        let label = UILabel()
        label.text = "Alarme"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private let alarmSwitch: UISwitch = {
        let sw = UISwitch()
        sw.translatesAutoresizingMaskIntoConstraints = false
        return sw
    }()
    
    // MARK: - Cycle de vie
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Détails de l'objet"
        view.backgroundColor = .white
        
        setupNavigationBar()
        setupUI()
        populateData()
    }
    
    private func setupNavigationBar() {
        // Ajout d'un bouton "Enregistrer" pour sauvegarder les modifications
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Enregistrer", style: .done, target: self, action: #selector(saveButtonTapped))
    }
    
    private func setupUI() {
        // Ajout du scroll view et de son content view
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // Contraintes du scroll view
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // Contraintes du content view (pour permettre un défilement vertical)
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        // Ajout du stack view dans le content view
        contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -20)
        ])
        
        // Ajout des champs dans le stack view
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(nameTextField)
        
        stackView.addArrangedSubview(pressureLabel)
        stackView.addArrangedSubview(pressureTextField)
        
        // Pour l'alarme, nous créons une vue horizontale (stack) pour aligner le label et le switch
        let alarmContainer = UIStackView()
        alarmContainer.axis = .horizontal
        alarmContainer.spacing = 16
        alarmContainer.alignment = .center
        alarmContainer.translatesAutoresizingMaskIntoConstraints = false
        alarmContainer.addArrangedSubview(alarmLabel)
        alarmContainer.addArrangedSubview(alarmSwitch)
        
        stackView.addArrangedSubview(alarmContainer)
    }
    
    private func populateData() {
        // Remplissage des champs avec les données actuelles de homeItem
        nameTextField.text = homeItem.name
        pressureTextField.text = "\(homeItem.pressure)"
        alarmSwitch.isOn = homeItem.isAlarmOn
    }
    
    // MARK: - Sauvegarde
    
    @objc private func saveButtonTapped() {
        // Vérifier que le nom n'est pas vide
        guard let name = nameTextField.text, !name.isEmpty else {
            showAlert(message: "Le nom ne peut pas être vide.")
            return
        }
        // Vérifier que le champ pression contient bien une valeur numérique
        guard let pressureText = pressureTextField.text, let pressureValue = Double(pressureText) else {
            showAlert(message: "Veuillez entrer une valeur numérique pour le capteur de pression.")
            return
        }
        
        // Mise à jour de l'objet (en mémoire)
        homeItem.name = name
        homeItem.pressure = pressureValue
        homeItem.isAlarmOn = alarmSwitch.isOn
        
        // Pour notre exemple en mémoire, on peut simplement revenir à la page précédente.
        // Si besoin, vous pouvez également informer le contrôleur appelant des modifications.
        navigationController?.popViewController(animated: true)
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Erreur", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
}
