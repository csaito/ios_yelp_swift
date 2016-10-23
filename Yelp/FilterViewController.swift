//
//  FilterViewController.swift
//  Yelp
//
//  Created by Chihiro Saito on 10/22/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController {

    @IBOutlet weak var filterTableView: UITableView!
    
    var headers = [ "Deal", "Distance", "Sort By", "Category" ]
    var searchSettings = YelpSearchSettings()
    
    let sortBySectionData = [ YelpSortMode.bestMatched, YelpSortMode.distance, YelpSortMode.highestRated ]
    let distanceSectionData = [ 0, 0.3, 1, 3, 10, 25 ]
    
    // Radio button items
    var selectedDistanceCell : DistanceTableViewCell?
    var selectedSortByCell   : SortByTableViewCell?
    
    @IBAction func onOffSwitchToggled(_ sender: AnyObject) {
    }
    
    
    @IBAction func cancelClicked(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filterTableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension FilterViewController: UITableViewDataSource {
    
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numOfRows = 1;
        switch section {
        case 0 : break
        case 1: numOfRows = 6
            break
        case 2: numOfRows = 3
            break
        case 3: numOfRows = YelpSearchSettings().allCategories.count
            break
        default: break
        }
        return numOfRows
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var returnCell = UITableViewCell()
        
        switch (indexPath.section) {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DealTableCell", for: indexPath) as! DealTableViewCell
            setDealTableCell(cell, row: indexPath.row)
            returnCell = cell
            break
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DistanceTableCell", for: indexPath) as! DistanceTableViewCell
            setDistanceTableCell(cell, row: indexPath.row)
            returnCell = cell
            break
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SortByTableCell", for: indexPath) as! SortByTableViewCell
            setSortByTableCell(cell, row: indexPath.row)
            returnCell = cell
            break
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryTableCell", for: indexPath) as! CategoryTableViewCell
            setCategoryTableCell(cell, row: indexPath.row)
            returnCell = cell
            break
        default: break
        }
        
        return returnCell
    }
    
    public func tableView(_ tableView: UITableView,
                          titleForHeaderInSection section: Int) -> String? {
        return self.headers[section]
        
    }
    
    func setDealTableCell(_ cell: DealTableViewCell, row: Int) {
        cell.onOffSwitch.isOn = self.searchSettings.deals
        cell.switchDelegate = self
    }
    func setDistanceTableCell(_ cell: DistanceTableViewCell, row: Int) {
        cell.distanceInMiles = distanceSectionData[row]
        cell.isButtonSelected = (self.searchSettings.radius == cell.distanceInMiles)
        if (cell.isButtonSelected == true) {
            self.selectedDistanceCell = cell
        }
        cell.buttonDelegate = self
    }
    
    func setSortByTableCell(_ cell: SortByTableViewCell, row: Int) {
        cell.sortMode = sortBySectionData[row]
        cell.isButtonSelected = (self.searchSettings.sort == cell.sortMode)
        if (cell.isButtonSelected == true) {
            self.selectedSortByCell = cell
        }
        cell.buttonDelegate = self
    }
    
    func setCategoryTableCell(_ cell: CategoryTableViewCell, row: Int) {
        //if (row < self.searchSettings.allCategories.count) {
        cell.category = self.searchSettings.allCategories[row]
        //}
        let index =
            (self.searchSettings.categories.index(of:self.searchSettings.allCategories[row]["code"]!))
        if index != nil {
            cell.onOffSwitch.isOn = true
        } else {
            cell.onOffSwitch.isOn = false
        }
        cell.switchDelegate = self
    }
}

extension FilterViewController: DealSwitchDelegate {
    func switchDidToggle(_ cell: DealTableViewCell, newValue:Bool) {
        self.searchSettings.deals = newValue
    }
}

extension FilterViewController: DistanceButtonDelegate {
    func distanceButtonDidToggle(_ cell: DistanceTableViewCell, newValue:Bool){
        if (newValue == true) {
            if let currentCell = self.selectedDistanceCell {
                currentCell.isButtonSelected = false
            }
            self.selectedDistanceCell = cell
            self.searchSettings.radius = cell.distanceInMiles
        } else {
            self.searchSettings.radius = 0.0
        }
    }
}

extension FilterViewController: SortByButtonDelegate {
    func sortByButtonDidToggle(_ cell: SortByTableViewCell, newValue:Bool){
        if (newValue == true) {
            if let currentCell = self.selectedSortByCell {
                currentCell.isButtonSelected = false
            }
            self.selectedSortByCell = cell
            self.searchSettings.sort = cell.sortMode
        }
    }
}

extension FilterViewController: CategorySwitchDelegate {
    func categorySwitchDidToggle(_ cell: CategoryTableViewCell, newValue:Bool) {
        let categoryCode = cell.category["code"]
        if (newValue == true) {
            self.searchSettings.categories.append(categoryCode!)
        } else {
            if let index = self.searchSettings.categories.index(of: categoryCode!) {
                self.searchSettings.categories.remove(at: index)
            }
        }
    }
}
