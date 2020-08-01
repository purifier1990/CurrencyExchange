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
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard)))
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
        if let text = currencyNumberTextField.text {
            if text.isEmpty {
                viewModel?.currentNumber = "100.0"
            } else {
                viewModel?.currentNumber = text
            }
        }
    }
    
    @objc func dismissKeyboard() {
        _ = currencyNumberTextField.resignFirstResponder()
    }
}

extension CurrencyViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
}

extension CurrencyViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.currencyCellModel.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "currencyCell", for: indexPath) as? CurrencyCell, let viewModel = viewModel else {
            return UITableViewCell()
        }
        
        cell.configureCell(currencySymbol: viewModel.currencyCellModel[indexPath.row].currencySymbol,
                           currencyNumber: viewModel.currencyCellModel[indexPath.row].currencyNumber,
                           currencyRate: viewModel.currencyCellModel[indexPath.row].currencyRate)
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
