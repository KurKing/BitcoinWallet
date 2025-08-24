//
//  TransactionCell.swift
//  BitcoinWallet
//
//  Created by Oleksii on 24.08.2025.
//

import UIKit

class TransactionCell: UITableViewCell {
    
    static let reuseId = "TransactionCell"
    
    private let nameLabel = UILabel()
    private let categoryLabel = UILabel()
    private let amountLabel = UILabel()
    private let dateLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        
        super.prepareForReuse()
        
        nameLabel.text = ""
        categoryLabel.text = ""
        dateLabel.text = ""
        amountLabel.text = ""
        amountLabel.textColor = .black
    }
    
    private func setupUI() {
        
        backgroundColor = .init(white: 0, alpha: 0.05)
        contentView.backgroundColor = .white
        selectionStyle = .none
        
        [nameLabel, categoryLabel, dateLabel]
            .forEach({
                
                $0.textColor = .black
                $0.font = .SF.font(size: 11, weight: .regular)
                $0.textAlignment = .center
            })
        nameLabel.font = .SF.font(size: 14, weight: .semibold)
        nameLabel.clipsToBounds = true
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.numberOfLines = 1
        nameLabel.minimumScaleFactor = 0.5
        nameLabel.lineBreakMode = .byTruncatingTail
        
        let stack = UIStackView(arrangedSubviews: [nameLabel,
                                                   categoryLabel,
                                                   dateLabel])
        stack.axis = .horizontal
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillEqually
        
        contentView.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentView.topAnchor,
                                       constant: 8),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                           constant: 16),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                            constant: -16),
        ])
        
        amountLabel.textAlignment = .right
        amountLabel.font = .SF.font(size: 16, weight: .bold)
        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(amountLabel)
        NSLayoutConstraint.activate([
            amountLabel.topAnchor.constraint(equalTo: stack.bottomAnchor,
                                             constant: 8),
            amountLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                                constant: -4),
            amountLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                 constant: 16),
            amountLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                  constant: -16),
        ])
    }
    
    func configure(with item: TransactionsViewItem) {
        
        nameLabel.text = item.name
        categoryLabel.text = item.categoryName
        dateLabel.text = item.date
        amountLabel.text = item.amount
        amountLabel.textColor = item.type == .deposit ? .systemGreen : .systemRed
    }
}
