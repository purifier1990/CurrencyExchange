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
        
        configureTableView()
        configureCurrencyInputField()
        configureAPIRereashTimer()
        configureView()
        viewModel?.fetchLiveCurrencyRate()
    }
    
    fileprivate func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    fileprivate func configureCurrencyInputField() {
        currencyNumberTextField.delegate = self
        currencyNumberTextField.addTarget(self, action: #selector(self.editingChanged), for: .editingChanged)
    }
    
    fileprivate func configureAPIRereashTimer() {
        let timerTask = Timer(timeInterval: 60 * 30,
                              target: self,
                              selector: #selector(self.fetchLiveCurrencyRate),
                              userInfo: nil,
                              repeats: true)
        RunLoop.main.add(timerTask, forMode: .common)
    }
    
    fileprivate func configureView() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard)))
    }
    
    @IBAction func quoteCurrencyButton(sender: Any) {
        let listViewModel = ListViewModel(Services())
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
    
    @objc func fetchLiveCurrencyRate() {
        viewModel?.fetchLiveCurrencyRate()
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
            
            if let error = self.viewModel?.hasError {
                if error {
                    self.viewModel?.hasError = false
                    let alertViewController = UIAlertController(title: Constans.genericErrorTitle, message: Constans.genericErrorMessage, preferredStyle: .alert)
                    alertViewController.addAction(UIAlertAction(title: Constans.okText, style: .cancel, handler: nil))
                    alertViewController.addAction(UIAlertAction(title: Constans.retryText, style: .default, handler: { (_) in
                        self.viewModel?.fetchLiveCurrencyRate()
                    }))
                    self.present(alertViewController, animated: true, completion: nil)
                }
            }
        }
    }
}
