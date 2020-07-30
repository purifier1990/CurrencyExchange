//
//  CurrencyViewController.swift
//  CurrencyExchange
//
//  Created by wenyu zhao on 2020/7/29.
//  Copyright © 2020 Ryan zhao. All rights reserved.
//

import UIKit

class CurrencyViewController: UIViewController {

    var viewModel: CurrencyViewModelType?
    
    @IBOutlet var quoteCurrencyButton: UIbutton!
    @IBOutlet var currencyNumberTextField: UITextField!
    @IBOutlet var tableView: UITableView!
    
    static func instantiate(_ viewMode: CurrencyViewModelType) -> CurrencyViewController {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyBoard.instantiateViewController(withIdentifier: "Currency") as? CurrencyViewController else {
            fatalError()
        }
        
        vc.viewModel = viewMode
        return vc
    }
    
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
    
    @IBAction func quoteCurrencyButton(sender: any) {
        
    }
}

