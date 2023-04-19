//
//  View.swift
//  CryptoViper
//
//  Created by melo on 3/2/23.
//

import Foundation
import UIKit

// talks to -> presenter
// Class, protocol
// ViewController

protocol AnyView {
    var presenter: AnyPresenter? { get set }
    
    func update(with cryptos: [Crypto])
    func update(with error: String)
}

class DetailViewController: UIViewController {
    var currency: String = ""
    var price: String = ""
    
    private let currencyLabel: UILabel = {
        let label = UILabel()
        label.isHidden = false
        label.text = "currency label"
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.isHidden = false
        label.text = "price label"
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        view.addSubview(currencyLabel)
        view.addSubview(priceLabel)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        currencyLabel.frame = CGRect(x: view.frame.width / 2 - 100, y: view.frame.height / 2 - 25, width: 200, height: 50)
        priceLabel.frame = CGRect(x: view.frame.width / 2 - 100, y: view.frame.height / 2 + 50, width: 200, height: 50)
        
        currencyLabel.text = currency
        priceLabel.text = price
    }
}

class CryptoViewController: UIViewController, AnyView, UITableViewDelegate, UITableViewDataSource {
    var presenter: AnyPresenter?
    
    var cryptos: [Crypto] = []
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.isHidden = true
        return table
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.isHidden = false
        label.text = "downloading..."
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemTeal
        
        view.addSubview(tableView)
        view.addSubview(messageLabel)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        messageLabel.frame = CGRect(x: view.frame.width / 2 - 100, y: view.frame.height / 2 - 25, width: 200, height: 50)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cryptos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = cryptos[indexPath.row].currency
        content.secondaryText = cryptos[indexPath.row].price
        cell.contentConfiguration = content
        cell.backgroundColor = UIColor(red: 163/255, green: 190/255, blue: 140/255, alpha: 1)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextViewController = DetailViewController()
        nextViewController.currency = cryptos[indexPath.row].currency
        nextViewController.price = cryptos[indexPath.row].price
        self.present(nextViewController, animated: true)
    }
    
    func update(with cryptos: [Crypto]) {
        DispatchQueue.main.async {
            self.cryptos = cryptos
            self.messageLabel.isHidden = true
            self.tableView.reloadData()
            self.tableView.isHidden = false
        }
    }
    
    func update(with error: String) {
        DispatchQueue.main.async {
            self.cryptos = []
            self.tableView.isHidden = true
            self.messageLabel.text = error
            self.messageLabel.isHidden = false
        }
    }
}
