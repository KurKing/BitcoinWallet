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
    private var cancellables: Set<AnyCancellable> = []
    
    private var index = 0
    private let mocks = TransactionDataModel.mockTransactions
    
    private let fetchOffset = 0
    private let fetchLimit = 5
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .SF.font(size: 36, weight: .bold)
        label.textColor = .black
        label.isUserInteractionEnabled = true
        
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapBTCLabel))
        label.addGestureRecognizer(tap)
        
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Add mock", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        button.addTarget(self, action: #selector(didTapAdd), for: .touchUpInside)
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            button.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 24),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        btcService.rate
            .removeDuplicates()
            .compactMap { $0 }
            .map { String(format: "%.4f", $0) }
            .map { "\($0)$" }
            .receive(on: RunLoop.main)
            .sink { [weak label] rate in
                
                guard let label else { return }
                
                UIView.transition(with: label,
                                  duration: 0.3,
                                  options: .transitionCrossDissolve) {
                    label.text = rate
                }
            }
            .store(in: &cancellables)
    }
    
    @objc private func didTapAdd() {
        
        let item = mocks[index % mocks.count]
        index = (index + 1) % mocks.count
        
        Task {
            do {
                try await transactionRepo.add(item)
                print("✅ Added: \(item.name) \(item.amount) \(item.categoryName) @ \(item.date)")
            } catch {
                print("❌ Add failed:", error)
            }
        }
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
