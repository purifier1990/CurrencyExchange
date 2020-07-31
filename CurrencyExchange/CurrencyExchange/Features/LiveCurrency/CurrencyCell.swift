//
//  CurrencyCell.swift
//  CurrencyExchange
//
//  Created by wenyu zhao on 2020/7/30.
//  Copyright © 2020 Ryan zhao. All rights reserved.
//

import UIKit

class CurrencyCell: UITableViewCell {
    @IBOutlet var currencyLabel: UILabel!
    @IBOutlet var currencyNumberLabel: UILabel!
    @IBOutlet var currencyRateLabel: UILabel!
    
    func configureCell(currencySymbol: String?, currencyNumber: String?, currencyRate: String?) {
        currencyLabel.text = currencySymbol
        currencyNumberLabel.text = currencyNumber
        currencyRateLabel.text = currencyRate
    }
}
