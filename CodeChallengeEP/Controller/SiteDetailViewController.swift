//
//  SiteDetailViewController.swift
//  CodeChallengeEP
//
//  Created by Sammy Alonso Calle Torres on 3/9/24.
//

import UIKit

class SiteDetailViewController: UIViewController {
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ChargerCell")
        return tableView
    }()
    
    var site: Site?
    var chargers: ChargersResponse?
    var siteID : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        setTableContraints()
        fetchChargers()
    }
    
    func setTableContraints() {
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo : self.view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo : self.view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo : self.view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo : self.view.trailingAnchor).isActive = true
    }
    
    private func fetchChargers() {
        guard let chargersURL = URL(string: "https://sammycalle.github.io/mockFileEP/chargers.json") else { return }
        
        NetworkManager.shared.fetchData(from: chargersURL) { [weak self] (result: Result<ChargersResponse, Error>) in
            switch result {
            case .success(let fetchedChargers):
                if let siteID = self?.siteID {
                    let filteredChargers = fetchedChargers.chargers.filter { $0.siteID == siteID }
                    self?.chargers = ChargersResponse(chargers: filteredChargers)
                } else {
                    self?.chargers = fetchedChargers
                }
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print("Failed to fetch chargers: \(error)")
            }
        }
    }
}


extension SiteDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chargers?.chargers.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChargerCell", for: indexPath)
        if let charger = chargers?.chargers[indexPath.row] {
            
            cell.textLabel?.text = charger.id
            
        }
        
        return cell
    }
}
