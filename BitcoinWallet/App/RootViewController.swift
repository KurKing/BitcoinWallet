//
//  RootViewController.swift
//  BitcoinWallet
//
//  Created by Oleksii on 21.08.2025.
//

import UIKit
import Combine

class RootViewController: UIViewController {

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        title = "Wallet"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: BTCRateLabel())
        
        view.backgroundColor = UIColor(red: 240/255,
                                       green: 240/255,
                                       blue: 240/255,
                                       alpha: 1)
        
        let balanceView = setup(childViewController: BalanceViewController())
        
        NSLayoutConstraint.activate([
            
            balanceView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            balanceView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            balanceView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            balanceView.heightAnchor.constraint(equalToConstant: 60),
        ])
        
        let buttonsView = setup(childViewController:
                                    AddTransactionButtonsViewController())
        
        NSLayoutConstraint.activate([
            
            buttonsView.topAnchor.constraint(equalTo: balanceView.bottomAnchor),
            buttonsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            buttonsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            buttonsView.heightAnchor.constraint(equalToConstant: 60),
        ])
        
        let transactionsView = setup(childViewController: TransactionsViewController())

        NSLayoutConstraint.activate([
            
            transactionsView.topAnchor.constraint(equalTo: buttonsView.bottomAnchor),
            transactionsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            transactionsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            transactionsView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func setup(childViewController: UIViewController) -> UIView {
        
        addChild(childViewController)
        childViewController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(childViewController.view)
        childViewController.didMove(toParent: self)
        
        return childViewController.view
    }
}
