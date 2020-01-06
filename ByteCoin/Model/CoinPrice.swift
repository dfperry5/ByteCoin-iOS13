//
//  CoinPrice.swift
//  ByteCoin
//
//  Created by Dylan Perry on 1/5/20.
//  Copyright © 2020 The App Brewery. All rights reserved.
//

import Foundation

struct CoinPrice {
    let value: Double
    let displaySymbol: String
    let currency: String
    var formattedCurrencyString: String {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.locale = Locale.current
        currencyFormatter.numberStyle = .currency
        currencyFormatter.usesGroupingSeparator = true
        
        return currencyFormatter.string(from: NSNumber(value: value))!
    }
}
