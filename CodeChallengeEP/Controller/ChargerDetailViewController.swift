//
//  ChargerDetailView.swift
//  CodeChallengeEP
//
//  Created by Sammy Alonso Calle Torres on 3/12/24.
//

import UIKit

class ChargerDetailViewController: UIViewController {
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Test")
        return tableView
    }()
    
    var connectors: [Connector] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure table view
        tableView.dataSource = self
        setTableContraints()
    }
    
    func setTableContraints() {
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo : self.view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo : self.view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo : self.view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo : self.view.trailingAnchor).isActive = true
    }
}
extension ChargerDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return connectors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Test", for: indexPath)
        
        let charger = connectors[indexPath.row]
        
        // Configure cell text
        cell.textLabel?.text = "Charger ID: \(charger.id)"
        
        // Change cell background color based on charger status
        switch charger.status {
        case 0:
            // Status 0, change cell background color to green
            cell.backgroundColor = .green
        case 1:
            // Status 1, change cell background color to yellow
            cell.backgroundColor = .blue
        case 2:
            // Status 2, change cell background color to red
            cell.backgroundColor = .red
        default:
            cell.backgroundColor = .brown
        }
        
        return cell
    }
}
