//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController {
    
    var businesses: [Business]!
    var searchedBusinesses: [Business]!
    var searchBar: UISearchBar!
    var searchSettings = YelpSearchSettings()
    
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
        
        doSearch(append: false)
        
        /* Example of Yelp search with more search options specified
         Business.searchWithTerm("Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
         self.businesses = businesses
         
         for business in businesses {
         print(business.name!)
         print(business.address!)
         }
         }
         */
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    // Perform the search.
    fileprivate func doSearch(append: Bool) {
        
        var offset = 0
        if (self.businesses != nil && append) {
            offset = self.businesses.count
        }
        
        Business.searchWithTerm(term: "Thai",
                                    sort: nil,
                                    categories: nil,
                                    deals: nil,
                                    limit: 20,
                                    offset: offset,
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
                }
        )
        
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
        searchBar.resignFirstResponder()
        self.searchedBusinesses = self.businesses
        businessTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchSettings.nameFilter = searchBar.text
        searchBar.resignFirstResponder()
        doSearch(append: false)
    }
    
    // This method updates filteredData based on the text in the Search Box
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // When there is no text, filteredData is the same as the original data
        if searchText.isEmpty {
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

