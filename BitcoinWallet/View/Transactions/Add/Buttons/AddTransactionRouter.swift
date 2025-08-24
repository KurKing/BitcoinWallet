//
//  AddTransactionRouter.swift
//  BitcoinWallet
//
//  Created by Oleksii on 24.08.2025.
//

import UIKit

class AddTransactionRouter {
    
    @Dependency private var analyticsService: AnalyticsService
    
    func routeToAddTransaction(context: UIViewController) {
        
        analyticsService.track(event: .transactionIntention, parameters: [
            "source": "add_screen"
        ])
        
        context.present(AddTransactionViewController(), animated: true)
    }
    
    func requestDepositAmount(context: UIViewController,
                              with completion: ((String) -> ())?) {
        
        analyticsService.track(event: .transactionIntention, parameters: [
            "source": "deposit_alert"
        ])
        
        let alert = UIAlertController(title: "Deposit",
                                      message: "Enter amount in BTC",
                                      preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "0.0"
            textField.keyboardType = .decimalPad
        }
        
        let confirmAction = UIAlertAction(title: "OK", style: .default) { _ in
            
            if let text = alert.textFields?.first?.text, !text.isEmpty {
                completion?(text)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        
        context.present(alert, animated: true, completion: nil)
    }
}
