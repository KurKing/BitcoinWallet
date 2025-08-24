//
//  AddTransactionRouter.swift
//  BitcoinWallet
//
//  Created by Oleksii on 24.08.2025.
//

import UIKit

class AddTransactionRouter {
    
    func routeToAddTransaction(context: UIViewController) {
        
    }
    
    func requestDepositAmount(context: UIViewController,
                              with completion: ((String) -> ())?) {
        
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
