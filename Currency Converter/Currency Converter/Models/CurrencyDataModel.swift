//
//  Model.swift
//  Movie List
//
//  Created by Al-Amin on 18/6/22.
//

import Foundation

struct CurrencyInfo: Codable {
    var disclaimer: String
    var license: String
    var timestamp: Int64
    var base: String
    var rates: [String : Double]
}
