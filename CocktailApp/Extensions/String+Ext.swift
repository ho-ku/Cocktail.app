//
//  String+Ext.swift
//  CocktailApp
//
//  Created by Денис Андриевский on 09.09.2020.
//  Copyright © 2020 Денис Андриевский. All rights reserved.
//

import Foundation

extension String {
    
    func removeSpacesInURL() -> String {
        var result = ""
        for char in self {
            if char != " " {
                result += String(char)
            } else {
                result += "%20"
            }
        }
        return result
    }
    
}
