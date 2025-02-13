//
//  DataObject.swift
//  MyHomeApp
//
//  Created by Gabriel on 2/13/25.
//

import Foundation

func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
}

// Sauvegarder un objet dans un fichier
func saveObjet(objet: Object) {
    let url = getDocumentsDirectory().appendingPathComponent("ObjectList.json")
    if let encoded = try? JSONEncoder().encode(objet) {
        try? encoded.write(to: url)
    }
}

// Charger un objet depuis un fichier
func loadObjet() -> Object? {
    let url = getDocumentsDirectory().appendingPathComponent("ObjectList.json")
    if let data = try? Data(contentsOf: url) {
        if let decodedObjet = try? JSONDecoder().decode(Object.self, from: data) {
            return decodedObjet
        }
    }
    return nil
}


