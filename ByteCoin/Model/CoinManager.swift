//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation


protocol CoinManagerDelegate {
    func didFailWithError(_ coinManager: CoinManager, error: Error)
    
    func didUpdateCoinPrice(_ coinManager: CoinManager, coinPrice: CoinPrice)
}


struct CoinManager {
    
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    var delegate: CoinManagerDelegate?
    
    
    func getCoinPrice(for currency: String){
        let finalUrl = "\(baseURL)\(currency)"
        
        if let url = URL(string: finalUrl) {
            print(url)
            let urlSession = URLSession(configuration: .default)
            let task = urlSession.dataTask(with: url) { (data:Data?, urlResponse:URLResponse?, error:Error?) in
                if error != nil {
                    print(error!)
                    self.delegate?.didFailWithError(self, error: error!)
                    return
                }
                if let safeData = data {
                    if let coinInfo = self.parseJSON(safeData){
                        self.delegate?.didUpdateCoinPrice(self, coinPrice: CoinPrice(value: coinInfo.last, displaySymbol: coinInfo.display_symbol, currency: currency))
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ coinData: Data) -> CoinPriceData? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinPriceData.self, from: coinData)
            print(decodedData.last)
            print(decodedData.display_symbol)
            return decodedData
        } catch {
            print(error)
            self.delegate?.didFailWithError(self, error: error)
            return nil
        }
    }
}
