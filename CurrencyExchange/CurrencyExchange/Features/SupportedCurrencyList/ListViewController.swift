//
//  ListViewController.swift
//  CurrencyExchange
//
//  Created by wenyu zhao on 2020/7/30.
//  Copyright © 2020 Ryan zhao. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, Bindable {
    var viewModel: ListViewModelType?
    
    @IBOutlet var tableView: UITableView!
    
    static func instantiate(_ viewModel: ListViewModelType) -> ListViewController {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyBoard.instantiateViewController(withIdentifier: "List") as? ListViewController else {
            fatalError()
        }
        
        vc.bind(to: viewModel)
        viewModel.viewModelObserver = vc
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        viewModel?.fetchSupportedCurrencies()
    }
}

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.supportedCurrencies.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath) as? ListCell else {
            return UITableViewCell()
        }
        
        cell.configureCell(currency: viewModel?.supportedCurrencies[indexPath.row])
        return cell
    }
}

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let parentViewController = (presentingViewController as? UINavigationController)?.topViewController as? CurrencyViewController, let currencySymbol = viewModel?.supportedCurrencies[indexPath.row].prefix(3) {
            parentViewController.updateQuoteButtonText("\(Constans.quoteButtonText) \(currencySymbol)")
        }
        dismiss(animated: true, completion: nil)
    }
}

extension ListViewController: ViewModelObserver {
    func viewModelUpdated(_ viewModel: ViewModelObservable) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
