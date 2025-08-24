//
//  AddTransactionScreenViewModel.swift
//  BitcoinWallet
//
//  Created by Oleksii on 24.08.2025.
//

import Foundation
import Combine

protocol AddTransactionScreenViewModel: AddTransactionViewModel {
    
    var isAddButtonEnabled: CurrentValueSubject<Bool, Never> { get }
    
    var amount: CurrentValueSubject<String, Never> { get }
    var name: CurrentValueSubject<String, Never> { get }
    var category: CurrentValueSubject<String, Never> { get }
    
    func add() async
}

class DefaultAddTransactionScreenViewModel: DefaultAddTransactionViewModel,
                                            AddTransactionScreenViewModel {
    
    var isAddButtonEnabled: CurrentValueSubject<Bool, Never> { isValid }
    private let isValid = CurrentValueSubject<Bool, Never>(false)
    
    let amount = CurrentValueSubject<String, Never>("")
    let name = CurrentValueSubject<String, Never>("")
    let category = CurrentValueSubject<String, Never>("")
    
    private var cancellables: Set<AnyCancellable> = []
    
    override init(model: AddTransactionModel = DefaultAddTransactionModel()) {
        
        super.init(model: model)
        
        setupBindings()
    }
    
    func add() async {
        
        guard isValid.value else { return }
        
        let amount = amount.value.trimmingCharacters(in: .whitespacesAndNewlines)
        let category = category.value.trimmingCharacters(in: .whitespacesAndNewlines)
        let name = name.value.trimmingCharacters(in: .whitespacesAndNewlines)
        
        await add(transaction:
                .init(
                    amount: amount,
                    categoryName: category,
                    date: "",
                    name: name,
                    type: .withdrawal
                )
        )
    }
    
    private func setupBindings() {
        
        Publishers.CombineLatest3(amount, name, category)
            .map { amount, name, category in
                if let decimal = Decimal(string: amount), decimal > 0,
                   !name.trimmingCharacters(in: .whitespaces).isEmpty,
                   !category.isEmpty {
                    return true
                }
                return false
            }
            .sink { [weak self] isValid in
                self?.isValid.send(isValid)
            }
            .store(in: &cancellables)
    }
}
