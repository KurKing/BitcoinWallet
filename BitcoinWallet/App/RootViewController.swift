//
//  RootViewController.swift
//  BitcoinWallet
//
//  Created by Oleksii on 21.08.2025.
//

import UIKit
import Combine

class RootViewController: UIViewController {
    
    private var transactionsVC: TransactionsViewController!
    private var balanceVC: BalanceViewController!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        title = "Wallet"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        view.backgroundColor = UIColor(red: 240/255,
                                       green: 240/255,
                                       blue: 240/255,
                                       alpha: 1)
        
        balanceVC = BalanceViewController()
        let balanceView = setup(childViewController: balanceVC)
        
        NSLayoutConstraint.activate([
            
            balanceView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            balanceView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            balanceView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            balanceView.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        transactionsVC = TransactionsViewController()
        let transactionsView = setup(childViewController: transactionsVC)

        NSLayoutConstraint.activate([
            
            transactionsView.topAnchor.constraint(equalTo: balanceView.bottomAnchor),
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
