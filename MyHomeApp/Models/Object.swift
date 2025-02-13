//
//  Object.swift
//  MyHomeApp
//
//  Created by Gabriel on 2/12/25.
//

import Foundation


class Object: CustomStringConvertible, Codable{
    let id: String
    var name: String
    var isFavorite: Bool
    var components: [Component]
    
    
    var description: String{
        return "name: \(name), isFavorite: \(isFavorite), components: \(components)"
    }
    
    init(id: String, name: String, isFavorite: Bool, components: [Component]) {
        self.id = id
        self.name = name
        self.isFavorite = isFavorite
        self.components = components
    }
}
