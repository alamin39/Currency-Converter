//
//  NetworkManager.swift
//  Currency Converter
//
//  Created by Al-Amin on 18/6/22.
//

import Foundation

final class NetworkManager: NSObject {
    
    private let appId = "fe4030fd00d748f692aea54cd102a2db"
    private let url = "https://openexchangerates.org/api/latest.json?app_id="
    var currencies: [String : Double] = [:]
    
    func fetchCurrencyRates(base: String, completionHandler: @escaping ([String : Double]) -> Void) {
        
        let url = URL(string: url + appId + "&base=" + base)! // only USD available for free account
        let urlSession = URLSession.shared
        
        let task = urlSession.dataTask(with: url, completionHandler: { (data, response, error) in
            guard error == nil else {
                NSLog("Error in fetching Currency Rates: \(String(describing: error))")
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                  (200...299).contains(response.statusCode) else {
                NSLog("Error in response, status code: \(String(describing: response))")
                return
            }
            
            if let data = data {
                do {
                    let currencyInfo = try JSONDecoder().decode(CurrencyInfo.self, from: data)
                    completionHandler(currencyInfo.rates)
                } catch {
                    NSLog(String(describing: error))
                }
            }
        })
        task.resume()
    }
}
