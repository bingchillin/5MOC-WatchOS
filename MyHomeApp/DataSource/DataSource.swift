//
//  DataSource.swift
//  MyHomeApp
//
//  Created by Mohamed El Fakharany on 09/02/2025.
//

import Foundation

import HomeKit

struct HomeItem {
    let id: UUID = UUID()
    
    let name: String
    let source: DataSourceType
    var isFavorite: Bool
    let home: HMHome?
    
    enum DataSourceType {
        case staticData
        case homeKit
    }
}
