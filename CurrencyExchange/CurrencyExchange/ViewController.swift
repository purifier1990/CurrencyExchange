//
//  ViewController.swift
//  CurrencyExchange
//
//  Created by wenyu zhao on 2020/7/29.
//  Copyright © 2020 Ryan zhao. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        Services().supportedCurrencies { (result) in
            switch result {
            case .success(let s):
                print(s)
            case .failure(let e):
                print(e)
            }
        }
    }


}

