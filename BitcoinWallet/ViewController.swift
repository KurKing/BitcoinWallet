//
//  ViewController.swift
//  BitcoinWallet
//
//  Created by Oleksii on 21.08.2025.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.backgroundColor = .cyan
        
        let label = UILabel()
        label.text = "Hello, World!"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .SF.font(size: 36, weight: .bold)
        label.textColor = .black
        
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}
