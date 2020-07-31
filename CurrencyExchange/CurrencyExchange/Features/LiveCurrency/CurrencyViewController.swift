//
//  CurrencyViewController.swift
//  CurrencyExchange
//
//  Created by wenyu zhao on 2020/7/29.
//  Copyright © 2020 Ryan zhao. All rights reserved.
//

import UIKit

class CurrencyViewController: UIViewController, Bindable {

    var viewModel: CurrencyViewModelType?
    
    @IBOutlet var quoteCurrencyButton: UIButton!
    @IBOutlet var currencyNumberTextField: UITextField!
    @IBOutlet var tableView: UITableView!
    
    static func instantiate(_ viewModel: CurrencyViewModelType) -> CurrencyViewController {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyBoard.instantiateViewController(withIdentifier: "Currency") as? CurrencyViewController else {
            fatalError()
        }
        
        vc.bind(to: viewModel)
        viewModel.viewModelObserver = vc
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        currencyNumberTextField.delegate = self
        currencyNumberTextField.addTarget(self, action: #selector(self.editingChanged), for: .editingChanged)
        viewModel?.fetchLiveCurrencyRate()
    }
    
    @IBAction func quoteCurrencyButton(sender: Any) {
        let listViewModel = ListViewModel()
        let listViewController = ListViewController.instantiate(listViewModel)
        present(listViewController, animated: true)
    }
    
    func updateQuoteButtonText(_ text: String?) {
        quoteCurrencyButton.setTitle(text, for: .normal)
        quoteCurrencyButton.setTitle(text, for: .highlighted)
        if let symbol = text?.suffix(3) {
            viewModel?.baseCurrency = String(symbol)
        }
    }
    
    @objc func editingChanged() {
        
    }
}

extension CurrencyViewController: UITextFieldDelegate {
    
}

extension CurrencyViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.currencyList.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "currencyCell", for: indexPath) as? CurrencyCell else {
            return UITableViewCell()
        }
        
        guard let currencySymbol = viewModel?.currencyList[indexPath.row], let rate = viewModel?.rateMap[currencySymbol] else {
            return UITableViewCell()
        }
        
        guard let text = currencyNumberTextField.text, !text.isEmpty else {
            cell.configureCell(currencySymbol: currencySymbol,
                               currencyNumber: viewModel?.calculateCovertedNumber(currentNumber: currencyNumberTextField.placeholder ?? "100.0", convertedCurrency: currencySymbol),
            currencyRate: String(describing: rate))
            return cell
        }
        
        cell.configureCell(currencySymbol: currencySymbol,
                           currencyNumber: viewModel?.calculateCovertedNumber(currentNumber: text, convertedCurrency: currencySymbol),
                           currencyRate: String(describing: rate))
        return cell
    }
}

extension CurrencyViewController: UITableViewDelegate {
    
}

extension CurrencyViewController: ViewModelObserver {
    func viewModelUpdated(_ viewModel: ViewModelObservable) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
