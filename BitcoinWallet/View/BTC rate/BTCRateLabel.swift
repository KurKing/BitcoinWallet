//
//  BTCRateLabel.swift
//  BitcoinWallet
//
//  Created by Oleksii on 24.08.2025.
//

import UIKit
import Combine

class BTCRateLabel: UILabel {
    
    private let viewModel: BTCRateViewModel
    private var cancellables: Set<AnyCancellable> = []
    
    init(viewModel: BTCRateViewModel = DefaultBTCRateViewModel()) {
        
        self.viewModel = viewModel
        
        super.init(frame: .zero)
        
        textColor = .black
        font = .SF.font(size: 12, weight: .regular)
        
        bindViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bindViewModel() {
        
        viewModel.rate
            .throttle(for: .seconds(1), scheduler: RunLoop.main, latest: true)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] rate in
                
                self?.text = rate
                self?.sizeToFit()
            }
            .store(in: &cancellables)
    }
}
