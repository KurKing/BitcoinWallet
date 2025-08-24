//
//  AddTransactionButtonsViewController.swift
//  BitcoinWallet
//
//  Created by Oleksii on 24.08.2025.
//

import UIKit

class AddTransactionButtonsViewController: UIViewController {
    
    private let viewModel: AddTransactionButtonsViewModel
    private let router = AddTransactionRouter()
    
    init(viewModel: AddTransactionButtonsViewModel =
         DefaultAddTransactionButtonsViewModel()) {
        
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        viewModel.addMocks()
    }
    
    @objc private func didTapDeposit() {
        
        router.requestDepositAmount(context: self) { [weak self] deposit in
            
            Task { [weak self] in
                
                await self?.viewModel.addTransaction(with: "Deposit",
                                                     categoryName: "",
                                                     amount:deposit,
                                                     date: Date(),
                                                     type: .deposit)
            }
        }
    }
    
    @objc private func didTapWithdraw() {
        router.routeToAddTransaction(context: self)
    }
}
