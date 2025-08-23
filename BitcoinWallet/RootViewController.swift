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
    private var cancellables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.backgroundColor = .cyan
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .SF.font(size: 36, weight: .bold)
        label.textColor = .black
        
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
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
}
