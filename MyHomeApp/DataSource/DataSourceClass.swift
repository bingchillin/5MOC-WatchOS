//
//  DataSource.swift
//  MyHomeApp
//
//  Created by Mohamed El Fakharany on 09/02/2025.
//

import HomeKit

class HomeItem {
    let id: UUID = UUID()
    var name: String
    let source: DataSourceType
    var isFavorite: Bool
    let home: HMHome?
    
    // Nouvelles propriétés pour la page Détails
    var pressure: Double
    var isAlarmOn: Bool
    
    init(name: String, source: DataSourceType, isFavorite: Bool, home: HMHome?, pressure: Double, isAlarmOn: Bool) {
        self.name = name
        self.source = source
        self.isFavorite = isFavorite
        self.home = home
        self.pressure = pressure
        self.isAlarmOn = isAlarmOn
    }
    
    enum DataSourceType {
        case staticData
        case homeKit
    }
}
