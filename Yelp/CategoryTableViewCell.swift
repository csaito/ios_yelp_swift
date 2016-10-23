//
//  CategoryTableViewCell.swift
//  Yelp
//
//  Created by Chihiro Saito on 10/22/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var onOffSwitch: UISwitch!
    
    weak var switchDelegate: CategorySwitchDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        //super.setSelected(selected, animated: animated)
    }
    
    @IBAction func onOffSwitchToggled(_ sender: AnyObject) {
        self.switchDelegate?.categorySwitchDidToggle(self, newValue: onOffSwitch.isOn)
    }

}

protocol CategorySwitchDelegate: class {
    func categorySwitchDidToggle(_ cell: CategoryTableViewCell, newValue:Bool)
}
