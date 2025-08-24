//
//  TransactionsViewController.swift
//  BitcoinWallet
//
//  Created by Oleksii on 24.08.2025.
//

import Foundation
import UIKit
import Combine

class TransactionsViewController: UIViewController {
    
    private let viewModel: TransactionsViewModel
    private var tableView: UITableView?
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(viewModel: TransactionsViewModel = DefaultTransactionsViewModel()) {
        
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupTableView()
        bindViewModel()
    }
    
    private func setupTableView() {
        
        let tableView = UITableView()
        
        tableView.backgroundColor = .white
        
        UILabel.appearance(whenContainedInInstancesOf: [UITableViewHeaderFooterView.self]).textColor = .systemBlue

        tableView.tintColor = .systemBlue
        tableView.separatorStyle = .singleLine
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TransactionCell.self, forCellReuseIdentifier: TransactionCell.reuseId)
        
        self.tableView = tableView
    }
    
    private func bindViewModel() {
        
        viewModel.items
            .throttle(for: .seconds(1), scheduler: RunLoop.main, latest: true)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView?.reloadData()
            }
            .store(in: &cancellables)
    }
}

// MARK: - UITableViewDataSource
extension TransactionsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.items.value.count
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        viewModel.items.value[safe: section]?.transactions.count ?? 0
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let section = viewModel.items.value[safe: indexPath.section],
              let item = section.transactions[safe: indexPath.row],
              let cell = tableView.dequeueReusableCell(
                withIdentifier: TransactionCell.reuseId,
                for: indexPath) as? TransactionCell else {
            
            return UITableViewCell()
        }
        
        cell.configure(with: item)
        return cell
    }
}


// MARK: - UITableViewDelegate
extension TransactionsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   titleForHeaderInSection section: Int) -> String? {
        
        guard let section = viewModel.items.value[safe: section] else {
            return nil
        }
        return section.day
    }
    
    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {
        
        guard let section = viewModel.items.value[safe: section] else {
            return nil
        }
        
        let header = UITableViewHeaderFooterView()
        
        var config = header.defaultContentConfiguration()
        config.text =  section.day
        config.textProperties.color = .systemBlue
        
        header.contentConfiguration = config
        header.contentView.backgroundColor = .white
        
        return header
    }
}
