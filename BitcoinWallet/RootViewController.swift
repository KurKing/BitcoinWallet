//
//  RootViewController.swift
//  BitcoinWallet
//
//  Created by Oleksii on 21.08.2025.
//

import UIKit
import Combine

class RootViewController: UIViewController {
    
    // Imagine it is from VM and model
    @Dependency private var btcService: BitcoinRateService
    @Dependency private var transactionRepo: TransactionRepo
    @Dependency private var balanceService: BalanceService
    private var cancellables: Set<AnyCancellable> = []
    
    private var index = 0
    private let mocks = TransactionDataModel.mockTransactions
    
    private let fetchOffset = 0
    private let fetchLimit = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let btcLabel = UILabel()
        btcLabel.translatesAutoresizingMaskIntoConstraints = false
        btcLabel.font = .SF.font(size: 36, weight: .bold)
        btcLabel.textColor = .black
        btcLabel.isUserInteractionEnabled = true
        view.addSubview(btcLabel)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapBTCLabel))
        btcLabel.addGestureRecognizer(tap)
        
        let balanceLabel = UILabel()
        balanceLabel.translatesAutoresizingMaskIntoConstraints = false
        balanceLabel.font = .systemFont(ofSize: 24, weight: .medium)
        balanceLabel.textColor = .darkGray
        view.addSubview(balanceLabel)
        
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Add mock", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        button.addTarget(self, action: #selector(didTapAdd), for: .touchUpInside)
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            btcLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            btcLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            balanceLabel.topAnchor.constraint(equalTo: btcLabel.bottomAnchor, constant: 12),
            balanceLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            button.topAnchor.constraint(equalTo: balanceLabel.bottomAnchor, constant: 24),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        btcService.rate
            .removeDuplicates()
            .compactMap { $0 }
            .map { String(format: "%.4f", $0) }
            .map { "\($0)$" }
            .receive(on: RunLoop.main)
            .sink { [weak btcLabel] rate in
                
                guard let btcLabel else { return }
                
                UIView.transition(with: btcLabel,
                                  duration: 0.3,
                                  options: .transitionCrossDissolve) {
                    btcLabel.text = rate
                }
            }
            .store(in: &cancellables)
        
        balanceService.balance
            .removeDuplicates()
            .map { "Balance: \($0)" }
            .receive(on: RunLoop.main)
            .sink { [weak balanceLabel] balanceText in
                balanceLabel?.text = balanceText
            }
            .store(in: &cancellables)
    }
    
    @objc private func didTapAdd() {
        
        var balance: Decimal = 0
        
        for _ in (0...100) {
            
            let item = mocks.randomElement()!
            
            balance += item.amount
            
            Task.detached { [weak self] in
                try? await self?.transactionRepo.add(item)
//                print("✅ \(item.name) \(item.amount)")
            }
        }
        
        print("FINAL BALANCE: \(balance)")
    }
    
    @objc private func didTapBTCLabel() {
        Task {
            do {
                let list = try await transactionRepo.get(offset: fetchOffset, limit: fetchLimit)
                print("—— Transactions [offset: \(fetchOffset), limit: \(fetchLimit)] ——")
                list.enumerated().forEach { i, tx in
                    print("\(fetchOffset+i). \(tx.name) | \(tx.categoryName) | \(tx.amount) | \(tx.date)")
                }
                print("——————————————————————————————————————————————")
            } catch {
                print("❌ Fetch failed:", error)
            }
        }
    }
}
