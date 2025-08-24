//
//  AddTransactionButtonsViewController.swift
//  BitcoinWallet
//
//  Created by Oleksii on 24.08.2025.
//

import UIKit

class AddTransactionButtonsViewController: UIViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.backgroundColor = .clear

        let mocksButton = makeButton(title: "Mocks")
        mocksButton.addTarget(self,
                              action: #selector(didTapMocks),
                              for: .touchUpInside)
        
        let depositButton = makeButton(title: "Deposit")
        depositButton.addTarget(self,
                                action: #selector(didTapDeposit),
                                for: .touchUpInside)

        let withdrawButton = makeButton(title: "Withdraw")
        withdrawButton.addTarget(self,
                                 action: #selector(didTapWithdraw),
                                 for: .touchUpInside)
        
        let stackView = UIStackView(arrangedSubviews: [mocksButton,
                                                       depositButton,
                                                       withdrawButton])
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                               constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                constant: -16),
            mocksButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func makeButton(title: String) -> UIButton {
        
        let button = UIButton(type: .system)
        
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .SF.font(size: 16, weight: .semibold)
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        button.layer.cornerRadius = 8
        
        return button
    }
    
    @objc private func didTapMocks() {
        print("didTapMocks")
    }
    
    @objc private func didTapDeposit() {
        print("didTapDeposit")
    }
    
    @objc private func didTapWithdraw() {
        print("didTapWithdraw")
    }
}
