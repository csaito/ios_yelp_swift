//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

import CircularSpinner

class BusinessesViewController: UIViewController {
    
    var businesses: [Business]!
    var searchedBusinesses: [Business]!
    var searchBar: UISearchBar!
    var searchSettings = YelpSearchSettings()
    var currentTerm = ""
    
    @IBOutlet weak var businessTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.businessTableView.dataSource = self
        self.businessTableView.estimatedRowHeight = 200
        self.businessTableView.rowHeight = UITableViewAutomaticDimension
        
        searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.sizeToFit()
        searchBar.placeholder = "Restaurants"
        navigationItem.titleView = searchBar
        
        CircularSpinner.trackBgColor = UIColor.red
        CircularSpinner.trackPgColor = UIColor.lightGray
        
        doSearch(append: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Perform the search.
    fileprivate func doSearch(append: Bool) {
        
        var offset = 0
        if (self.businesses != nil && append) {
            offset = self.businesses.count
        }
        self.searchSettings.offset = offset
        if (!append) {
            CircularSpinner.show(animated: true, type: CircularSpinnerType.indeterminate, showDismissButton: false, delegate: nil)
        }
 
        Business.searchWithTerm(term: self.currentTerm,
                                searchSettings: self.searchSettings,
                                    completion: { (businesses: [Business]?, error: Error?) -> Void in
                                        if (offset != 0) {
                                            if let unwrappedBusinesses = businesses {
                                                self.businesses! += unwrappedBusinesses
                                                self.searchedBusinesses! += unwrappedBusinesses
                                            }
                                        } else {
                                            self.businesses = businesses
                                            self.searchedBusinesses = businesses
                                        }
                                        self.businessTableView.reloadData()
                                        CircularSpinner.hide()
                }
        )
        
    }
    
    override func prepare(for segue: UIStoryboardSegue,
                          sender: Any?) {
        if segue.identifier == "ShowFilterControllerSegue" {
            let navigationController = segue.destination as! UINavigationController
            let filterViewController = navigationController.viewControllers[0] as! FilterViewController
            filterViewController.searchSettings = self.searchSettings
        } else if segue.identifier == "DetailsSegue" {
            let navigationController = segue.destination as! UINavigationController
            let detailsViewController = navigationController.viewControllers[0] as! DetailsViewController
            let selectedIndex = businessTableView.indexPath(for: sender as! UITableViewCell)!
            detailsViewController.business = self.searchedBusinesses![selectedIndex.row]
        }
    }
    
    @IBAction func saveFilterAndSearch(segue: UIStoryboardSegue) {
        self.searchSettings = (segue.source as! FilterViewController).searchSettings
        doSearch(append: false)
    }
    
}


// MARK: - UITableViewDataSource
extension BusinessesViewController: UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (searchedBusinesses != nil) ? searchedBusinesses.count : 0
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessTableViewCell", for: indexPath) as! BusinessTableViewCell
        
        let business = searchedBusinesses[indexPath.row]
        
        cell.nameLabel.text = business.name
        cell.reviewCountLabel.text = "\(business.reviewCount!) reviews"
        cell.addressLabel.text = business.address
        cell.categoriesLabel.text = business.categories
        cell.distanceLabel.text = business.distance
        if let businessImageUrl = business.imageURL {
            cell.businessImageView.setImageWith(businessImageUrl)
        } else {
            cell.businessImageView.image = nil
        }
        if let ratingImageUrl = business.ratingImageURL {
            cell.ratingImageView.setImageWith(ratingImageUrl)
        } else {
            cell.ratingImageView.image = nil
        }
        
        if (indexPath.row == self.businesses.count-1) {
            self.doSearch(append: true)
        }
        
        return cell
    }
    
}

// SearchBar methods
extension BusinessesViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(false, animated: true)
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        self.currentTerm = ""
        searchBar.resignFirstResponder()
        self.searchedBusinesses = self.businesses
        businessTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !((searchBar.text?.isEmpty)!) {
            self.currentTerm = searchBar.text!
            doSearch(append: false)
        } else {
            self.currentTerm = ""
        }
        searchBar.resignFirstResponder()
    }
    
    // This method updates filteredData based on the text in the Search Box
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // When there is no text, filteredData is the same as the original data
        if (searchBar.text?.isEmpty)! {
            self.searchedBusinesses = self.businesses
        } else {
            var filteredData = [Business]()
            for business in self.businesses {
                if let name = business.name {
                    let isRange = (name.range(of: searchText, options: .caseInsensitive) != nil)
                    if (isRange) {
                        filteredData.append(business)
                    }
                }
            }
            self.searchedBusinesses = filteredData
        }
        businessTableView.reloadData()
    }
}

