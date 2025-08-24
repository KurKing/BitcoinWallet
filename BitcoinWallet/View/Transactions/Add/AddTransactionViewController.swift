//
//  AddTransactionViewController.swift
//  BitcoinWallet
//
//  Created by Oleksii on 24.08.2025.
//

import UIKit
import Combine

class AddTransactionViewController: UIViewController {
    
    private let viewModel: AddTransactionScreenViewModel
    
    private let amountField = UITextField()
    private let nameField = UITextField()
    private let categoryPicker = UIPickerView()
    private let doneButton = UIButton(type: .system)
    
    private let categories = ["Groceries", "Taxi", "Electronics", "Restaurant", "Other"]
    private var selectedCategory: String?
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(viewModel: AddTransactionScreenViewModel = DefaultAddTransactionScreenViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 240/255,
                                       green: 240/255,
                                       blue: 240/255,
                                       alpha: 1)
        
        title = "Add Transaction"
        setupUI()
    }
    
    private func setupUI() {
        
        // Amount field
        amountField.attributedPlaceholder
        = NSAttributedString(string: "Enter amount (BTC)",
                             attributes: [.foregroundColor: UIColor(white: 0, alpha: 0.5)])
        amountField.keyboardType = .decimalPad
        amountField.borderStyle = .roundedRect
        amountField.translatesAutoresizingMaskIntoConstraints = false
        amountField.textColor = .black
        amountField.backgroundColor = .white
        nameField.addTarget(self,
                            action: #selector(amountTextFieldDidChanged),
                            for: .editingChanged)
        
        // Name field
        nameField.attributedPlaceholder
        = NSAttributedString(string: "Enter transaction name",
                             attributes: [.foregroundColor: UIColor(white: 0, alpha: 0.5)])
        nameField.borderStyle = .roundedRect
        nameField.translatesAutoresizingMaskIntoConstraints = false
        nameField.textColor = .black
        nameField.backgroundColor = .white
        nameField.addTarget(self,
                            action: #selector(nameTextFieldDidChanged),
                            for: .editingChanged)
        
        // Picker
        categoryPicker.dataSource = self
        categoryPicker.delegate = self
        categoryPicker.translatesAutoresizingMaskIntoConstraints = false
        categoryPicker.backgroundColor = .white
        categoryPicker.tintColor = .black
        categoryPicker.clipsToBounds = true
        categoryPicker.layer.cornerRadius = 8
        
        // Default category
        selectedCategory = categories.first
        
        // Done button
        doneButton.setTitle("Add", for: .normal)
        doneButton.titleLabel?.font = .SF.font(size: 18, weight: .semibold)
        doneButton.backgroundColor = .systemBlue
        doneButton.tintColor = .white
        doneButton.layer.cornerRadius = 8
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        
        viewModel.isAddButtonEnabled
            .receive(on: DispatchQueue.main)
            .sink { [weak doneButton] isEnabled in
                
                doneButton?.isEnabled = isEnabled
                doneButton?.alpha = isEnabled ? 1 : 0.6
            }
            .store(in: &cancellables)
        
        // StackView
        let stack = UIStackView(arrangedSubviews: [amountField, nameField, categoryPicker, doneButton])
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            doneButton.heightAnchor.constraint(equalToConstant: 50),
            amountField.heightAnchor.constraint(equalToConstant: 44),
            nameField.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    @objc private func doneButtonTapped() {
        
        guard viewModel.isAddButtonEnabled.value else { return }
        
        Task { [weak self] in
            
            await self?.viewModel.add()
            
            self?.dismiss(animated: true)
        }
    }
    
    @objc private func amountTextFieldDidChanged() {
        viewModel.amount.send(amountField.text ?? "")
    }
    
    @objc private func nameTextFieldDidChanged() {
        viewModel.name.send(nameField.text ?? "")
    }
}

// MARK: - UIPickerViewDataSource & Delegate
extension AddTransactionViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }
    
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    attributedTitleForRow row: Int,
                    forComponent component: Int) -> NSAttributedString? {
        NSAttributedString(
            string: categories[row],
            attributes: [.foregroundColor: UIColor.black]
        )
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        viewModel.category.send(categories[row])
    }
}
