//
//  Drink.swift
//  CocktailApp
//
//  Created by Денис Андриевский on 09.09.2020.
//  Copyright © 2020 Денис Андриевский. All rights reserved.
//

import Foundation

struct Drinks: Codable {
    var drinks: [DrinkObject]
}

struct DrinkObject: Codable {
    var strDrink: String
    var strDrinkThumb: String
}

struct Drink {
    var name: String
    var imageURLString: String
    
    init(object: DrinkObject) {
        self.name = object.strDrink
        self.imageURLString = object.strDrinkThumb
    }
}
