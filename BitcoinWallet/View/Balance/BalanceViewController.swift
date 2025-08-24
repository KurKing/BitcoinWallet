//
//  BalanceViewController.swift
//  BitcoinWallet
//
//  Created by Oleksii on 24.08.2025.
//

import UIKit
import Combine

class BalanceViewController: UIViewController {
    
    private let viewModel: BalanceViewViewModel
    private var cancellables: Set<AnyCancellable> = []
    
    private var balanceLabel = UILabel()
    
    init(viewModel: BalanceViewViewModel = DefaultBalanceViewViewModel()) {
        
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.backgroundColor = .clear
  
        balanceLabel.translatesAutoresizingMaskIntoConstraints = false
        balanceLabel.font = .SF.font(size: 32, weight: .medium)
        balanceLabel.textColor = .black
        balanceLabel.textAlignment = .center
        
        view.addSubview(balanceLabel)
        
        NSLayoutConstraint.activate([
            
            balanceLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            balanceLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            balanceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                  constant: 14),
            balanceLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                   constant: -14)
        ])
        
        bindViewModel()
    }

    private func bindViewModel() {
        
        viewModel.balance
            .throttle(for: .seconds(1), scheduler: RunLoop.main, latest: true)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] balance in
                self?.balanceLabel.text = balance
            }
            .store(in: &cancellables)
    }
}
