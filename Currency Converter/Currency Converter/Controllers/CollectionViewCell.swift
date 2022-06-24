//
//  CollectionViewCell.swift
//  Currency Converter
//
//  Created by Al-Amin on 18/6/22.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var currencyName: UILabel!
    @IBOutlet weak var currencyValue: UILabel!
    
    static let cellIdentifier = "cell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func configure(with name: String, val: Double) {
        currencyName.text = name
        currencyValue.text = String(format: "%.2f", val)
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "CollectionViewCell", bundle: nil)
    }
}
