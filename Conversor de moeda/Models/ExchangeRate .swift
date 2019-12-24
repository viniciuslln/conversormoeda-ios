//
//  Currency.swift
//  Conversor de moeda
//
//  Created by vinicius dev on 23/12/19.
//  Copyright © 2019 vinicius dev. All rights reserved.
//

import Foundation

class ExchangeRate: Codable {
    let rates: [String: Double]
    let base, date: String

    init(rates: [String: Double], base: String, date: String) {
        self.rates = rates
        self.base = base
        self.date = date
    }
}
