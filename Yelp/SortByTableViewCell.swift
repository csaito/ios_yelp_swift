//
//  SortByTableViewCell.swift
//  Yelp
//
//  Created by Chihiro Saito on 10/22/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class SortByTableViewCell: UITableViewCell {

    @IBOutlet weak var sortByLabel: UILabel!
    @IBOutlet weak var sortByButton: UIButton!
    
    weak var buttonDelegate: SortByButtonDelegate?
    
    var sortMode: YelpSortMode! {
        didSet {
            if (sortMode == YelpSortMode.bestMatched) {
                sortByLabel.text = "Best Match"
            }
            if (sortMode == YelpSortMode.distance) {
                sortByLabel.text = "Distance"
            }
            if (sortMode == YelpSortMode.highestRated) {
                sortByLabel.text = "Highest Rated"
            }
        }
    }
    
    var isButtonSelected: Bool! {
        didSet {
            sortByButton.backgroundColor = isButtonSelected == true ? UIColor.red : UIColor.lightGray
            
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.sortByButton.layer.cornerRadius = 16
    }
    
    @IBAction func sortByButtonClicked(_ sender: AnyObject) {
        if (!self.isButtonSelected) {
            // Don't allow unselecting (we need one item to be selected at any given moment)
            self.isButtonSelected = !self.isButtonSelected;
            self.buttonDelegate?.sortByButtonDidToggle(self, newValue: self.isButtonSelected)
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        //super.setSelected(selected, animated: animated)
    }

}

protocol SortByButtonDelegate: class {
    func sortByButtonDidToggle(_ cell: SortByTableViewCell, newValue:Bool)
}
