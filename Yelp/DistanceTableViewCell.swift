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
            let suffix = (distanceInMiles! == 0) ? " mile" : " miles"
            distanceLabel?.text = "\(distanceInMiles!)" + suffix
        }
    }
    
    var isButtonSelected: Bool! {
        didSet {
            distanceButton.backgroundColor = isButtonSelected == true ? UIColor.red : UIColor.lightGray
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.distanceButton.layer.cornerRadius = 16
    }

}

protocol DistanceButtonDelegate: class {
    func buttonDidToggle(_ cell: DistanceTableViewCell, newValue:Bool)
}
