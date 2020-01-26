//
//  ViewController.swift
//  Countries Filtering
//
//  Created by Luis Segoviano on 23/01/20.
//  Copyright © 2020 The Segoviano. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, UISearchControllerDelegate, UISearchResultsUpdating {

    fileprivate var filtered = [String]()
    
    fileprivate var filterring = false
    
    lazy var countries: [String] = {
        var names = [String]()
        let current = NSLocale(localeIdentifier: "es_MX") // "en_US"
        for code in NSLocale.isoCountryCodes {
            let id = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: code])
            let name = current.displayName(forKey: NSLocale.Key.identifier, value: id)
            if let country = name {
                names.append(country)
            }
        }
        return names
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true // Navigation bar large titles
            navigationItem.title = "Countries"
            
            let searchController = UISearchController(searchResultsController: nil)
            searchController.searchResultsUpdater = self
            searchController.obscuresBackgroundDuringPresentation = false
            searchController.searchBar.placeholder = "Search Countries..."
            definesPresentationContext = true
            self.navigationItem.searchController = searchController
            
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filterring ? self.filtered.count : countries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = self.filterring ? self.filtered[indexPath.row] : self.countries[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let countrySelected = self.filterring ? self.filtered[indexPath.row] : self.countries[indexPath.row]
        print(" countrySelected ", countrySelected)
    }
    
    
    // MARK: Delegate de buscador
    
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text, !text.isEmpty {
            self.filtered = self.countries.filter({ (country) -> Bool in
                return country.lowercased().contains(text.lowercased())
            })
            self.filterring = true
        }
        else {
            self.filterring = false
            self.filtered = [String]()
        }
        self.tableView.reloadData()
    }
    

}

