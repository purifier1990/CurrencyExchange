//
//  ListCell.swift
//  CurrencyExchange
//
//  Created by wenyu zhao on 2020/7/30.
//  Copyright © 2020 Ryan zhao. All rights reserved.
//

import UIKit

class ListCell: UITableViewCell {
    @IBOutlet var currencyLabel: UILabel!
    
    func configureCell(currency: String?) {
        currencyLabel.text = currency
    }
}
