//
//  DistanceTableViewCell.swift
//  Yelp
//
//  Created by Chihiro Saito on 10/22/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class DistanceTableViewCell: UITableViewCell {

    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var distanceButton: UIButton!
    
    weak var buttonDelegate: DistanceButtonDelegate?
    
    var distanceInMiles: Double! {
        didSet {
            if (distanceInMiles == 0) {
                distanceLabel.text = "Auto"
            } else {
                let suffix = (distanceInMiles! == 1) ? " mile" : " miles"
                distanceLabel?.text = "\(distanceInMiles!)" + suffix
            }
        }
    }
    
    var isButtonSelected: Bool! {
        didSet {
            distanceButton.backgroundColor = isButtonSelected == true ? UIColor.red : UIColor.lightGray
        }
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        //super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.distanceButton.layer.cornerRadius = 16
    }
    
    @IBAction func buttonClicked(_ sender: AnyObject) {
        self.isButtonSelected = !isButtonSelected;
        self.buttonDelegate?.distanceButtonDidToggle(self, newValue: self.isButtonSelected)
    }

}

protocol DistanceButtonDelegate: class {
    func distanceButtonDidToggle(_ cell: DistanceTableViewCell, newValue:Bool)
}
