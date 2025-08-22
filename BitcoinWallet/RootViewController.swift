//
//  RootViewController.swift
//  BitcoinWallet
//
//  Created by Oleksii on 21.08.2025.
//

import UIKit
import Combine

class RootViewController: UIViewController {
    
    // Imagin it is from VM and model
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
            .receive(on: RunLoop.main)
            .removeDuplicates()
            .compactMap { $0 }
            .map { String(format: "%.4f", $0) }
            .map { "💰 \($0)$" }
            .sink { [weak label] rate in
                label?.text = rate
            }
            .store(in: &cancellables)
    }
}
