//
//  DataSource.swift
//  MyHomeApp
//
//  Created by Mohamed El Fakharany on 09/02/2025.
//

import Foundation

import HomeKit

struct HomeItem {
    let name: String
    let source: DataSourceType
    let home: HMHome?
    
    enum DataSourceType {
        case staticData
        case homeKit
    }
}
