//
//  component.swift
//  MyHomeApp
//
//  Created by Gabriel on 2/12/25.
//

import Foundation

class Component: CustomStringConvertible, Codable{
    let id: String
    var name: String
    var return_int: Int?
    var return_float: Float?
    var return_string: String?
    var stock_parameter: String?
    var id_object: String?
    
    var description: String{
        return "name: \(name)"
    }
    
    init(id: String, name: String, return_int: Int?, return_float: Float?, return_string: String?, stock_parameter: String?, id_object: String) {
        self.id = id
        self.name = name
        self.return_int = return_int
        self.return_float = return_float
        self.return_string = return_string
        self.stock_parameter = stock_parameter
        self.id_object = id_object
    }
}
