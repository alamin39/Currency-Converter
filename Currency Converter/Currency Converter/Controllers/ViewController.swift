//
//  ViewController.swift
//  Currency Converter
//
//  Created by Al-Amin on 13/6/22.
//

import UIKit
import iOSDropDown

/*
 It only works for USD because of free API account.
 */

class ViewController: UIViewController {
    
    @IBOutlet weak var userInputTextField: UITextField!
    @IBOutlet weak var dropDown: DropDown!
    @IBOutlet weak var currencyCollectionView: UICollectionView!
    
    var currencies: [String : Double] = [:]
    private var currencyNames: [String] = []
    private var currencyValues: [Double] = []
    private var givenAmount: Double = 0.0
    private var givenCurrency: String = "USD"
    private let allCurrency = ["TZS","BTC","KGS","UAH","CRC","GMD","FJD","JOD","BAM","VND","GYD","XOF","ARS","MAD","SVC","NZD","UZS","IQD","CAD","LKR","CHF","KZT","IRR","UGX","THB","PAB","MNT","TTD","GNF","BYN","GGP","MKD","DOP","TMT","XAU","BIF","MXN","GHS","SRD","QAR","PLN","ALL","RUB","RON","DZD","KMF","ETB","CUP","JMD","RWF","BDT","AFN","BBD","LAK","AZN","GTQ","ZAR","LSL","COP","KRW","STD","NIO","AED","LRD","BZD","SDG","KHR","XCD","XPT","PGK","RSD","CUC","BHD","FKP","MRU","MWK","PYG","AMD","ISK","MGA","SSP","AOA","MMK","SAR","ANG","BND","VUV","SCR","BMD","XPD","TWD","ILS","BTN","IDR","MZN","BGN","CNH","EUR","INR","TOP","BOB","UYU","PKR","MYR","GIP","NAD","CLP","MVR","KYD","CVE","CLF","GEL","BRL","PHP","XAG","SGD","MDL","TND","HTG","KWD","SBD","SYP","ERN","LYD","JPY","GBP","IMP","XPF","CNY","VES","AWG","JEP","ZMW","BWP","LBP","HKD","HRK","SOS","MOP","SLL","TJS","NGN","DJF","SEK","HNL","HUF","XAF","SHP","BSD","ZWL","AUD","DKK","NOK","OMR","PEN","CZK","NPR","CDF","SZL","WST","MUR","XDR","KES","KPW","STN","YER","EGP","USD","TRY"]
    
    let columnLayout = ColumnFlowLayout(
        cellsPerRow: 3,
        minimumInteritemSpacing: 8,
        minimumLineSpacing: 8,
        sectionInset: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userInputTextField.delegate = self
        setupCollectionView()
        setupDropDown()
    }
    
    private func setupDropDown() {
        dropDown.optionArray = allCurrency
        dropDown.didSelect { [weak self] (selectedText, index, id) in
            self?.givenCurrency = selectedText
            self?.dropDown.text = selectedText
            self?.serviceCall()
        }
    }
    
    private func fetchData() {
        NetworkManager().fetchCurrencyRates(base: givenCurrency, completionHandler: { [weak self] currencies in
            self?.currencies = currencies
            self?.currencyNames = (currencies as NSDictionary).allKeys as! [String]
            self?.currencyValues = (currencies as NSDictionary).allValues as! [Double]
            DispatchQueue.main.async {
                self?.currencyCollectionView.reloadData()
            }
        })
    }
    
    private func setupCollectionView() {
        currencyCollectionView.collectionViewLayout = columnLayout
        currencyCollectionView.contentInsetAdjustmentBehavior = .always
        currencyCollectionView.register(CollectionViewCell.nib(), forCellWithReuseIdentifier: CollectionViewCell.cellIdentifier)
        currencyCollectionView.delegate = self
        currencyCollectionView.dataSource = self
    }
    
    private func saveLastServiceCalledDate() {
        UserDefaults.standard.set(Date(), forKey: "lastServiceCallDate")
    }
    
    private func isCalledInLast30Min() -> Bool {
        guard let lastDate = UserDefaults.standard.value(forKey: "lastServiceCallDate") as? Date else {
            return false
        }
        let timeElapsed: Int = Int(Date().timeIntervalSince(lastDate))
        return timeElapsed < 30 * 60 // 30 minutes
    }
    
    private func serviceCall() {
        if isCalledInLast30Min() {
            return
        }
        saveLastServiceCalledDate()
        fetchData()
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currencies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.cellIdentifier, for: indexPath) as! CollectionViewCell
        cell.backgroundColor = .cyan
        cell.configure(with: currencyNames[indexPath.row], val: currencyValues[indexPath.row] * givenAmount)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let text: String? = textField.text
        if let text = text {
            givenAmount = Double(text)!
        }
    }
}
