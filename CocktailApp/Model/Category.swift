//
//  Filter.swift
//  CocktailApp
//
//  Created by Денис Андриевский on 08.09.2020.
//  Copyright © 2020 Денис Андриевский. All rights reserved.
//

import Foundation

struct Categories: Codable {
    var drinks: [CategoryObject]
}

struct CategoryObject: Codable {
    var strCategory: String
}

struct Category {
    var name: String
    var isSelected: Bool
    
    init(object: CategoryObject) {
        self.name = object.strCategory
        self.isSelected = true
    }
}
